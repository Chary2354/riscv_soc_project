module control_unit (
    input  logic [6:0] opcode,

    output logic       reg_write,
    output logic       mem_read,
    output logic       mem_write,
    output logic       mem_to_reg,
    output logic       alu_src,
    output logic       branch,
    output logic       jump,
    output logic [1:0] alu_op
);

    always_comb begin

        // Default values
        reg_write = 1'b0;
        mem_read  = 1'b0;
        mem_write = 1'b0;
        mem_to_reg = 1'b0;
        alu_src   = 1'b0;
        branch    = 1'b0;
        jump      = 1'b0;
        alu_op    = 2'b00;

        case (opcode)

            // R-type instructions
            7'b0110011: begin
                reg_write = 1'b1;
                alu_src   = 1'b0;
                alu_op    = 2'b10;
            end

            // I-type ALU instructions
            7'b0010011: begin
                reg_write = 1'b1;
                alu_src   = 1'b1;
                alu_op    = 2'b11;
            end

            // Load
            7'b0000011: begin
                reg_write = 1'b1;
                mem_read  = 1'b1;
                mem_to_reg = 1'b1;
                alu_src   = 1'b1;
                alu_op    = 2'b00;
            end

            // Store
            7'b0100011: begin
                mem_write = 1'b1;
                alu_src   = 1'b1;
                alu_op    = 2'b00;
            end

            // Branch
            7'b1100011: begin
                branch = 1'b1;
                alu_src = 1'b0;
                alu_op = 2'b01;
            end

            // JAL
            7'b1101111: begin
                reg_write = 1'b1;
                jump = 1'b1;
            end

            // JALR
            7'b1100111: begin
                reg_write = 1'b1;
                jump = 1'b1;
                alu_src = 1'b1;
                alu_op = 2'b00;
            end

            default: begin
                // Keep default control signals
            end

        endcase
    end

endmodule