module timer_tb;

    logic clk;
    logic reset;
    logic cs;
    logic we;
    logic [31:0] wdata;
    logic [31:0] rdata;
    logic irq;

    timer dut (
        .clk(clk),
        .reset(reset),
        .cs(cs),
        .we(we),
        .wdata(wdata),
        .rdata(rdata),
        .irq(irq)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        cs = 0;
        we = 0;
        wdata = 0;

        #10;
        reset = 0;

        // Set timer compare value
        #10;
        cs = 1;
        we = 1;
        wdata = 32'd5;

        #10;
        cs = 0;
        we = 0;

        #100;

        if (irq)
            $display("TIMER TEST PASSED");
        else
            $display("TIMER TEST FAILED");

        #10;
        $finish;
    end

endmodule