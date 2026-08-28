`timescale 1ns/1ps

module decoder_tb;

    logic [31:0] instr;

    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [4:0] rd;

    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;

    logic reg_write;
    logic mem_read;
    logic mem_write;
    logic alu_src;
    logic branch;
    logic jump;

    logic [3:0] alu_control;

    logic [31:0] immediate;

    logic illegal_instr;

    decoder dut (
        .instr(instr),

        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),

        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),

        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .branch(branch),
        .jump(jump),

        .alu_control(alu_control),

        .immediate(immediate),

        .illegal_instr(illegal_instr)
    );

    initial begin

        $display("=================================");
        $display(" RISC-V Instruction Decoder Test");
        $display("=================================");

        // ------------------------------------------------
        // Test 1: ADD x5, x6, x7
        // ------------------------------------------------

        instr = 32'b0000000_00111_00110_000_00101_0110011;

        #1;

        if ((rs1 == 5'd6) &&
            (rs2 == 5'd7) &&
            (rd == 5'd5) &&
            (reg_write == 1'b1) &&
            (alu_control == 4'b0000) &&
            (illegal_instr == 1'b0))

            $display("PASS: ADD instruction");

        else
            $display("FAIL: ADD instruction");


        // ------------------------------------------------
        // Test 2: SUB x5, x6, x7
        // ------------------------------------------------

        instr = 32'b0100000_00111_00110_000_00101_0110011;

        #1;

        if ((rs1 == 5'd6) &&
            (rs2 == 5'd7) &&
            (rd == 5'd5) &&
            (alu_control == 4'b0001) &&
            (illegal_instr == 1'b0))

            $display("PASS: SUB instruction");

        else
            $display("FAIL: SUB instruction");


        // ------------------------------------------------
        // Test 3: ADDI x5, x6, 10
        // ------------------------------------------------

        instr = 32'b000000001010_00110_000_00101_0010011;

        #1;

        if ((rs1 == 5'd6) &&
            (rd == 5'd5) &&
            (reg_write == 1'b1) &&
            (alu_src == 1'b1) &&
            (immediate == 32'd10) &&
            (illegal_instr == 1'b0))

            $display("PASS: ADDI instruction");

        else
            $display("FAIL: ADDI instruction");


        // ------------------------------------------------
        // Test 4: LW x5, 16(x6)
        // ------------------------------------------------

        instr = 32'b000000010000_00110_010_00101_0000011;

        #1;

        if ((rs1 == 5'd6) &&
            (rd == 5'd5) &&
            (mem_read == 1'b1) &&
            (reg_write == 1'b1) &&
            (immediate == 32'd16) &&
            (illegal_instr == 1'b0))

            $display("PASS: LW instruction");

        else
            $display("FAIL: LW instruction");


        // ------------------------------------------------
        // Test 5: SW x5, 16(x6)
        // ------------------------------------------------

        instr = 32'b0000000_00101_00110_010_10000_0100011;

        #1;

        if ((rs1 == 5'd6) &&
            (rs2 == 5'd5) &&
            (mem_write == 1'b1) &&
            (immediate == 32'd16) &&
            (illegal_instr == 1'b0))

            $display("PASS: SW instruction");

        else
            $display("FAIL: SW instruction");


        // ------------------------------------------------
        // Test 6: BEQ
        // ------------------------------------------------

        instr = 32'b0000000_00111_00110_000_00000_1100011;

        #1;

        if ((rs1 == 5'd6) &&
            (rs2 == 5'd7) &&
            (branch == 1'b1) &&
            (illegal_instr == 1'b0))

            $display("PASS: BEQ instruction");

        else
            $display("FAIL: BEQ instruction");


        // ------------------------------------------------
        // Test 7: Illegal instruction
        // ------------------------------------------------

        instr = 32'hFFFFFFFF;

        #1;

        if (illegal_instr == 1'b1)
            $display("PASS: Illegal instruction detection");
        else
            $display("FAIL: Illegal instruction detection");


        $display("=================================");
        $display("Decoder Test Completed");
        $display("=================================");

        $finish;

    end

endmodule