`timescale 1ns/1ps

module program_counter_tb;

    logic        clk;
    logic        rst;
    logic        pc_write;
    logic [31:0] next_pc;
    logic [31:0] pc;

    program_counter dut (
        .clk     (clk),
        .rst     (rst),
        .pc_write(pc_write),
        .next_pc (next_pc),
        .pc      (pc)
    );

    // 10 ns clock period
    always #5 clk = ~clk;

    initial begin

        $display("=================================");
        $display(" Program Counter Test");
        $display("=================================");

        clk      = 1'b0;
        rst      = 1'b1;
        pc_write = 1'b0;
        next_pc  = 32'h00000000;

        // Reset
        #12;

        if (pc == 32'h00000000)
            $display("PASS: Reset PC = 0");
        else
            $display("FAIL: Reset PC");

        rst = 1'b0;

        // Write PC = 4
        @(negedge clk);

        pc_write = 1'b1;
        next_pc  = 32'h00000004;

        @(posedge clk);
        #1;

        if (pc == 32'h00000004)
            $display("PASS: PC = 4");
        else
            $display("FAIL: PC = 4");

        // Write PC = 8
        @(negedge clk);

        next_pc = 32'h00000008;

        @(posedge clk);
        #1;

        if (pc == 32'h00000008)
            $display("PASS: PC = 8");
        else
            $display("FAIL: PC = 8");

        // Hold PC
        @(negedge clk);

        pc_write = 1'b0;
        next_pc  = 32'h00000020;

        @(posedge clk);
        #1;

        if (pc == 32'h00000008)
            $display("PASS: PC hold");
        else
            $display("FAIL: PC hold");

        // Jump to another address
        @(negedge clk);

        pc_write = 1'b1;
        next_pc  = 32'h00000100;

        @(posedge clk);
        #1;

        if (pc == 32'h00000100)
            $display("PASS: PC jump");
        else
            $display("FAIL: PC jump");

        $display("=================================");
        $display("Program Counter Test Completed");
        $display("=================================");

        $finish;

    end

endmodule