module wb_stage (
    input logic [31:0] alu_result,
    input logic [31:0] memory_data,

    input logic        mem_to_reg,

    output logic [31:0] write_data
);

    always_comb begin

        if (mem_to_reg)
            write_data = memory_data;
        else
            write_data = alu_result;

    end

endmodule