`timescale 1ns/1ps

module memory_interface_tb;

    logic clk;
    logic rst;

    logic mem_read;
    logic mem_write;

    logic [31:0] address;
    logic [31:0] write_data;

    logic [31:0] read_data;
    logic ready;

    memory_interface dut (
        .clk(clk),
        .rst(rst),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .address(address),
        .write_data(write_data),
        .read_data(read_data),
        .ready(ready)
    );

    always #5 clk = ~clk;

    initial begin

        $display("================================");
        $display("Memory Interface Test");
        $display("================================");

        clk = 0;
        rst = 1;
        mem_read = 0;
        mem_write = 0;
        address = 0;
        write_data = 0;

        #12;

        rst = 0;

        // Write
        address = 32'h00000020;
        write_data = 32'h12345678;
        mem_write = 1;

        @(posedge clk);
        #1;

        mem_write = 0;

        // Read
        mem_read = 1;

        #1;

        if (read_data == 32'h12345678)
            $display("PASS: Memory write/read");

        else
            $display("FAIL: Memory write/read");

        mem_read = 0;

        $display("================================");
        $display("Memory Interface Test Completed");
        $display("================================");

        $finish;

    end

endmodule