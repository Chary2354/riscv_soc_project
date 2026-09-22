`timescale 1ns/1ps

module jump_flush_tb;

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
    integer x6_written;
    integer x7_written;

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

        x6_written = 0;
        x7_written = 0;

        // ---------------------------------------------
        // Program
        // ---------------------------------------------

        // JAL x5, +8
        // PC=0 -> target PC=8
        // x5 should receive return address PC+4 = 4
        dut.u_if.instruction_memory[0] = 32'h008002EF;

        // ADDI x6, x0, 99
        // This instruction must be flushed
        dut.u_if.instruction_memory[1] = 32'h06300313;

        // ADDI x7, x0, 55
        // Jump target at PC=8
        dut.u_if.instruction_memory[2] = 32'h03700393;

        // NOP
        dut.u_if.instruction_memory[3] = 32'h00000013;

        // NOP
        dut.u_if.instruction_memory[4] = 32'h00000013;

        // NOP
        dut.u_if.instruction_memory[5] = 32'h00000013;

        // ---------------------------------------------
        // Reset
        // ---------------------------------------------

        #20;
        rst = 1'b0;

        // ---------------------------------------------
        // Run
        // ---------------------------------------------

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

            // x6 must NOT be written
            if (debug_wb_reg_write &&
                (debug_wb_rd == 5'd6)) begin

                x6_written = 1;

                $display(
                    "ERROR: x6 was written. JAL flush FAILED."
                );
            end

            // x7 must receive 55
            if (debug_wb_reg_write &&
                (debug_wb_rd == 5'd7) &&
                (debug_wb_data == 32'd55)) begin

                x7_written = 1;

                $display(
                    "SUCCESS: x7 received 55 at JAL target."
                );
            end

        end

        // ---------------------------------------------
        // Final result
        // ---------------------------------------------

        $display("");
        $display("==========================================");
        $display("JAL + PIPELINE FLUSH TEST RESULT");
        $display("==========================================");

        if (x6_written == 0)
            $display("PASS: Wrong-path x6 instruction was flushed.");
        else
            $display("FAIL: Wrong-path x6 instruction executed.");

        if (x7_written == 1)
            $display("PASS: JAL target instruction executed.");
        else
            $display("FAIL: JAL target instruction did not execute.");

        if ((x6_written == 0) && (x7_written == 1))
            $display("PASS: JAL + PIPELINE FLUSH TEST PASSED.");
        else
            $display("FAIL: JAL + PIPELINE FLUSH TEST FAILED.");

        $display("==========================================");

        $finish;

    end

endmodule