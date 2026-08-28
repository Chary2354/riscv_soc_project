module if_stage (
    input  logic        clk,
    input  logic        rst,

    input  logic        pc_write,
    input  logic        branch_taken,
    input  logic [31:0] branch_target,

    output logic [31:0] pc,
    output logic [31:0] pc_plus4,
    output logic [31:0] instruction
);

    // Simple instruction memory for initial pipeline testing
    logic [31:0] instruction_memory [0:255];

    integer i;

    // Initialize instruction memory
    initial begin
        for (i = 0; i < 256; i = i + 1)
            instruction_memory[i] = 32'h00000013; // NOP
    end

    // Program Counter
    always_ff @(posedge clk) begin

        if (rst) begin
            pc <= 32'h00000000;
        end

        else if (pc_write) begin

            if (branch_taken)
                pc <= branch_target;
            else
                pc <= pc + 32'd4;

        end

    end

    // PC + 4
    always_comb begin
        pc_plus4 = pc + 32'd4;
    end

    // Instruction fetch
    always_comb begin
        instruction = instruction_memory[pc[9:2]];
    end

endmodule