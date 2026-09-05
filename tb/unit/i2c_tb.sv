module i2c_tb;

    logic clk;
    logic reset;
    logic cs;
    logic we;
    logic [31:0] wdata;
    logic [31:0] rdata;

    logic scl;
    logic sda_out;
    logic sda_in;

    i2c dut (
        .clk(clk),
        .reset(reset),
        .cs(cs),
        .we(we),
        .wdata(wdata),
        .rdata(rdata),
        .scl(scl),
        .sda_out(sda_out),
        .sda_in(sda_in)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        cs = 0;
        we = 0;
        wdata = 0;
        sda_in = 0;

        #10;
        reset = 0;

        // Write data
        #10;
        cs = 1;
        we = 1;
        wdata = 32'h000000AA;

        #10;
        cs = 0;
        we = 0;

        #10;

        if (dut.tx_data == 8'hAA)
            $display("I2C TEST PASSED");
        else
            $display("I2C TEST FAILED");

        #10;
        $finish;
    end

endmodule