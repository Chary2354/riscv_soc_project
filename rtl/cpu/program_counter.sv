module program_counter (
    input  logic        clk,
    input  logic        rst,

    input  logic        pc_write,
    input  logic [31:0] next_pc,

    output logic [31:0] pc
);

    always_ff @(posedge clk) begin
        if (rst)
            pc <= 32'h00000000;
        else if (pc_write)
            pc <= next_pc;
    end

endmodule