module wb_stage (
    input wire [31:0] alu_result,
    input wire [31:0] memory_data,
    input wire        mem_to_reg,
    output reg [31:0] write_data
);
    always @(*) begin
        if (mem_to_reg == 1'b1) begin
            write_data = memory_data;
        end else begin
            write_data = alu_result;
        end
    end
endmodule
