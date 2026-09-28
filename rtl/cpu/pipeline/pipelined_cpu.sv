module pipelined_cpu (
    input logic clk,
    input logic rst,

    output logic        mem_read,
    output logic        mem_write,
    output logic [31:0] mem_address,
    output logic [31:0] mem_write_data,
    input  logic [31:0] mem_read_data,

    output logic [31:0] debug_pc,
    output logic [31:0] debug_wb_data,
    output logic [4:0]  debug_wb_rd,
    output logic        debug_wb_reg_write
);

    // =========================================================
    // IF STAGE
    // =========================================================

    logic        pc_write;
    logic        branch_taken;
    logic [31:0] branch_target;

    logic [31:0] if_pc;
    logic [31:0] if_pc_plus4;
    logic [31:0] if_instruction;

    if_stage u_if (
        .clk          (clk),
        .rst          (rst),
        .pc_write     (pc_write),
        .branch_taken (branch_taken),
        .branch_target(branch_target),
        .pc           (if_pc),
        .pc_plus4     (if_pc_plus4),
        .instruction  (if_instruction)
    );

    // =========================================================
    // IF/ID SIGNALS
    // =========================================================

    logic [31:0] id_pc;
    logic [31:0] id_pc_plus4;
    logic [31:0] id_instruction;

    // =========================================================
    // ID STAGE
    // =========================================================

    logic [4:0] id_rs1;
    logic [4:0] id_rs2;
    logic [4:0] id_rd;

    logic [31:0] id_rs1_data;
    logic [31:0] id_rs2_data;
    logic [31:0] id_immediate;

    logic        id_reg_write;
    logic        id_mem_read;
    logic        id_mem_write;
    logic        id_mem_to_reg;
    logic        id_alu_src;
    logic        id_branch;
    logic        id_jump;

    logic [1:0] id_alu_op;

    // =========================================================
    // WRITEBACK SIGNALS
    // =========================================================

    logic [31:0] wb_write_data;

    id_stage u_id (
        .clk          (clk),
        .rst          (rst),
        .instruction  (id_instruction),
        .pc           (id_pc),

        .wb_reg_write (wb_reg_write),
        .wb_rd        (wb_rd),
        .wb_write_data(wb_write_data),

        .rs1          (id_rs1),
        .rs2          (id_rs2),
        .rd           (id_rd),

        .rs1_data     (id_rs1_data),
        .rs2_data     (id_rs2_data),

        .immediate    (id_immediate),

        .reg_write    (id_reg_write),
        .mem_read     (id_mem_read),
        .mem_write    (id_mem_write),
        .mem_to_reg   (id_mem_to_reg),
        .alu_src      (id_alu_src),
        .branch       (id_branch),
        .jump         (id_jump),
        .alu_op       (id_alu_op)
    );

    // =========================================================
    // Convert existing 2-bit ALU operation to 4-bit ALU code
    // =========================================================

    logic [3:0] id_alu_control;

    always_comb begin
        case (id_alu_op)
            2'b00: id_alu_control = 4'b0000; // ADD
            2'b01: id_alu_control = 4'b0001; // SUB
            2'b10: id_alu_control = 4'b0010; // logical/ALU class
            default: id_alu_control = 4'b0000;
        endcase
    end

    // =========================================================
    // HAZARD DETECTION
    // =========================================================

    logic        if_id_write;
    logic        control_stall;

    logic [4:0] ex_rs1;
    logic [4:0] ex_rs2;
    logic [4:0] ex_rd;

    logic        ex_mem_read;

    hazard_detection u_hazard (
        .id_ex_mem_read(ex_mem_read),
        .id_ex_rd      (ex_rd),
        .if_id_rs1     (id_rs1),
        .if_id_rs2     (id_rs2),
        .pc_write      (pc_write),
        .if_id_write   (if_id_write),
        .control_stall(control_stall)
    );

    // =========================================================
    // ID/EX SIGNALS
    // =========================================================

    logic [31:0] ex_rs1_data;
    logic [31:0] ex_rs2_data;
    logic [31:0] ex_immediate;
    logic [31:0] ex_pc;

    logic        ex_reg_write;
    logic        ex_mem_write;
    logic        ex_mem_to_reg;
    logic        ex_alu_src;
    logic        ex_branch;
    logic        ex_jump;
    logic [3:0]  ex_alu_control;

    // =========================================================
    // FORWARDING
    // =========================================================

    logic [1:0] forward_a;
    logic [1:0] forward_b;

    logic [4:0] mem_rd;
    logic [4:0] wb_rd;

    logic mem_reg_write;
    logic wb_reg_write;

    logic [31:0] mem_alu_result;

    forwarding_unit u_forward (
        .id_ex_rs1     (ex_rs1),
        .id_ex_rs2     (ex_rs2),

        .ex_mem_rd     (mem_rd),
        .ex_mem_reg_write(mem_reg_write),

        .mem_wb_rd     (wb_rd),
        .mem_wb_reg_write(wb_reg_write),

        .forward_a     (forward_a),
        .forward_b     (forward_b)
    );

    logic [31:0] ex_forward_a;
    logic [31:0] ex_forward_b;

    always_comb begin
        case (forward_a)
            2'b10: ex_forward_a = mem_alu_result;
            2'b01: ex_forward_a = wb_write_data;
            default: ex_forward_a = ex_rs1_data;
        endcase

        case (forward_b)
            2'b10: ex_forward_b = mem_alu_result;
            2'b01: ex_forward_b = wb_write_data;
            default: ex_forward_b = ex_rs2_data;
        endcase
    end

    // =========================================================
    // EX STAGE
    // =========================================================

    logic [31:0] ex_alu_result;
    logic [31:0] ex_store_data;
    logic        ex_zero;

    ex_stage u_ex (
        .rs1_data  (ex_forward_a),
        .rs2_data  (ex_forward_b),
        .immediate (ex_immediate),
        .alu_src   (ex_alu_src),
        .alu_op    (ex_alu_control),
        .alu_result(ex_alu_result),
        .store_data(ex_store_data),
        .zero      (ex_zero)
    );

    // =========================================================
    // BRANCH UNIT
    // =========================================================

    branch_unit u_branch (
        .pc          (ex_pc),
        .rs1_data    (ex_forward_a),
        .rs2_data    (ex_forward_b),
        .immediate   (ex_immediate),
        .branch      (ex_branch),
        .jump        (ex_jump),
        .branch_taken(branch_taken),
        .branch_target(branch_target)
    );

    // =========================================================
    // EX/MEM + MEM/WB PIPELINE REGISTERS
    // =========================================================

    logic [31:0] mem_store_data;
    logic        mem_mem_read;
    logic        mem_mem_write;
    logic        mem_mem_to_reg;

    logic [31:0] wb_read_data;
    logic [31:0] wb_alu_result;
    logic        wb_mem_to_reg;

    pipeline_regs u_pipeline_regs (
        .clk(clk),
        .rst(rst),

        .stall(control_stall),
        .flush(branch_taken),

        .if_pc(if_pc),
        .if_pc_plus4(if_pc_plus4),
        .if_instr(if_instruction),

        .id_pc(id_pc),
        .id_pc_plus4(id_pc_plus4),
        .id_instr(id_instruction),

        .id_rs1_data(id_rs1_data),
        .id_rs2_data(id_rs2_data),
        .id_immediate(id_immediate),

        .id_rs1(id_rs1),
        .id_rs2(id_rs2),
        .id_rd(id_rd),

        .id_pc_value(id_pc),

        .id_reg_write(id_reg_write),
        .id_mem_read(id_mem_read),
        .id_mem_write(id_mem_write),
        .id_mem_to_reg(id_mem_to_reg),
        .id_alu_src(id_alu_src),
        .id_branch(id_branch),
        .id_jump(id_jump),

        .id_alu_control(id_alu_control),

        .ex_rs1_data(ex_rs1_data),
        .ex_rs2_data(ex_rs2_data),
        .ex_immediate(ex_immediate),

        .ex_rs1(ex_rs1),
        .ex_rs2(ex_rs2),
        .ex_rd(ex_rd),

        .ex_pc(ex_pc),

        .ex_reg_write(ex_reg_write),
        .ex_mem_read(ex_mem_read),
        .ex_mem_write(ex_mem_write),
        .ex_mem_to_reg(ex_mem_to_reg),
        .ex_alu_src(ex_alu_src),
        .ex_branch(ex_branch),
        .ex_jump(ex_jump),

        .ex_alu_control(ex_alu_control),

        .ex_alu_result(ex_alu_result),
        .ex_store_data(ex_store_data),

        .ex_mem_rd(ex_rd),

        .ex_mem_reg_write(ex_reg_write),
        .ex_mem_mem_read(ex_mem_read),
        .ex_mem_mem_write(ex_mem_write),
        .ex_mem_mem_to_reg(ex_mem_to_reg),

        .mem_alu_result(mem_alu_result),
        .mem_store_data(mem_store_data),

        .mem_rd(mem_rd),

        .mem_reg_write(mem_reg_write),
        .mem_mem_read(mem_mem_read),
        .mem_mem_write(mem_mem_write),
        .mem_mem_to_reg(mem_mem_to_reg),

        .mem_read_data(mem_read_data),
        .mem_wb_alu_result(mem_alu_result),

        .mem_wb_rd(mem_rd),

        .mem_wb_reg_write(mem_reg_write),
        .mem_wb_mem_to_reg(mem_mem_to_reg),

        .wb_read_data(wb_read_data),
        .wb_alu_result(wb_alu_result),

        .wb_rd(wb_rd),

        .wb_reg_write(wb_reg_write),
        .wb_mem_to_reg(wb_mem_to_reg)
    );

    // =========================================================
    // MEMORY STAGE
    // =========================================================

   logic [31:0] internal_mem_read_data;

   mem_stage u_mem (
        .clk      (clk),
        .rst      (rst),
        .mem_read (mem_mem_read),
        .mem_write(mem_mem_write),
        .address  (mem_alu_result),
        .write_data(mem_store_data),
        .read_data(internal_mem_read_data)
    );

    assign mem_read      = mem_mem_read;
    assign mem_write     = mem_mem_write;
    assign mem_address   = mem_alu_result;
    assign mem_write_data = mem_store_data;

    // =========================================================
    // WRITEBACK
    // =========================================================

        wb_stage u_wb (
        .alu_result (wb_alu_result),
        .memory_data(wb_read_data),
        .mem_to_reg (wb_mem_to_reg),
        .write_data (wb_write_data)
    );

    assign debug_pc        = if_pc;
    assign debug_wb_data   = wb_write_data;
    assign debug_wb_rd     = wb_rd;
    assign debug_wb_reg_write = wb_reg_write;

endmodule
