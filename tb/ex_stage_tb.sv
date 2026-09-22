`timescale 1ns/1ps

module ex_stage_tb;

    logic [31:0] rs1_data;
    logic [31:0] rs2_data;
    logic [31:0] immediate;

    logic        alu_src;
    logic [3:0]  alu_op;

    logic [31:0] alu_result;
    logic [31:0] store_data;
    logic        zero;

    // DUT
    ex_stage dut (
        .rs1_data  (rs1_data),
        .rs2_data  (rs2_data),
        .immediate (immediate),
        .alu_src   (alu_src),
        .alu_op    (alu_op),
        .alu_result(alu_result),
        .store_data(store_data),
        .zero      (zero)
    );

    initial begin

        $display("========================================");
        $display("Step 33C - EX Stage Functional Test");
        $display("========================================");

        // -----------------------------------------
        // TEST 1: ADD
        // 100 + 25 = 125
        // -----------------------------------------
        rs1_data  = 32'd100;
        rs2_data  = 32'd25;
        immediate = 32'd10;
        alu_src   = 1'b0;
        alu_op    = 4'b0000;

        #10;

        $display("TEST 1: ADD");
        $display("A      = %d", rs1_data);
        $display("B      = %d", rs2_data);
        $display("Result = %d", alu_result);

        if (alu_result === 32'd125)
            $display("PASS: ADD");
        else
            $display("ERROR: ADD");

        // -----------------------------------------
        // TEST 2: ALU immediate input
        // 100 + immediate 10 = 110
        // -----------------------------------------
        alu_src = 1'b1;

        #10;

        $display("TEST 2: ALU immediate");
        $display("A         = %d", rs1_data);
        $display("Immediate = %d", immediate);
        $display("Result    = %d", alu_result);

        if (alu_result === 32'd110)
            $display("PASS: Immediate selection");
        else
            $display("ERROR: Immediate selection");

        // -----------------------------------------
        // TEST 3: SUBTRACT
        // 100 - 25 = 75
        // -----------------------------------------
        alu_src = 1'b0;
        alu_op  = 4'b0001;

        #10;

        $display("TEST 3: SUB");
        $display("A      = %d", rs1_data);
        $display("B      = %d", rs2_data);
        $display("Result = %d", alu_result);

        if (alu_result === 32'd75)
            $display("PASS: SUB");
        else
            $display("ERROR: SUB");

        // -----------------------------------------
        // TEST 4: ZERO detection
        // 50 - 50 = 0
        // -----------------------------------------
        rs1_data = 32'd50;
        rs2_data = 32'd50;

        #10;

        $display("TEST 4: ZERO detection");
        $display("Result = %d", alu_result);
        $display("Zero   = %b", zero);

        if ((alu_result === 32'd0) && (zero === 1'b1))
            $display("PASS: ZERO detection");
        else
            $display("ERROR: ZERO detection");

        // -----------------------------------------
        // TEST 5: Store data path
        // -----------------------------------------
        rs2_data = 32'h12345678;

        #10;

        $display("TEST 5: Store data");
        $display("RS2       = %h", rs2_data);
        $display("StoreData = %h", store_data);

        if (store_data === 32'h12345678)
            $display("PASS: Store data");
        else
            $display("ERROR: Store data");

        $display("========================================");
        $display("Step 33C test completed");
        $display("========================================");

        $finish;
    end

endmodule