`timescale 1ns/1ps

module gpio_interconnect_tb;

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
    logic [7:0] gpio_in;
    logic [7:0] gpio_out;

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

    gpio gpio_device (
        .clk      (clk),
        .reset    (reset),
        .cs       (gpio_sel),
        .we       (mem_write),
        .wdata    (wdata),
        .rdata    (rdata),
        .gpio_in  (gpio_in),
        .gpio_out (gpio_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk       = 0;
        reset     = 1;
        address   = 32'h00000000;
        mem_read  = 0;
        mem_write = 0;
        wdata     = 32'h00000000;
        gpio_in   = 8'h00;

        #10;
        reset = 0;

        // GPIO write
        address   = 32'h10003000;
        wdata     = 32'h000000A5;
        mem_write = 1;
        #10;

        if (gpio_sel !== 1'b1) begin
            $display("FAIL: GPIO not selected during write");
            $finish;
        end

        if (gpio_out !== 8'hA5) begin
            $display("FAIL: GPIO output incorrect: %h", gpio_out);
            $finish;
        end

        mem_write = 0;
        #10;

        // GPIO read
        gpio_in  = 8'h5A;
        mem_read = 1;
        #10;

        if (gpio_sel !== 1'b1) begin
            $display("FAIL: GPIO not selected during read");
            $finish;
        end

        if (rdata[7:0] !== 8'h5A) begin
            $display("FAIL: GPIO read data incorrect: %h", rdata);
            $finish;
        end

        $display("PASS: GPIO + bus integration test completed");
        $finish;
    end

endmodule
