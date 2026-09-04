`timescale 1ns/1ps

module regfile_tb;

    logic clk;
    logic rst;

    logic [4:0] rs1_addr;
    logic [4:0] rs2_addr;

    logic [31:0] rs1_data;
    logic [31:0] rs2_data;

    logic        rd_we;
    logic [4:0]  rd_addr;
    logic [31:0] rd_data;

    regfile dut (
        .clk      (clk),
        .rst      (rst),

        .rs1_addr (rs1_addr),
        .rs2_addr (rs2_addr),

        .rs1_data (rs1_data),
        .rs2_data (rs2_data),

        .rd_we    (rd_we),
        .rd_addr  (rd_addr),
        .rd_data  (rd_data)
    );

    // Clock
    always #5 clk = ~clk;

    initial begin
        $dumpfile("regfile.vcd");
        $dumpvars(0, regfile_tb);

        $display("=================================");
        $display(" Register File Test");
        $display("=================================");

        clk = 0;
        rst = 1;

        rs1_addr = 0;
        rs2_addr = 0;

        rd_we   = 0;
        rd_addr = 0;
        rd_data = 0;

        // Reset
        #12;
        rst = 0;

        // Test 1: Write x1
        @(negedge clk);

        rd_we   = 1;
        rd_addr = 5'd1;
        rd_data = 32'h12345678;

        @(negedge clk);

        rd_we = 0;

        // Read x1
        rs1_addr = 5'd1;

        #2;

        if (rs1_data == 32'h12345678)
            $display("PASS: x1 write/read");
        else
            $display("FAIL: x1 write/read");

        // Test 2: Write x2
        @(negedge clk);

        rd_we   = 1;
        rd_addr = 5'd2;
        rd_data = 32'hABCDEF01;

        @(negedge clk);

        rd_we = 0;

        rs2_addr = 5'd2;

        #2;

        if (rs2_data == 32'hABCDEF01)
            $display("PASS: x2 write/read");
        else
            $display("FAIL: x2 write/read");

        // Test 3: x0 must remain zero
        @(negedge clk);

        rd_we   = 1;
        rd_addr = 5'd0;
        rd_data = 32'hFFFFFFFF;

        @(negedge clk);

        rd_we = 0;

        rs1_addr = 5'd0;

        #2;

        if (rs1_data == 32'h00000000)
            $display("PASS: x0 remains zero");
        else
            $display("FAIL: x0 was modified");

        // Test 4: Two simultaneous reads
        rs1_addr = 5'd1;
        rs2_addr = 5'd2;

        #2;

        if ((rs1_data == 32'h12345678) &&
            (rs2_data == 32'hABCDEF01))
            $display("PASS: dual read ports");
        else
            $display("FAIL: dual read ports");

        $display("=================================");
        $display("Register File Test Completed");
        $display("=================================");

        $finish;

    end

endmodule