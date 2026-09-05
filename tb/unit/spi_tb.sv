module spi_tb;

    logic clk;
    logic reset;
    logic cs;
    logic we;
    logic [31:0] wdata;
    logic [31:0] rdata;
    logic sclk;
    logic mosi;
    logic miso;
    logic spi_cs;

    spi dut (
        .clk(clk),
        .reset(reset),
        .cs(cs),
        .we(we),
        .wdata(wdata),
        .rdata(rdata),
        .sclk(sclk),
        .mosi(mosi),
        .miso(miso),
        .spi_cs(spi_cs)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        cs = 0;
        we = 0;
        wdata = 0;
        miso = 0;

        #10;
        reset = 0;

        #10;
        cs = 1;
        we = 1;
        wdata = 32'h000000A5;

        #10;
        cs = 0;
        we = 0;

        #10;

        if (dut.tx_data == 8'hA5)
            $display("SPI TEST PASSED");
        else
            $display("SPI TEST FAILED");

        #10;
        $finish;
    end

endmodule