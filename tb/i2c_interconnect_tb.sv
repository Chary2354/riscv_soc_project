`timescale 1ns/1ps

module i2c_interconnect_tb;

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
    logic        scl;
    logic        sda_out;
    logic        sda_in;

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

    i2c i2c_device (
        .clk     (clk),
        .reset   (reset),
        .cs      (i2c_sel),
        .we      (mem_write),
        .wdata   (wdata),
        .rdata   (rdata),
        .scl     (scl),
        .sda_out (sda_out),
        .sda_in  (sda_in)
    );

    always #5 clk = ~clk;

    initial begin
        clk       = 0;
        reset     = 1;
        address   = 32'h00000000;
        mem_read  = 0;
        mem_write = 0;
        wdata     = 32'h00000000;
        sda_in    = 1'b0;

        #10;
        reset = 0;

        // I2C write
        address   = 32'h10002000;
        wdata     = 32'h000000AA;
        mem_write = 1;
        #10;

        if (i2c_sel !== 1'b1) begin
            $display("FAIL: I2C not selected");
            $finish;
        end

        if (i2c_device.tx_data !== 8'hAA) begin
            $display("FAIL: I2C transmit data incorrect: %h",
                     i2c_device.tx_data);
            $finish;
        end

        mem_write = 0;
        #10;

        // I2C read
        sda_in   = 1'b1;
        mem_read = 1;
        #10;

        if (i2c_sel !== 1'b1) begin
            $display("FAIL: I2C not selected during read");
            $finish;
        end

        if (rdata[7:0] !== 8'h01) begin
            $display("FAIL: I2C read data incorrect: %h", rdata);
            $finish;
        end

        $display("PASS: CPU/Bus I2C integration test completed");
        $finish;
    end

endmodule