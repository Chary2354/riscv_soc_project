module gpio (
    input  logic        clk,
    input  logic        reset,

    input  logic        cs,
    input  logic        we,
    input  logic [31:0] wdata,
    output logic [31:0] rdata,

    input  logic [7:0]  gpio_in,
    output logic [7:0]  gpio_out
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            gpio_out <= 8'h00;
        else if (cs && we)
            gpio_out <= wdata[7:0];
    end

    always_comb begin
        rdata = 32'h00000000;

        if (cs && !we)
            rdata[7:0] = gpio_in;
    end

endmodule