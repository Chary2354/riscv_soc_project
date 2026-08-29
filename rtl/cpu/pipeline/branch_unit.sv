module branch_unit (
    input  logic [31:0] pc,
    input  logic [31:0] rs1_data,
    input  logic [31:0] rs2_data,
    input  logic [31:0] immediate,

    input  logic        branch,
    input  logic        jump,

    output logic        branch_taken,
    output logic [31:0] branch_target
);

    always_comb begin

        branch_taken  = 1'b0;
        branch_target = pc + 32'd4;

        // BEQ
        if (branch && (rs1_data == rs2_data)) begin
            branch_taken  = 1'b1;
            branch_target = pc + immediate;
        end

        // JAL/JUMP
        if (jump) begin
            branch_taken  = 1'b1;
            branch_target = pc + immediate;
        end

    end

endmodule