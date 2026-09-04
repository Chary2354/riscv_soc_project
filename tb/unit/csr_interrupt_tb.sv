`timescale 1ns/1ps

module csr_interrupt_tb;

    logic clk;
    logic rst;

    logic interrupt_request;

    logic csr_write;
    logic [11:0] csr_addr;
    logic [31:0] csr_write_data;

    logic [31:0] csr_read_data;
    logic interrupt_taken;
    logic [31:0] interrupt_vector;

    csr_interrupt dut (
        .clk(clk),
        .rst(rst),
        .interrupt_request(interrupt_request),
        .csr_write(csr_write),
        .csr_addr(csr_addr),
        .csr_write_data(csr_write_data),
        .csr_read_data(csr_read_data),
        .interrupt_taken(interrupt_taken),
        .interrupt_vector(interrupt_vector)
    );

    always #5 clk = ~clk;

    initial begin

        $display("================================");
        $display("CSR / Interrupt Test");
        $display("================================");

        clk = 0;
        rst = 1;
        interrupt_request = 0;
        csr_write = 0;
        csr_addr = 0;
        csr_write_data = 0;

        #12;

        rst = 0;

        // Configure mtvec
        csr_addr = 12'h305;
        csr_write_data = 32'h00000200;
        csr_write = 1;

        @(posedge clk);
        #1;

        csr_write = 0;

        if (interrupt_vector == 32'h00000200)
            $display("PASS: MTVEC");

        else
            $display("FAIL: MTVEC");


        // Enable global interrupt
        csr_addr = 12'h300;
        csr_write_data = 32'h00000008;
        csr_write = 1;

        @(posedge clk);
        #1;

        csr_write = 0;


        // Enable timer interrupt bit
        csr_addr = 12'h304;
        csr_write_data = 32'h00000080;
        csr_write = 1;

        @(posedge clk);
        #1;

        csr_write = 0;


        // Request interrupt
        interrupt_request = 1;

        #2;

        if (interrupt_taken)
            $display("PASS: Interrupt accepted");

        else
            $display("FAIL: Interrupt accepted");


        $display("================================");
        $display("CSR / Interrupt Test Completed");
        $display("================================");

        $finish;

    end

endmodule