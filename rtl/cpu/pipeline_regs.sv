module pipeline_regs (
    input clk,
    input rst,
    input stall,
    input flush,

    // IF stage inputs
    input [31:0] if_pc,
    input [31:0] if_pc_plus4,
    input [31:0] if_instr,

    // IF/ID register outputs
    output reg [31:0] id_pc,
    output reg [31:0] id_pc_plus4,
    output reg [31:0] id_instr,

    // ID stage inputs
    input [31:0] id_rs1_data,
    input [31:0] id_rs2_data,
    input [31:0] id_immediate,
    input [4:0]  id_rs1,
    input [4:0]  id_rs2,
    input [4:0]  id_rd,
    input [31:0] id_pc_value,
    input        id_reg_write,
    input        id_mem_read,
    input        id_mem_write,
    input        id_mem_to_reg,
    input        id_alu_src,
    input        id_branch,
    input        id_jump,
    input [3:0]  id_alu_control,

    // ID/EX register outputs
    output reg [31:0] ex_rs1_data,
    output reg [31:0] ex_rs2_data,
    output reg [31:0] ex_immediate,
    output reg [4:0]  ex_rs1,
    output reg [4:0]  ex_rs2,
    output reg [4:0]  ex_rd,
    output reg [31:0] ex_pc,
    output reg        ex_reg_write,
    output reg        ex_mem_read,
    output reg        ex_mem_write,
    output reg        ex_mem_to_reg,
    output reg        ex_alu_src,
    output reg        ex_branch,
    output reg        ex_jump,
    output reg [3:0]  ex_alu_control,

    // EX stage inputs
    input [31:0] ex_alu_result,
    input [31:0] ex_store_data,
    input [4:0]  ex_mem_rd,
    input        ex_mem_reg_write,
    input        ex_mem_mem_read,
    input        ex_mem_mem_write,
    input        ex_mem_mem_to_reg,

    // EX/MEM register outputs
    output reg [31:0] mem_alu_result,
    output reg [31:0] mem_store_data,
    output reg [4:0]  mem_rd,
    output reg        mem_reg_write,
    output reg        mem_mem_read,
    output reg        mem_mem_write,
    output reg        mem_mem_to_reg,

    // MEM stage inputs
    input [31:0] mem_read_data,
    input [31:0] mem_wb_alu_result,
    input [4:0]  mem_wb_rd,
    input        mem_wb_reg_write,
    input        mem_wb_mem_to_reg,

    // MEM/WB register outputs
    output reg [31:0] wb_read_data,
    output reg [31:0] wb_alu_result,
    output reg [4:0]  wb_rd,
    output reg        wb_reg_write,
    output reg        wb_mem_to_reg
);

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            id_pc          <= 32'b0;
            id_pc_plus4    <= 32'b0;
            id_instr       <= 32'b0;
            ex_rs1_data    <= 32'b0;
            ex_rs2_data    <= 32'b0;
            ex_immediate   <= 32'b0;
            ex_rs1         <= 5'b0;
            ex_rs2         <= 5'b0;
            ex_rd          <= 5'b0;
            ex_pc          <= 32'b0;
            ex_reg_write   <= 1'b0;
            ex_mem_read    <= 1'b0;
            ex_mem_write   <= 1'b0;
            ex_mem_to_reg  <= 1'b0;
            ex_alu_src     <= 1'b0;
            ex_branch      <= 1'b0;
            ex_jump        <= 1'b0;
            ex_alu_control <= 4'b0;
            mem_alu_result <= 32'b0;
            mem_store_data <= 32'b0;
            mem_rd         <= 5'b0;
            mem_reg_write  <= 1'b0;
            mem_mem_read   <= 1'b0;
            mem_mem_write  <= 1'b0;
            mem_mem_to_reg <= 1'b0;
            wb_read_data   <= 32'b0;
            wb_alu_result  <= 32'b0;
            wb_rd          <= 5'b0;
            wb_reg_write   <= 1'b0;
            wb_mem_to_reg  <= 1'b0;
        end
        else begin
            // IF/ID Block
            if (stall == 1'b1) begin
                // Keep values
            end
            else if (flush == 1'b1) begin
                id_pc       <= 32'b0;
                id_pc_plus4 <= 32'b0;
                id_instr    <= 32'b0;
            end
            else begin
                id_pc       <= if_pc;
                id_pc_plus4 <= if_pc_plus4;
                id_instr    <= if_instr;
            end

            // ID/EX Block
            if (flush == 1'b1) begin
                ex_reg_write   <= 1'b0;
                ex_mem_read    <= 1'b0;
                ex_mem_write   <= 1'b0;
                ex_mem_to_reg  <= 1'b0;
                ex_alu_src     <= 1'b0;
                ex_branch      <= 1'b0;
                ex_jump        <= 1'b0;
                ex_alu_control <= 4'b0;
            end
            else if (stall == 1'b1) begin
                ex_reg_write   <= 1'b0;
                ex_mem_read    <= 1'b0;
                ex_mem_write   <= 1'b0;
                ex_mem_to_reg  <= 1'b0;
                ex_alu_src     <= 1'b0;
                ex_branch      <= 1'b0;
                ex_jump        <= 1'b0;
                ex_alu_control <= 4'b0;
            end
            else begin
                ex_rs1_data    <= id_rs1_data;
                ex_rs2_data    <= id_rs2_data;
                ex_immediate   <= id_immediate;
                ex_rs1         <= id_rs1;
                ex_rs2         <= id_rs2;
                ex_rd          <= id_rd;
                ex_pc          <= id_pc_value;
                ex_reg_write   <= id_reg_write;
                ex_mem_read    <= id_mem_read;
                ex_mem_write   <= id_mem_write;
                ex_mem_to_reg  <= id_mem_to_reg;
                ex_alu_src     <= id_alu_src;
                ex_branch      <= id_branch;
                ex_jump        <= id_jump;
                ex_alu_control <= id_alu_control;
            end

            // EX/MEM Block
            mem_alu_result <= ex_alu_result;
            mem_store_data <= ex_store_data;
            mem_rd         <= ex_mem_rd;
            mem_reg_write  <= ex_mem_reg_write;
            mem_mem_read   <= ex_mem_mem_read;
            mem_mem_write  <= ex_mem_mem_write;
            mem_mem_to_reg <= ex_mem_mem_to_reg;

            // MEM/WB Block
            wb_read_data   <= mem_read_data;
            wb_alu_result  <= mem_wb_alu_result;
            wb_rd          <= mem_wb_rd;
            wb_reg_write   <= mem_wb_reg_write;
            wb_mem_to_reg  <= mem_wb_mem_to_reg;
        end
    end

endmodule
