module pipeline_regs (
    input logic clk,
    input logic rst,

    // Pipeline control
    input logic stall,
    input logic flush,

    // =====================================================
    // IF/ID REGISTER
    // =====================================================

    input  logic [31:0] if_pc,
    input logic [31:0] if_pc_plus4,
    input logic [31:0] if_instr,

    output logic [31:0] id_pc,
    output logic [31:0] id_pc_plus4,
    output logic [31:0] id_instr,

    // =====================================================
    // ID/EX REGISTER
    // =====================================================

    input logic [31:0] id_rs1_data,
    input logic [31:0] id_rs2_data,
    input logic [31:0] id_immediate,

    input logic [4:0] id_rs1,
    input logic [4:0] id_rs2,
    input logic [4:0] id_rd,

    input logic [31:0] id_pc_value,

    input logic        id_reg_write,
    input logic        id_mem_read,
    input logic        id_mem_write,
    input logic        id_mem_to_reg,
    input logic        id_alu_src,
    input logic        id_branch,
    input logic        id_jump,

    input logic [3:0]  id_alu_control,

    output logic [31:0] ex_rs1_data,
    output logic [31:0] ex_rs2_data,
    output logic [31:0] ex_immediate,

    output logic [4:0] ex_rs1,
    output logic [4:0] ex_rs2,
    output logic [4:0] ex_rd,

    output logic [31:0] ex_pc,

    output logic        ex_reg_write,
    output logic        ex_mem_read,
    output logic        ex_mem_write,
    output logic        ex_mem_to_reg,
    output logic        ex_alu_src,
    output logic        ex_branch,
    output logic        ex_jump,

    output logic [3:0]  ex_alu_control,

    // =====================================================
    // EX/MEM REGISTER
    // =====================================================

    input logic [31:0] ex_alu_result,
    input logic [31:0] ex_store_data,

    input logic [4:0] ex_mem_rd,

    input logic        ex_mem_reg_write,
    input logic        ex_mem_mem_read,
    input logic        ex_mem_mem_write,
    input logic        ex_mem_mem_to_reg,

    output logic [31:0] mem_alu_result,
    output logic [31:0] mem_store_data,

    output logic [4:0] mem_rd,

    output logic        mem_reg_write,
    output logic        mem_mem_read,
    output logic        mem_mem_write,
    output logic        mem_mem_to_reg,

    // =====================================================
    // MEM/WB REGISTER
    // =====================================================

    input logic [31:0] mem_read_data,
    input logic [31:0] mem_wb_alu_result,

    input logic [4:0] mem_wb_rd,

    input logic        mem_wb_reg_write,
    input logic        mem_wb_mem_to_reg,

    output logic [31:0] wb_read_data,
    output logic [31:0] wb_alu_result,

    output logic [4:0] wb_rd,

    output logic        wb_reg_write,
    output logic        wb_mem_to_reg
);

    always_ff @(posedge clk) begin

        if (rst) begin

            // =============================================
            // Reset IF/ID
            // =============================================

            id_pc       <= 32'b0;
            id_pc_plus4 <= 32'b0;
            id_instr    <= 32'b0;

            // =============================================
            // Reset ID/EX
            // =============================================

            ex_rs1_data <= 32'b0;
            ex_rs2_data <= 32'b0;
            ex_immediate <= 32'b0;

            ex_rs1 <= 5'b0;
            ex_rs2 <= 5'b0;
            ex_rd  <= 5'b0;

            ex_pc <= 32'b0;

            ex_reg_write  <= 1'b0;
            ex_mem_read   <= 1'b0;
            ex_mem_write  <= 1'b0;
            ex_mem_to_reg <= 1'b0;
            ex_alu_src    <= 1'b0;
            ex_branch     <= 1'b0;
            ex_jump       <= 1'b0;

            ex_alu_control <= 4'b0;

            // =============================================
            // Reset EX/MEM
            // =============================================

            mem_alu_result <= 32'b0;
            mem_store_data <= 32'b0;

            mem_rd <= 5'b0;

            mem_reg_write  <= 1'b0;
            mem_mem_read   <= 1'b0;
            mem_mem_write  <= 1'b0;
            mem_mem_to_reg <= 1'b0;

            // =============================================
            // Reset MEM/WB
            // =============================================

            wb_read_data  <= 32'b0;
            wb_alu_result <= 32'b0;

            wb_rd <= 5'b0;

            wb_reg_write  <= 1'b0;
            wb_mem_to_reg <= 1'b0;

        end

        else begin

            // =================================================
            // IF/ID
            // =================================================

            if (flush) begin

                id_pc       <= 32'b0;
                id_pc_plus4 <= 32'b0;
                id_instr    <= 32'b0;

            end

            else if (!stall) begin

                id_pc       <= if_pc;
                id_pc_plus4 <= if_pc_plus4;
                id_instr    <= if_instr;

            end

            // =================================================
            // ID/EX
            // =================================================

            if (flush) begin

                ex_rs1_data  <= 32'b0;
                ex_rs2_data  <= 32'b0;
                ex_immediate <= 32'b0;

                ex_rs1 <= 5'b0;
                ex_rs2 <= 5'b0;
                ex_rd  <= 5'b0;

                ex_pc <= 32'b0;

                ex_reg_write  <= 1'b0;
                ex_mem_read   <= 1'b0;
                ex_mem_write  <= 1'b0;
                ex_mem_to_reg <= 1'b0;
                ex_alu_src    <= 1'b0;
                ex_branch     <= 1'b0;
                ex_jump       <= 1'b0;

                ex_alu_control <= 4'b0;

            end

            else begin

                ex_rs1_data  <= id_rs1_data;
                ex_rs2_data  <= id_rs2_data;
                ex_immediate <= id_immediate;

                ex_rs1 <= id_rs1;
                ex_rs2 <= id_rs2;
                ex_rd  <= id_rd;

                ex_pc <= id_pc_value;

                ex_reg_write  <= id_reg_write;
                ex_mem_read   <= id_mem_read;
                ex_mem_write  <= id_mem_write;
                ex_mem_to_reg <= id_mem_to_reg;
                ex_alu_src    <= id_alu_src;
                ex_branch     <= id_branch;
                ex_jump       <= id_jump;

                ex_alu_control <= id_alu_control;

            end

            // =================================================
            // EX/MEM
            // =================================================

            mem_alu_result <= ex_alu_result;
            mem_store_data <= ex_store_data;

            mem_rd <= ex_mem_rd;

            mem_reg_write  <= ex_mem_reg_write;
            mem_mem_read   <= ex_mem_mem_read;
            mem_mem_write  <= ex_mem_mem_write;
            mem_mem_to_reg <= ex_mem_mem_to_reg;

            // =================================================
            // MEM/WB
            // =================================================

            wb_read_data  <= mem_read_data;
            wb_alu_result <= mem_wb_alu_result;

            wb_rd <= mem_wb_rd;

            wb_reg_write  <= mem_wb_reg_write;
            wb_mem_to_reg <= mem_wb_mem_to_reg;

        end

    end

endmodule