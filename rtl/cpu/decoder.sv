module decoder (
    input  logic [31:0] instr,

    output logic [4:0]  rs1,
    output logic [4:0]  rs2,
    output logic [4:0]  rd,

    output logic [6:0]  opcode,
    output logic [2:0]  funct3,
    output logic [6:0]  funct7,

    output logic        reg_write,
    output logic        mem_read,
    output logic        mem_write,
    output logic        alu_src,
    output logic        branch,
    output logic        jump,

    output logic [3:0]  alu_control,

    output logic [31:0] immediate,

    output logic        illegal_instr
);

    // RISC-V instruction fields
    always_comb begin

        opcode = instr[6:0];
        rd     = instr[11:7];
        funct3 = instr[14:12];
        rs1    = instr[19:15];
        rs2    = instr[24:20];
        funct7 = instr[31:25];

        // Default control signals
        reg_write   = 1'b0;
        mem_read    = 1'b0;
        mem_write   = 1'b0;
        alu_src     = 1'b0;
        branch      = 1'b0;
        jump        = 1'b0;

        alu_control = 4'b0000;
        immediate   = 32'b0;

        illegal_instr = 1'b0;

        case (opcode)

            // ------------------------------------------------
            // R-Type instructions
            // ADD, SUB, AND, OR, XOR, SLT
            // ------------------------------------------------
            7'b0110011: begin

                reg_write = 1'b1;
                alu_src   = 1'b0;

                case (funct3)

                    3'b000: begin
                        if (funct7 == 7'b0000000)
                            alu_control = 4'b0000; // ADD
                        else if (funct7 == 7'b0100000)
                            alu_control = 4'b0001; // SUB
                        else
                            illegal_instr = 1'b1;
                    end

                    3'b111:
                        alu_control = 4'b0010; // AND

                    3'b110:
                        alu_control = 4'b0011; // OR

                    3'b100:
                        alu_control = 4'b0100; // XOR

                    3'b010:
                        alu_control = 4'b0101; // SLT

                    default:
                        illegal_instr = 1'b1;

                endcase
            end

            // ------------------------------------------------
            // I-Type ALU instructions
            // ADDI, ANDI, ORI, XORI, SLTI
            // ------------------------------------------------
            7'b0010011: begin

                reg_write = 1'b1;
                alu_src   = 1'b1;

                immediate = {{20{instr[31]}}, instr[31:20]};

                case (funct3)

                    3'b000:
                        alu_control = 4'b0000; // ADDI

                    3'b111:
                        alu_control = 4'b0010; // ANDI

                    3'b110:
                        alu_control = 4'b0011; // ORI

                    3'b100:
                        alu_control = 4'b0100; // XORI

                    3'b010:
                        alu_control = 4'b0101; // SLTI

                    default:
                        illegal_instr = 1'b1;

                endcase
            end

            // ------------------------------------------------
            // LOAD
            // LW
            // ------------------------------------------------
            7'b0000011: begin

                reg_write = 1'b1;
                mem_read  = 1'b1;
                alu_src   = 1'b1;

                alu_control = 4'b0000; // Address calculation

                immediate = {{20{instr[31]}}, instr[31:20]};

                if (funct3 != 3'b010)
                    illegal_instr = 1'b1;

            end

            // ------------------------------------------------
            // STORE
            // SW
            // ------------------------------------------------
            7'b0100011: begin

                mem_write = 1'b1;
                alu_src   = 1'b1;

                alu_control = 4'b0000;

                immediate = {
                    {20{instr[31]}},
                    instr[31:25],
                    instr[11:7]
                };

                if (funct3 != 3'b010)
                    illegal_instr = 1'b1;

            end

            // ------------------------------------------------
            // BRANCH
            // BEQ
            // ------------------------------------------------
            7'b1100011: begin

                branch = 1'b1;
                alu_src = 1'b0;

                alu_control = 4'b0001; // SUB for comparison

                immediate = {
                    {19{instr[31]}},
                    instr[31],
                    instr[7],
                    instr[30:25],
                    instr[11:8],
                    1'b0
                };

                if (funct3 != 3'b000)
                    illegal_instr = 1'b1;

            end

            // ------------------------------------------------
            // JAL
            // ------------------------------------------------
            7'b1101111: begin

                jump      = 1'b1;
                reg_write = 1'b1;

                immediate = {
                    {11{instr[31]}},
                    instr[31],
                    instr[19:12],
                    instr[20],
                    instr[30:21],
                    1'b0
                };

            end

            // ------------------------------------------------
            // JALR
            // ------------------------------------------------
            7'b1100111: begin

                jump      = 1'b1;
                reg_write = 1'b1;
                alu_src   = 1'b1;

                immediate = {{20{instr[31]}}, instr[31:20]};

                if (funct3 != 3'b000)
                    illegal_instr = 1'b1;

            end

            // ------------------------------------------------
            // FENCE / SYSTEM / CSR will be added later
            // ------------------------------------------------

            default: begin
                illegal_instr = 1'b1;
            end

        endcase

    end

endmodule