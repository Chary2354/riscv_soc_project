`timescale 1ns/1ps

module branch_flush_tb;

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

    integer cycle;
    integer x7_written;
    integer x8_written;

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

    // Clock
    always #5 clk = ~clk;

    initial begin

        clk = 1'b0;
        rst = 1'b1;

        mem_read_data = 32'b0;

        x7_written = 0;
        x8_written = 0;

        // ------------------------------------------------
        // Program
        // ------------------------------------------------

        // ADDI x5, x0, 10
        dut.u_if.instruction_memory[0] = 32'h00A00293;

        // ADDI x6, x0, 10
        dut.u_if.instruction_memory[1] = 32'h00A00313;

        // BEQ x5, x6, +8
        // Branch from PC=8 to PC=16
        dut.u_if.instruction_memory[2] = 32'h00628463;

        // ADDI x7, x0, 99
        // This instruction MUST be flushed
        dut.u_if.instruction_memory[3] = 32'h06300393;

        // ADDI x8, x0, 55
        // Branch target
        dut.u_if.instruction_memory[4] = 32'h03700413;

        // NOP
        dut.u_if.instruction_memory[5] = 32'h00000013;

        // NOP
        dut.u_if.instruction_memory[6] = 32'h00000013;

        // NOP
        dut.u_if.instruction_memory[7] = 32'h00000013;

        // ------------------------------------------------
        // Reset
        // ------------------------------------------------

        #20;
        rst = 1'b0;

        // ------------------------------------------------
        // Run CPU
        // ------------------------------------------------

        for (cycle = 0; cycle < 30; cycle = cycle + 1) begin

            @(posedge clk);

            #1;

            $display(
                "Cycle=%0d | PC=%h | WB_EN=%b | WB_RD=x%0d | WB_DATA=%0d",
                cycle,
                debug_pc,
                debug_wb_reg_write,
                debug_wb_rd,
                debug_wb_data
            );

            // Detect x7 write
            if (debug_wb_reg_write && (debug_wb_rd == 5'd7)) begin
                x7_written = 1;
                $display("ERROR: x7 was written! Branch flush FAILED.");
            end

            // Detect x8 write
            if (debug_wb_reg_write &&
                (debug_wb_rd == 5'd8) &&
                (debug_wb_data == 32'd55)) begin

                x8_written = 1;

                $display("SUCCESS: x8 received 55 at branch target.");
            end

        end

        // ------------------------------------------------
        // Final verification
        // ------------------------------------------------

        $display("");
        $display("==========================================");
        $display("BRANCH + PIPELINE FLUSH TEST RESULT");
        $display("==========================================");

        if (x7_written == 0)
            $display("PASS: x7 instruction was flushed.");

        else
            $display("FAIL: x7 instruction was NOT flushed.");

        if (x8_written == 1)
            $display("PASS: Branch target instruction executed.");

        else
            $display("FAIL: Branch target instruction did not execute.");

        if ((x7_written == 0) && (x8_written == 1))
            $display("PASS: BRANCH + PIPELINE FLUSH TEST PASSED.");

        else
            $display("FAIL: BRANCH + PIPELINE FLUSH TEST FAILED.");

        $display("==========================================");

        $finish;

    end

endmodule