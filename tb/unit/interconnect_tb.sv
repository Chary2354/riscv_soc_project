`timescale 1ns/1ps

module interconnect_tb;

    // 1. Replaced 'logic' with 'reg' for variables driven in the initial block
    reg [31:0] address;
    reg        mem_read;
    reg        mem_write;

    // 2. Replaced 'logic' with 'wire' for outputs coming out of the DUT
    wire       ram_sel;
    wire       uart_sel;
    wire       spi_sel;
    wire       i2c_sel;
    wire       gpio_sel;
    wire       timer_sel;
    wire       accel_sel;

    // Device Under Test (DUT) Instantiation
    bus_interconnect dut (
        .address(address),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .ram_sel(ram_sel),
        .uart_sel(uart_sel),
        .spi_sel(spi_sel),
        .i2c_sel(i2c_sel),
        .gpio_sel(gpio_sel),
        .timer_sel(timer_sel),
        .accel_sel(accel_sel)
    );

    initial begin

        $display("================================");
        $display("Interconnect Test");
        $display("================================");

        mem_read = 1;
        mem_write = 0;

        // RAM
        address = 32'h00000020;
        #10;

        if (ram_sel)
            $display("PASS: RAM select");
        else
            $display("FAIL: RAM select");

        // UART
        address = 32'h10000000;
        #10;

        if (uart_sel)
            $display("PASS: UART select");
        else
            $display("FAIL: UART select");

        // SPI
        address = 32'h10001000;
        #10;

        if (spi_sel)
            $display("PASS: SPI select");
        else
            $display("FAIL: SPI select");

        // I2C
        address = 32'h10002000;
        #10;

        if (i2c_sel)
            $display("PASS: I2C select");
        else
            $display("FAIL: I2C select");

        // GPIO
        address = 32'h10003000;
        #10;

        if (gpio_sel)
            $display("PASS: GPIO select");
        else
            $display("FAIL: GPIO select");

        // TIMER
        address = 32'h10004000;
        #10;

        if (timer_sel)
            $display("PASS: Timer select");
        else
            $display("FAIL: Timer select");

        // ACCELERATOR
        address = 32'h10005000;
        #10;

        if (accel_sel)
            $display("PASS: Accelerator select");
        else
            $display("FAIL: Accelerator select");

        $display("================================");
        $display("Interconnect Test Completed");
        $display("================================");

        $finish;

    end

endmodule