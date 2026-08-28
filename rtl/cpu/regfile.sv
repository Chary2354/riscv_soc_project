module regfile (
    input  logic        clk,
    input  logic        rst,

    input  logic [4:0]  rs1_addr,
    input  logic [4:0]  rs2_addr,

    output logic [31:0] rs1_data,
    output logic [31:0] rs2_data,

    input  logic        rd_we,
    input  logic [4:0]  rd_addr,
    input  logic [31:0] rd_data
);

    logic [31:0] regs [0:31];

    integer i;

    // Reset and write operation
    always_ff @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1)
                regs[i] <= 32'b0;
        end
        else begin
            // x0 is read-only and must remain zero
            if (rd_we && (rd_addr != 5'd0))
                regs[rd_addr] <= rd_data;

            regs[0] <= 32'b0;
        end
    end

    // Combinational read ports
    always_comb begin
        if (rs1_addr == 5'd0)
            rs1_data = 32'b0;
        else
            rs1_data = regs[rs1_addr];

        if (rs2_addr == 5'd0)
            rs2_data = 32'b0;
        else
            rs2_data = regs[rs2_addr];
    end

endmodule