module timer (
    input  logic        clk,
    input  logic        reset,

    input  logic        cs,
    input  logic        we,
    input  logic [31:0] wdata,
    output logic [31:0] rdata,

    output logic        irq
);

    logic [31:0] counter;
    logic [31:0] compare;
    logic        enable;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 32'd0;
            compare <= 32'd0;
            enable  <= 1'b0;
            irq     <= 1'b0;
        end
        else begin
            irq <= 1'b0;

            if (cs && we) begin
                counter <= wdata;
                compare <= wdata;
                enable  <= 1'b1;
            end

            if (enable) begin
                counter <= counter + 1'b1;

                if (counter >= compare) begin
                    irq <= 1'b1;
                    enable <= 1'b0;
                end
            end
        end
    end

    always_comb begin
        rdata = 32'h00000000;

        if (cs && !we) begin
            rdata = counter;
        end
    end

endmodule