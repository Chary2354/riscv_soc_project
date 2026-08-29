`timescale 1ns/1ps

module branch_unit_tb;

    logic [31:0] pc;
    logic [31:0] rs1_data;
    logic [31:0] rs2_data;
    logic [31:0] immediate;

    logic branch;
    logic jump;

    logic branch_taken;
    logic [31:0] branch_target;

    branch_unit dut (
        .pc(pc),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .immediate(immediate),
        .branch(branch),
        .jump(jump),
        .branch_taken(branch_taken),
        .branch_target(branch_target)
    );

    initial begin

        $display("================================");
        $display("Branch Unit Test");
        $display("================================");

        // Test 1: BEQ taken
        pc = 32'h100;
        rs1_data = 32'd10;
        rs2_data = 32'd10;
        immediate = 32'd16;
        branch = 1'b1;
        jump = 1'b0;

        #10;

        if (branch_taken && branch_target == 32'h110)
            $display("PASS: BEQ taken");
        else
            $display("FAIL: BEQ taken");


        // Test 2: BEQ not taken
        rs1_data = 32'd10;
        rs2_data = 32'd20;

        #10;

        if (!branch_taken && branch_target == 32'h104)
            $display("PASS: BEQ not taken");
        else
            $display("FAIL: BEQ not taken");


        // Test 3: Jump
        branch = 1'b0;
        jump = 1'b1;
        immediate = 32'd32;

        #10;

        if (branch_taken && branch_target == 32'h120)
            $display("PASS: Jump");
        else
            $display("FAIL: Jump");


        $display("================================");
        $display("Branch Unit Test Completed");
        $display("================================");

        $finish;

    end

endmodule