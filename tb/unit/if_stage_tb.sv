`timescale 1ns/1ps

module if_stage_tb;

    logic        clk;
    logic        rst;
    logic        pc_write;
    logic        branch_taken;
    logic [31:0] branch_target;

    logic [31:0] pc;
    logic [31:0] pc_plus4;
    logic [31:0] instruction;

    if_stage dut (
        .clk          (clk),
        .rst          (rst),
        .pc_write     (pc_write),
        .branch_taken (branch_taken),
        .branch_target(branch_target),
        .pc           (pc),
        .pc_plus4     (pc_plus4),
        .instruction  (instruction)
    );

    always #5 clk = ~clk;

    initial begin

        $display("====================================");
        $display(" Instruction Fetch Stage Test");
        $display("====================================");

        clk = 1'b0;
        rst = 1'b1;
        pc_write = 1'b0;
        branch_taken = 1'b0;
        branch_target = 32'b0;

        // Put test instructions into memory
        dut.instruction_memory[0] = 32'h00500093;
        dut.instruction_memory[1] = 32'h00A00113;
        dut.instruction_memory[2] = 32'h002081B3;
        dut.instruction_memory[3] = 32'h00000013;

        // Reset
        #12;

        if (pc == 32'h00000000)
            $display("PASS: PC reset");
        else
            $display("FAIL: PC reset");

        rst = 1'b0;
        pc_write = 1'b1;

        // Instruction at address 0
        #1;

        if (instruction == 32'h00500093)
            $display("PASS: Instruction 0 fetched");
        else
            $display("FAIL: Instruction 0 fetched");

        if (pc_plus4 == 32'h00000004)
            $display("PASS: PC + 4");
        else
            $display("FAIL: PC + 4");

        // Move to PC = 4
        @(posedge clk);
        #1;

        if (pc == 32'h00000004)
            $display("PASS: PC advanced to 4");
        else
            $display("FAIL: PC advanced to 4");

        if (instruction == 32'h00A00113)
            $display("PASS: Instruction 1 fetched");
        else
            $display("FAIL: Instruction 1 fetched");

        // Move to PC = 8
        @(posedge clk);
        #1;

        if (pc == 32'h00000008)
            $display("PASS: PC advanced to 8");
        else
            $display("FAIL: PC advanced to 8");

        if (instruction == 32'h002081B3)
            $display("PASS: Instruction 2 fetched");
        else
            $display("FAIL: Instruction 2 fetched");

        // Test branch
        branch_taken = 1'b1;
        branch_target = 32'h00000020;

        @(posedge clk);
        #1;

        if (pc == 32'h00000020)
            $display("PASS: Branch target loaded");
        else
            $display("FAIL: Branch target");

        // Test PC hold
        branch_taken = 1'b0;
        pc_write = 1'b0;

        @(posedge clk);
        #1;

        if (pc == 32'h00000020)
            $display("PASS: PC hold");
        else
            $display("FAIL: PC hold");

        $display("====================================");
        $display("Instruction Fetch Test Completed");
        $display("====================================");

        $finish;

    end

endmodule