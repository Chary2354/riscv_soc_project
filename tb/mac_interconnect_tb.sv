`timescale 1ns/1ps

module mac_interconnect_tb;

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

    logic        start;
    logic [31:0] a;
    logic [31:0] b;
    logic [31:0] c;

    logic [63:0] result;
    logic        done;

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

    mac_accelerator accelerator (
        .clk    (clk),
        .reset  (reset),
        .start  (start),
        .a      (a),
        .b      (b),
        .c      (c),
        .result (result),
        .done   (done)
    );

    always #5 clk = ~clk;

    initial begin
        clk       = 0;
        reset     = 1;

        address   = 32'h00000000;
        mem_read  = 0;
        mem_write = 0;
        wdata     = 32'h00000000;

        start = 0;
        a = 0;
        b = 0;
        c = 0;

        #10;
        reset = 0;

        // Select MAC accelerator through the SoC bus
        address   = 32'h10005000;
        mem_write = 1;
        #10;

        if (accel_sel !== 1'b1) begin
            $display("FAIL: MAC accelerator not selected");
            $finish;
        end

        mem_write = 0;

        // Start MAC operation
        a = 32'd10;
        b = 32'd20;
        c = 32'd5;
        start = 1;

        #10;
        start = 0;

        if (result !== 64'd205) begin
            $display("FAIL: MAC result incorrect: %d", result);
            $finish;
        end

        if (done !== 1'b1) begin
            $display("FAIL: MAC done signal not asserted");
            $finish;
        end

        $display("PASS: MAC + bus integration test completed");
        $finish;
    end

endmodule
