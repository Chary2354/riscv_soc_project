`timescale 1ns/1ps

module id_stage_tb;

    logic        clk;
    logic        rst;

    logic [31:0] instruction;
    logic [31:0] pc;

    logic        wb_reg_write;
    logic [4:0]  wb_rd;
    logic [31:0] wb_write_data;

    logic [4:0]  rs1;
    logic [4:0]  rs2;
    logic [4:0]  rd;

    logic [31:0] rs1_data;
    logic [31:0] rs2_data;

    logic [31:0] immediate;

    logic        reg_write;
    logic        mem_read;
    logic        mem_write;
    logic        mem_to_reg;
    logic        alu_src;
    logic        branch;
    logic        jump;

    logic [1:0]  alu_op;

    // DUT
    id_stage dut (
        .clk(clk),
        .rst(rst),

        .instruction(instruction),
        .pc(pc),

        .wb_reg_write(wb_reg_write),
        .wb_rd(wb_rd),
        .wb_write_data(wb_write_data),

        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),

        .rs1_data(rs1_data),
        .rs2_data(rs2_data),

        .immediate(immediate),

        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .alu_src(alu_src),
        .branch(branch),
        .jump(jump),

        .alu_op(alu_op)
    );

    // Clock
    always #5 clk = ~clk;

    initial begin

        clk = 0;
        rst = 1;

        instruction = 32'b0;
        pc = 32'b0;

        wb_reg_write = 0;
        wb_rd = 5'b0;
        wb_write_data = 32'b0;

        // Reset
        #10;
        rst = 0;

        // ------------------------------------------------
        // Write 100 into x5
        // ------------------------------------------------
        @(negedge clk);
        wb_reg_write = 1;
        wb_rd = 5'd5;
        wb_write_data = 32'd100;

        @(posedge clk);

        // ------------------------------------------------
        // Write 200 into x6
        // ------------------------------------------------
        @(negedge clk);
        wb_reg_write = 1;
        wb_rd = 5'd6;
        wb_write_data = 32'd200;

        @(posedge clk);

        // Disable write-back
        @(negedge clk);
        wb_reg_write = 0;
        wb_rd = 5'd0;
        wb_write_data = 32'b0;

        // ------------------------------------------------
        // ADD x7, x5, x6
        // RISC-V encoding:
        // funct7 = 0000000
        // rs2    = x6
        // rs1    = x5
        // funct3 = 000
        // rd     = x7
        // opcode = 0110011
        // ------------------------------------------------
        instruction = 32'b0000000_00110_00101_000_00111_0110011;

        #2;

        $display("========================================");
        $display("Step 33B - ID Stage Test");
        $display("========================================");

        $display("Instruction = %h", instruction);
        $display("rs1         = %d", rs1);
        $display("rs2         = %d", rs2);
        $display("rd          = %d", rd);
        $display("rs1_data    = %d", rs1_data);
        $display("rs2_data    = %d", rs2_data);
        $display("immediate   = %d", immediate);
        $display("reg_write   = %b", reg_write);
        $display("mem_read    = %b", mem_read);
        $display("mem_write   = %b", mem_write);
        $display("mem_to_reg  = %b", mem_to_reg);
        $display("alu_src     = %b", alu_src);
        $display("branch      = %b", branch);
        $display("jump        = %b", jump);
        $display("alu_op      = %b", alu_op);

        // ------------------------------------------------
        // Checks
        // ------------------------------------------------

        if (rs1 !== 5'd5)
            $display("ERROR: rs1 incorrect");
        else
            $display("PASS: rs1 correct");

        if (rs2 !== 5'd6)
            $display("ERROR: rs2 incorrect");
        else
            $display("PASS: rs2 correct");

        if (rd !== 5'd7)
            $display("ERROR: rd incorrect");
        else
            $display("PASS: rd correct");

        if (rs1_data !== 32'd100)
            $display("ERROR: rs1_data incorrect");
        else
            $display("PASS: rs1_data correct");

        if (rs2_data !== 32'd200)
            $display("ERROR: rs2_data incorrect");
        else
            $display("PASS: rs2_data correct");

        // x0 must always be zero
        instruction = 32'b0000000_00000_00000_000_00000_0110011;

        #2;

        if (rs1_data !== 32'd0)
            $display("ERROR: x0 is not zero");
        else
            $display("PASS: x0 correctly reads zero");

        $display("========================================");
        $display("Step 33B test completed");
        $display("========================================");

        $finish;
    end

endmodule