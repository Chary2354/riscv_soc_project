module uart_tb;

    logic clk;
    logic reset;
    logic cs;
    logic we;
    logic [31:0] wdata;
    logic [31:0] rdata;
    logic tx;
    logic rx;

    uart dut (
        .clk(clk),
        .reset(reset),
        .cs(cs),
        .we(we),
        .wdata(wdata),
        .rdata(rdata),
        .tx(tx),
        .rx(rx)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        cs = 0;
        we = 0;
        wdata = 0;
        rx = 1;

        #10;
        reset = 0;

        // Write 0x55
        #10;
        cs = 1;
        we = 1;
        wdata = 32'h00000055;

        #10;
        cs = 0;
        we = 0;

        #10;

        if (dut.tx_data == 8'h55)
            $display("UART TEST PASSED");
        else
            $display("UART TEST FAILED");

        #10;
        $finish;
    end

endmodule