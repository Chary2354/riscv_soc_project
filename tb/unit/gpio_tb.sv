module gpio_tb;

    logic clk;
    logic reset;
    logic cs;
    logic we;
    logic [31:0] wdata;
    logic [31:0] rdata;

    logic [7:0] gpio_in;
    logic [7:0] gpio_out;

    gpio dut (
        .clk(clk),
        .reset(reset),
        .cs(cs),
        .we(we),
        .wdata(wdata),
        .rdata(rdata),
        .gpio_in(gpio_in),
        .gpio_out(gpio_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        cs = 0;
        we = 0;
        wdata = 0;
        gpio_in = 8'h00;

        #10;
        reset = 0;

        // Write GPIO output
        #10;
        cs = 1;
        we = 1;
        wdata = 32'h000000A5;

        #10;
        cs = 0;
        we = 0;

        #10;

        if (gpio_out == 8'hA5)
            $display("GPIO WRITE TEST PASSED");
        else
            $display("GPIO WRITE TEST FAILED");

        // Test GPIO input
        gpio_in = 8'h5A;

        #10;
        cs = 1;
        we = 0;

        #10;

        if (rdata[7:0] == 8'h5A)
            $display("GPIO READ TEST PASSED");
        else
            $display("GPIO READ TEST FAILED");

        #10;
        $finish;
    end

endmodule