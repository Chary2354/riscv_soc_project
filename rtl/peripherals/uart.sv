module uart (
    input  logic        clk,
    input  logic        reset,

    input  logic        cs,
    input  logic        we,
    input  logic [31:0] wdata,
    output logic [31:0] rdata,

    output logic        tx,
    input  logic        rx
);

    logic [7:0] tx_data;
    logic       tx_busy;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            tx_data <= 8'h00;
            tx_busy <= 1'b0;
        end
        else begin
            if (cs && we) begin
                tx_data <= wdata[7:0];
                tx_busy <= 1'b1;
            end
            else begin
                tx_busy <= 1'b0;
            end
        end
    end

    always_comb begin
        rdata = 32'h00000000;

        if (cs && !we) begin
            rdata[7:0] = tx_data;
            rdata[8]   = tx_busy;
        end
    end

    assign tx = tx_data[0];

endmodule