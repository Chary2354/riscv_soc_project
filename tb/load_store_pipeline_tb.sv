`timescale 1ns/1ps

module load_store_pipeline_tb;

    logic clk;
    logic rst;

    logic        mem_read;
    logic        mem_write;
    logic [31:0] mem_address;
    logic [31:0] mem_write_data;
    logic [31:0] mem_read_data;

    logic [31:0] debug_pc;
    logic [31:0] debug_wb_data;
    logic [4:0]  debug_wb_rd;
    logic        debug_wb_reg_write;

    pipelined_cpu dut (
        .clk(clk),
        .rst(rst),

        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_address(mem_address),
        .mem_write_data(mem_write_data),
        .mem_read_data(mem_read_data),

        .debug_pc(debug_pc),
        .debug_wb_data(debug_wb_data),
        .debug_wb_rd(debug_wb_rd),
        .debug_wb_reg_write(debug_wb_reg_write)
    );

    always #5 clk = ~clk;

    initial begin

        clk = 1'b0;
        rst = 1'b1;
        mem_read_data = 32'b0;

        // ADDI x5, x0, 42
        dut.u_if.instruction_memory[0] =
            32'h02A00293;

        // SW x5, 0(x0)
        dut.u_if.instruction_memory[1] =
            32'h00502023;

        // LW x6, 0(x0)
        dut.u_if.instruction_memory[2] =
            32'h00002303;

        // NOP
        dut.u_if.instruction_memory[3] =
            32'h00000013;

        // NOP
        dut.u_if.instruction_memory[4] =
            32'h00000013;

        #20;
        rst = 1'b0;

        repeat (15) begin

            @(posedge clk);
            #1;

            $display(
                "PC=%h | WB_EN=%b | WB_RD=x%0d | WB_DATA=%h | MEM_R=%b | MEM_W=%b | MEM_ADDR=%h | MEM_WDATA=%h",
                debug_pc,
                debug_wb_reg_write,
                debug_wb_rd,
                debug_wb_data,
                mem_read,
                mem_write,
                mem_address,
                mem_write_data
            );

        end

        $display("----------------------------------------");
        $display("Load/Store Pipeline Test Complete");
        $display("----------------------------------------");

        $finish;

    end

endmodule