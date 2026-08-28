`timescale 1ns/1ps

module immediate_generator_tb;

    logic [31:0] instr;
    logic [31:0] immediate;

    immediate_generator dut (
        .instr(instr),
        .immediate(immediate)
    );

    initial begin

        $display("=================================");
        $display(" Immediate Generator Test");
        $display("=================================");

        // -----------------------------------------
        // Test 1: ADDI x5, x6, 10
        // -----------------------------------------

        instr = 32'b000000001010_00110_000_00101_0010011;

        #1;

        if (immediate == 32'd10)
            $display("PASS: I-Type immediate");
        else
            $display("FAIL: I-Type immediate");


        // -----------------------------------------
        // Test 2: ADDI x5, x6, -5
        // -----------------------------------------

        instr = 32'b111111111011_00110_000_00101_0010011;

        #1;

        if (immediate == 32'hFFFFFFFB)
            $display("PASS: Negative I-Type immediate");
        else
            $display("FAIL: Negative I-Type immediate");


        // -----------------------------------------
        // Test 3: SW x5, 16(x6)
        // -----------------------------------------

        instr = 32'b0000000_00101_00110_010_10000_0100011;

        #1;

        if (immediate == 32'd16)
            $display("PASS: S-Type immediate");
        else
            $display("FAIL: S-Type immediate");


        // -----------------------------------------
        // Test 4: BEQ offset
        // -----------------------------------------

        instr = 32'b0000000_00111_00110_000_00000_1100011;

        #1;

        if (immediate == 32'd0)
            $display("PASS: B-Type immediate");
        else
            $display("FAIL: B-Type immediate");


        // -----------------------------------------
        // Test 5: LUI
        // LUI x5, 0x12345
        // -----------------------------------------

        instr = 32'h123452B7;

        #1;

        if (immediate == 32'h12345000)
            $display("PASS: U-Type immediate");
        else
            $display("FAIL: U-Type immediate");


        // -----------------------------------------
        // Test 6: JAL
        // -----------------------------------------

        instr = 32'b00000000000000000000000001101111;

        #1;

        if (immediate == 32'd0)
            $display("PASS: J-Type immediate");
        else
            $display("FAIL: J-Type immediate");


        // -----------------------------------------
        // Test 7: Unsupported opcode
        // -----------------------------------------

        instr = 32'hFFFFFFFF;

        #1;

        if (immediate == 32'b0)
            $display("PASS: Default immediate");
        else
            $display("FAIL: Default immediate");


        $display("=================================");
        $display("Immediate Generator Test Completed");
        $display("=================================");

        $finish;

    end

endmodule