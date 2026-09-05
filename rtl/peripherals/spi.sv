module spi (
    input  logic        clk,
    input  logic        reset,

    input  logic        cs,
    input  logic        we,
    input  logic [31:0] wdata,
    output logic [31:0] rdata,

    output logic        sclk,
    output logic        mosi,
    input  logic        miso,
    output logic        spi_cs
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
    end

    always_comb begin
        rdata = 32'h00000000;

        if (cs && !we)
            rdata[7:0] = rx_data;
    end

    assign mosi   = tx_data[7];
    assign sclk   = clk;
    assign spi_cs = cs;

endmodule