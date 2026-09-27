`timescale 1ns/1ps

module timer_interconnect_tb;

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
    logic        irq;

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

    timer timer_device (
        .clk   (clk),
        .reset (reset),
        .cs    (timer_sel),
        .we    (mem_write),
        .wdata (wdata),
        .rdata (rdata),
        .irq   (irq)
    );

    always #5 clk = ~clk;

    initial begin
        clk       = 0;
        reset     = 1;
        address   = 32'h00000000;
        mem_read  = 0;
        mem_write = 0;
        wdata     = 32'h00000000;

        #10;
        reset = 0;

        // Program timer through bus
        address   = 32'h10004000;
        wdata     = 32'd5;
        mem_write = 1;
        #10;

        if (timer_sel !== 1'b1) begin
            $display("FAIL: Timer not selected");
            $finish;
        end

        mem_write = 0;

        // Wait for interrupt
        wait (irq == 1'b1);

        $display("TIMER INTERRUPT DETECTED");
        $display("PASS: Timer + bus integration test completed");

        #10;
        $finish;
    end

endmodule
