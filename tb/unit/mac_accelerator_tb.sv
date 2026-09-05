module mac_accelerator_tb;

    logic clk;
    logic reset;
    logic start;

    logic [31:0] a;
    logic [31:0] b;
    logic [31:0] c;

    logic [63:0] result;
    logic done;

    mac_accelerator dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .a(a),
        .b(b),
        .c(c),
        .result(result),
        .done(done)
    );

    always #5 clk = ~clk;

    initial begin
        clk   = 0;
        reset = 1;
        start = 0;
        a     = 0;
        b     = 0;
        c     = 0;

        #10;
        reset = 0;

        // Test 1:
        // 10 * 20 + 5 = 205
        #10;
        a = 32'd10;
        b = 32'd20;
        c = 32'd5;
        start = 1;

        #10;
        start = 0;

        if (result == 64'd205 && done)
            $display("MAC TEST 1 PASSED");
        else
            $display("MAC TEST 1 FAILED");

        // Test 2:
        // 100 * 50 + 25 = 5025
        #10;
        a = 32'd100;
        b = 32'd50;
        c = 32'd25;
        start = 1;

        #10;
        start = 0;

        if (result == 64'd5025 && done)
            $display("MAC TEST 2 PASSED");
        else
            $display("MAC TEST 2 FAILED");

        #10;
        $finish;
    end

endmodule