`timescale 1ns/1ps

module mem_stage_tb;

    logic        clk;
    logic        rst;

    logic        mem_read;
    logic        mem_write;

    logic [31:0] address;
    logic [31:0] write_data;

    logic [31:0] read_data;

    mem_stage dut (
        .clk(clk),
        .rst(rst),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .address(address),
        .write_data(write_data),
        .read_data(read_data)
    );

    always #5 clk = ~clk;

    initial begin

        clk = 1'b0;
        rst = 1'b1;

        mem_read  = 1'b0;
        mem_write = 1'b0;
        address   = 32'b0;
        write_data = 32'b0;

        #10;
        rst = 1'b0;

        // Write first value
        address    = 32'h00000010;
        write_data = 32'h12345678;
        mem_write  = 1'b1;
        mem_read   = 1'b0;

        @(posedge clk);
        #1;

        mem_write = 1'b0;

        // Read first value
        mem_read = 1'b1;

        #2;

        $display("Address   = %h", address);
        $display("Read data = %h", read_data);

        if (read_data === 32'h12345678)
            $display("PASS: Memory write/read");
        else
            $display("ERROR: Memory write/read");

        // Write second value
        address    = 32'h00000020;
        write_data = 32'hABCDEF01;
        mem_read   = 1'b0;
        mem_write  = 1'b1;

        @(posedge clk);
        #1;

        mem_write = 1'b0;

        // Read second value
        mem_read = 1'b1;

        #2;

        $display("Address   = %h", address);
        $display("Read data = %h", read_data);

        if (read_data === 32'hABCDEF01)
            $display("PASS: Second memory location");
        else
            $display("ERROR: Second memory location");

        // Check that first value is still present
        address = 32'h00000010;

        #2;

        $display("Address   = %h", address);
        $display("Read data = %h", read_data);

        if (read_data === 32'h12345678)
            $display("PASS: First memory location preserved");
        else
            $display("ERROR: First memory location corrupted");

        // Disable read
        mem_read = 1'b0;

        #2;

        if (read_data === 32'b0)
            $display("PASS: Read disabled");
        else
            $display("ERROR: Read disabled");

        $display("========================================");
        $display("MEM stage test completed");
        $display("========================================");

        $finish;
    end

endmodule