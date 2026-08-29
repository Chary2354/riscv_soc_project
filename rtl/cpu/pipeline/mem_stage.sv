module mem_stage (
    input logic        clk,
    input logic        rst,

    input logic        mem_read,
    input logic        mem_write,

    input logic [31:0] address,
    input logic [31:0] write_data,

    output logic [31:0] read_data
);

    logic [31:0] data_memory [0:255];

    integer i;

    initial begin
        for (i = 0; i < 256; i = i + 1)
            data_memory[i] = 32'b0;
    end

    always_ff @(posedge clk) begin

        if (mem_write)
            data_memory[address[9:2]] <= write_data;

    end

    always_comb begin

        if (mem_read)
            read_data = data_memory[address[9:2]];
        else
            read_data = 32'b0;

    end

endmodule