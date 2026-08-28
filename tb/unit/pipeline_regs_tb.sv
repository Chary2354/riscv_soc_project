`timescale 1ns/1ps

module pipeline_regs_tb;

    logic clk;
    logic rst;
    logic stall;
    logic flush;

    logic [31:0] if_pc;
    logic [31:0] if_pc_plus4;
    logic [31:0] if_instr;

    logic [31:0] id_pc;
    logic [31:0] id_pc_plus4;
    logic [31:0] id_instr;

    logic [31:0] id_rs1_data;
    logic [31:0] id_rs2_data;
    logic [31:0] id_immediate;

    logic [4:0] id_rs1;
    logic [4:0] id_rs2;
    logic [4:0] id_rd;

    logic [31:0] id_pc_value;

    logic id_reg_write;
    logic id_mem_read;
    logic id_mem_write;
    logic id_mem_to_reg;
    logic id_alu_src;
    logic id_branch;
    logic id_jump;

    logic [3:0] id_alu_control;

    logic [31:0] ex_rs1_data;
    logic [31:0] ex_rs2_data;
    logic [31:0] ex_immediate;

    logic [4:0] ex_rs1;
    logic [4:0] ex_rs2;
    logic [4:0] ex_rd;

    logic [31:0] ex_pc;

    logic ex_reg_write;
    logic ex_mem_read;
    logic ex_mem_write;
    logic ex_mem_to_reg;
    logic ex_alu_src;
    logic ex_branch;
    logic ex_jump;

    logic [3:0] ex_alu_control;

    logic [31:0] ex_alu_result;
    logic [31:0] ex_store_data;

    logic [4:0] ex_mem_rd;

    logic ex_mem_reg_write;
    logic ex_mem_mem_read;
    logic ex_mem_mem_write;
    logic ex_mem_mem_to_reg;

    logic [31:0] mem_alu_result;
    logic [31:0] mem_store_data;

    logic [4:0] mem_rd;

    logic mem_reg_write;
    logic mem_mem_read;
    logic mem_mem_write;
    logic mem_mem_to_reg;

    logic [31:0] mem_read_data;
    logic [31:0] mem_wb_alu_result;

    logic [4:0] mem_wb_rd;

    logic mem_wb_reg_write;
    logic mem_wb_mem_to_reg;

    logic [31:0] wb_read_data;
    logic [31:0] wb_alu_result;

    logic [4:0] wb_rd;

    logic wb_reg_write;
    logic wb_mem_to_reg;


    pipeline_regs dut (
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .flush(flush),

        .if_pc(if_pc),
        .if_pc_plus4(if_pc_plus4),
        .if_instr(if_instr),

        .id_pc(id_pc),
        .id_pc_plus4(id_pc_plus4),
        .id_instr(id_instr),

        .id_rs1_data(id_rs1_data),
        .id_rs2_data(id_rs2_data),
        .id_immediate(id_immediate),

        .id_rs1(id_rs1),
        .id_rs2(id_rs2),
        .id_rd(id_rd),

        .id_pc_value(id_pc_value),

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

        .ex_mem_rd(ex_mem_rd),

        .ex_mem_reg_write(ex_mem_reg_write),
        .ex_mem_mem_read(ex_mem_mem_read),
        .ex_mem_mem_write(ex_mem_mem_write),
        .ex_mem_mem_to_reg(ex_mem_mem_to_reg),

        .mem_alu_result(mem_alu_result),
        .mem_store_data(mem_store_data),

        .mem_rd(mem_rd),

        .mem_reg_write(mem_reg_write),
        .mem_mem_read(mem_mem_read),
        .mem_mem_write(mem_mem_write),
        .mem_mem_to_reg(mem_mem_to_reg),

        .mem_read_data(mem_read_data),
        .mem_wb_alu_result(mem_wb_alu_result),

        .mem_wb_rd(mem_wb_rd),

        .mem_wb_reg_write(mem_wb_reg_write),
        .mem_wb_mem_to_reg(mem_wb_mem_to_reg),

        .wb_read_data(wb_read_data),
        .wb_alu_result(wb_alu_result),

        .wb_rd(wb_rd),

        .wb_reg_write(wb_reg_write),
        .wb_mem_to_reg(wb_mem_to_reg)
    );


    always #5 clk = ~clk;


    initial begin

        $display("====================================");
        $display(" Pipeline Register Test");
        $display("====================================");

        clk = 0;
        rst = 1;
        stall = 0;
        flush = 0;

        if_pc = 0;
        if_pc_plus4 = 0;
        if_instr = 0;

        id_rs1_data = 0;
        id_rs2_data = 0;
        id_immediate = 0;

        id_rs1 = 0;
        id_rs2 = 0;
        id_rd = 0;
        id_pc_value = 0;

        id_reg_write = 0;
        id_mem_read = 0;
        id_mem_write = 0;
        id_mem_to_reg = 0;
        id_alu_src = 0;
        id_branch = 0;
        id_jump = 0;
        id_alu_control = 0;

        ex_alu_result = 0;
        ex_store_data = 0;
        ex_mem_rd = 0;

        ex_mem_reg_write = 0;
        ex_mem_mem_read = 0;
        ex_mem_mem_write = 0;
        ex_mem_mem_to_reg = 0;

        mem_read_data = 0;
        mem_wb_alu_result = 0;
        mem_wb_rd = 0;

        mem_wb_reg_write = 0;
        mem_wb_mem_to_reg = 0;


        // Reset
        #12;

        rst = 0;


        // ==========================================
        // IF/ID test
        // ==========================================

        @(negedge clk);

        if_pc = 32'h00001000;
        if_pc_plus4 = 32'h00001004;
        if_instr = 32'h12345678;

        @(posedge clk);
        #1;

        if ((id_pc == 32'h00001000) &&
            (id_pc_plus4 == 32'h00001004) &&
            (id_instr == 32'h12345678))

            $display("PASS: IF/ID register");

        else
            $display("FAIL: IF/ID register");


        // ==========================================
        // ID/EX test
        // ==========================================

        @(negedge clk);

        id_rs1_data = 32'h11111111;
        id_rs2_data = 32'h22222222;
        id_immediate = 32'h33333333;

        id_rs1 = 5'd3;
        id_rs2 = 5'd4;
        id_rd = 5'd5;

        id_pc_value = 32'h00002000;

        id_reg_write = 1;
        id_mem_read = 1;
        id_alu_src = 1;

        id_alu_control = 4'b0010;

        @(posedge clk);
        #1;

        if ((ex_rs1_data == 32'h11111111) &&
            (ex_rs2_data == 32'h22222222) &&
            (ex_immediate == 32'h33333333) &&
            (ex_rd == 5'd5) &&
            (ex_reg_write == 1'b1))

            $display("PASS: ID/EX register");

        else
            $display("FAIL: ID/EX register");


        // ==========================================
        // EX/MEM test
        // ==========================================

        @(negedge clk);

        ex_alu_result = 32'hAAAAAAAA;
        ex_store_data = 32'hBBBBBBBB;
        ex_mem_rd = 5'd10;

        ex_mem_reg_write = 1;
        ex_mem_mem_write = 1;

        @(posedge clk);
        #1;

        if ((mem_alu_result == 32'hAAAAAAAA) &&
            (mem_store_data == 32'hBBBBBBBB) &&
            (mem_rd == 5'd10) &&
            (mem_reg_write == 1'b1))

            $display("PASS: EX/MEM register");

        else
            $display("FAIL: EX/MEM register");


        // ==========================================
        // MEM/WB test
        // ==========================================

        @(negedge clk);

        mem_read_data = 32'hCCCCCCCC;
        mem_wb_alu_result = 32'hDDDDDDDD;
        mem_wb_rd = 5'd15;

        mem_wb_reg_write = 1;

        @(posedge clk);
        #1;

        if ((wb_read_data == 32'hCCCCCCCC) &&
            (wb_alu_result == 32'hDDDDDDDD) &&
            (wb_rd == 5'd15) &&
            (wb_reg_write == 1'b1))

            $display("PASS: MEM/WB register");

        else
            $display("FAIL: MEM/WB register");


        // ==========================================
        // Flush test
        // ==========================================

        @(negedge clk);

        flush = 1;

        @(posedge clk);
        #1;

        if ((id_instr == 32'b0) &&
            (ex_rd == 5'b0) &&
            (ex_reg_write == 1'b0))

            $display("PASS: Pipeline flush");

        else
            $display("FAIL: Pipeline flush");

        flush = 0;


        $display("====================================");
        $display("Pipeline Register Test Completed");
        $display("====================================");

        $finish;

    end

endmodule