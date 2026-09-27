`timescale 1ns/1ps

module spi_interconnect_tb;

    logic        clk;
    logic        reset;

    logic [31:0] address;
    logic        mem_read;
    logic        mem_write;
    logic [31:0] wdata;

    wire ram_sel;
    wire uart_sel;
    wire spi_sel;
    wire i2c_sel;
    wire gpio_sel;
    wire timer_sel;
    wire accel_sel;

    logic [31:0] rdata;
    logic sclk;
    logic mosi;
    logic miso;
    logic spi_cs;

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

    spi spi_device (
        .clk    (clk),
        .reset  (reset),
        .cs     (spi_sel),
        .we     (mem_write),
        .wdata  (wdata),
        .rdata  (rdata),
        .sclk   (sclk),
        .mosi   (mosi),
        .miso   (miso),
        .spi_cs (spi_cs)
    );

    always #5 clk = ~clk;

    initial begin
        clk       = 0;
        reset     = 1;
        address   = 32'h00000000;
        mem_read  = 0;
        mem_write = 0;
        wdata     = 32'h00000000;
        miso      = 1'b0;

        #10;
        reset = 0;

        // SPI write
        address   = 32'h10001000;
        wdata     = 32'h000000A5;
        mem_write = 1;
        #10;

        if (spi_sel !== 1'b1) begin
            $display("FAIL: SPI not selected");
            $finish;
        end

        if (spi_cs !== 1'b1) begin
            $display("FAIL: SPI chip select not active");
            $finish;
        end

        if (spi_device.tx_data !== 8'hA5) begin
            $display("FAIL: SPI transmit data incorrect: %h",
                     spi_device.tx_data);
            $finish;
        end

        mem_write = 0;
        #10;

        // SPI read
        mem_read = 1;
        #1;

        if (spi_sel !== 1'b1) begin
            $display("FAIL: SPI not selected during read");
            $finish;
        end

        $display("PASS: CPU/Bus SPI integration test completed");
        $finish;
    end

endmodule