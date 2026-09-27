`timescale 1ns/1ps

module uart_interconnect_tb;

    logic        clk;
    logic        reset;

    logic [31:0] address;
    logic        mem_read;
    logic        mem_write;
    logic [31:0] wdata;

    wire         ram_sel;
    wire         uart_sel;
    wire         spi_sel;
    wire         i2c_sel;
    wire         gpio_sel;
    wire         timer_sel;
    wire         accel_sel;

    logic [31:0] rdata;
    logic        tx;
    logic        rx;

    bus_interconnect bus (
        .address   (address),
        .mem_read  (mem_read),
        .mem_write (mem_write),
        .ram_sel   (ram_sel),
        .uart_sel  (uart_sel),
        .spi_sel   (spi_sel),
        .i2c_sel   (i2c_sel),
        .gpio_sel  (gpio_sel),
        .timer_sel (timer_sel),
        .accel_sel (accel_sel)
    );

    uart uart_device (
        .clk   (clk),
        .reset (reset),
        .cs    (uart_sel),
        .we    (mem_write),
        .wdata (wdata),
        .rdata (rdata),
        .tx    (tx),
        .rx    (rx)
    );

    always #5 clk = ~clk;

    initial begin
        clk       = 0;
        reset     = 1;
        address   = 32'h00000000;
        mem_read  = 0;
        mem_write = 0;
        wdata     = 32'h00000000;
        rx        = 1'b1;

        #10;
        reset = 0;

        // UART write
        address   = 32'h10000000;
        wdata     = 32'h00000041;   // ASCII 'A'
        mem_write = 1;
        #10;

        if (uart_sel !== 1'b1) begin
            $display("FAIL: UART not selected");
            $finish;
        end

        mem_write = 0;
        #10;

        // UART read
        mem_read = 1;
        #1;

        if (rdata[7:0] !== 8'h41) begin
            $display("FAIL: UART read data incorrect: %h", rdata);
            $finish;
        end

        if (uart_sel !== 1'b1) begin
            $display("FAIL: UART not selected during read");
            $finish;
        end

        $display("PASS: CPU/Bus UART integration test completed");
        $finish;
    end

endmodule