`timescale 1ns/1ps

module alu_tb;

    logic [31:0] a;
    logic [31:0] b;
    logic [3:0]  alu_op;

    logic [31:0] result;
    logic        zero;

    integer errors;

    // ALU operation codes
    localparam logic [3:0] ALU_ADD = 4'b0000;
    localparam logic [3:0] ALU_SUB = 4'b0001;
    localparam logic [3:0] ALU_AND = 4'b0010;
    localparam logic [3:0] ALU_OR  = 4'b0011;
    localparam logic [3:0] ALU_XOR = 4'b0100;
    localparam logic [3:0] ALU_SLT = 4'b0101;
    localparam logic [3:0] ALU_SLL = 4'b0110;
    localparam logic [3:0] ALU_SRL = 4'b0111;
    localparam logic [3:0] ALU_SRA = 4'b1000;

    // Instantiate ALU
    alu dut (
        .a      (a),
        .b      (b),
        .alu_op (alu_op),
        .result (result),
        .zero   (zero)
    );

    // Self-checking task
    task automatic check_result(
        input logic [31:0] expected,
        input string       test_name
    );
        begin

            #1;

            if (result !== expected) begin
                $display("FAIL: %s", test_name);
                $display("      A        = %h", a);
                $display("      B        = %h", b);
                $display("      Expected = %h", expected);
                $display("      Actual   = %h", result);
                errors = errors + 1;
            end
            else begin
                $display("PASS: %s -> Result = %h",
                         test_name, result);
            end

            if (zero !== (expected == 32'b0)) begin
                $display("FAIL: Zero flag incorrect in %s", test_name);
                errors = errors + 1;
            end

        end
    endtask

    initial begin

        errors = 0;

        // Create waveform file
        $dumpfile("sim/alu.vcd");
        $dumpvars(0, alu_tb);

        $display("");
        $display("======================================");
        $display("       32-BIT ALU TESTBENCH");
        $display("======================================");
        $display("");

        // ------------------------------------------------
        // ADD
        // ------------------------------------------------
        a = 32'd10;
        b = 32'd5;
        alu_op = ALU_ADD;
        check_result(32'd15, "ADD 10 + 5");

        // ------------------------------------------------
        // SUB
        // ------------------------------------------------
        a = 32'd10;
        b = 32'd5;
        alu_op = ALU_SUB;
        check_result(32'd5, "SUB 10 - 5");

        // ------------------------------------------------
        // AND
        // ------------------------------------------------
        a = 32'hF0F0_F0F0;
        b = 32'h0F0F_0F0F;
        alu_op = ALU_AND;
        check_result(32'h0000_0000, "AND");

        // ------------------------------------------------
        // OR
        // ------------------------------------------------
        a = 32'hF0F0_0000;
        b = 32'h0000_0F0F;
        alu_op = ALU_OR;
        check_result(32'hF0F0_0F0F, "OR");

        // ------------------------------------------------
        // XOR
        // ------------------------------------------------
        a = 32'hFFFF_0000;
        b = 32'h0F0F_0F0F;
        alu_op = ALU_XOR;
        check_result(32'hF0F0_0F0F, "XOR");

        // ------------------------------------------------
        // SLT signed
        // ------------------------------------------------
        a = 32'hFFFF_FFFF;   // -1
        b = 32'd1;
        alu_op = ALU_SLT;
        check_result(32'd1, "SLT -1 < 1");

        // ------------------------------------------------
        // SLL
        // ------------------------------------------------
        a = 32'd1;
        b = 32'd4;
        alu_op = ALU_SLL;
        check_result(32'd16, "SLL 1 << 4");

        // ------------------------------------------------
        // SRL
        // ------------------------------------------------
        a = 32'd16;
        b = 32'd2;
        alu_op = ALU_SRL;
        check_result(32'd4, "SRL 16 >> 2");

        // ------------------------------------------------
        // SRA
        // ------------------------------------------------
        a = 32'hFFFF_FFF0;   // -16
        b = 32'd2;
        alu_op = ALU_SRA;
        check_result(32'hFFFF_FFFC, "SRA -16 >>> 2");

        // ------------------------------------------------
        // Zero result
        // ------------------------------------------------
        a = 32'd25;
        b = 32'd25;
        alu_op = ALU_SUB;
        check_result(32'd0, "SUB 25 - 25");

        // ------------------------------------------------
        // Final result
        // ------------------------------------------------
        $display("");
        $display("======================================");

        if (errors == 0) begin
            $display("       ALL TESTS PASSED");
        end
        else begin
            $display("       TESTS FAILED");
            $display("       ERROR COUNT = %0d", errors);
        end

        $display("======================================");
        $display("");

        $finish;
    end

endmodule