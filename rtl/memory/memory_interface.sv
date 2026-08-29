module memory_interface (
    input  logic        clk,
    input  logic        rst,

    input  logic        mem_read,
    input  logic        mem_write,

    input  logic [31:0] address,
    input  logic [31:0] write_data,

    output logic [31:0] read_data,
    output logic        ready
);

    logic [31:0] memory [0:255];

    integer i;

    initial begin
        for (i = 0; i < 256; i = i + 1)
            memory[i] = 32'b0;
    end

    always_ff @(posedge clk) begin

        if (rst) begin
            ready <= 1'b0;
        end

        else begin

            ready <= 1'b1;

            if (mem_write)
                memory[address[9:2]] <= write_data;

        end

    end

    always_comb begin

        if (mem_read)
            read_data = memory[address[9:2]];
        else
            read_data = 32'b0;

    end

endmodule