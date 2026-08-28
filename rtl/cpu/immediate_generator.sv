module immediate_generator (
    input  logic [31:0] instr,
    output logic [31:0] immediate
);

    logic [6:0] opcode;

    always_comb begin

        opcode = instr[6:0];

        immediate = 32'b0;

        case (opcode)

            // -----------------------------------------
            // I-Type
            // ADDI, LW, JALR
            // -----------------------------------------
            7'b0010011,
            7'b0000011,
            7'b1100111: begin

                immediate = {{20{instr[31]}}, instr[31:20]};

            end

            // -----------------------------------------
            // S-Type
            // SW
            // -----------------------------------------
            7'b0100011: begin

                immediate = {
                    {20{instr[31]}},
                    instr[31:25],
                    instr[11:7]
                };

            end

            // -----------------------------------------
            // B-Type
            // BEQ
            // -----------------------------------------
            7'b1100011: begin

                immediate = {
                    {19{instr[31]}},
                    instr[31],
                    instr[7],
                    instr[30:25],
                    instr[11:8],
                    1'b0
                };

            end

            // -----------------------------------------
            // U-Type
            // LUI / AUIPC
            // -----------------------------------------
            7'b0110111,
            7'b0010111: begin

                immediate = {
                    instr[31:12],
                    12'b0
                };

            end

            // -----------------------------------------
            // J-Type
            // JAL
            // -----------------------------------------
            7'b1101111: begin

                immediate = {
                    {11{instr[31]}},
                    instr[31],
                    instr[19:12],
                    instr[20],
                    instr[30:21],
                    1'b0
                };

            end

            default: begin

                immediate = 32'b0;

            end

        endcase

    end

endmodule