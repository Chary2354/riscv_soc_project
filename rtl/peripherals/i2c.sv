module i2c (
    input  logic        clk,
    input  logic        reset,

    input  logic        cs,
    input  logic        we,
    input  logic [31:0] wdata,
    output logic [31:0] rdata,

    output logic        scl,
    output logic        sda_out,
    input  logic        sda_in
);

    logic [7:0] tx_data;
    logic [7:0] rx_data;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            tx_data <= 8'h00;
            rx_data <= 8'h00;
        end
        else if (cs && we) begin
            tx_data <= wdata[7:0];
        end
        else if (cs && !we) begin
            rx_data <= {7'b0, sda_in};
        end
    end

    always_comb begin
        rdata = 32'h00000000;

        if (cs && !we)
            rdata[7:0] = rx_data;
    end

    assign scl = clk;
    assign sda_out = tx_data[7];

endmodule