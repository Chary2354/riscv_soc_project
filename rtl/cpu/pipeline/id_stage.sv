module id_stage (
    input logic        clk,
    input logic        rst,

    input logic [31:0] instruction,
    input logic [31:0] pc,

    input logic        wb_reg_write,
    input logic [4:0]  wb_rd,
    input logic [31:0] wb_write_data,

    output logic [4:0]  rs1,
    output logic [4:0]  rs2,
    output logic [4:0]  rd,

    output logic [31:0] rs1_data,
    output logic [31:0] rs2_data,

    output logic [31:0] immediate,

    output logic        reg_write,
    output logic        mem_read,
    output logic        mem_write,
    output logic        mem_to_reg,
    output logic        alu_src,
    output logic        branch,
    output logic        jump,

    output logic [1:0]  alu_op
);

    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];
    assign rd  = instruction[11:7];

    // Register File
    regfile rf (
        .clk(clk),
        .rst(rst),
        .rs1(rs1),
        .rs2(rs2),
        .rd(wb_rd),
        .write_data(wb_write_data),
        .reg_write(wb_reg_write),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );

    // Immediate Generator
    immediate_generator imm_gen (
        .instr(instruction),
        .immediate(immediate)
    );

    // Control Unit
    control_unit ctrl (
        .opcode(instruction[6:0]),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .alu_src(alu_src),
        .branch(branch),
        .jump(jump),
        .alu_op(alu_op)
    );

endmodule