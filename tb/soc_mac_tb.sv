`timescale 1ns/1ps

module soc_mac_tb;

    logic clk;
    logic rst;

    logic [63:0] mac_result;
    logic mac_done;

    logic done_seen;

    soc_top dut (
        .clk        (clk),
        .rst        (rst),
        .mac_result (mac_result),
        .mac_done   (mac_done)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        done_seen = 1'b0;

        // ------------------------------------------------
        // Program
        // ------------------------------------------------
        // x1 = 10
        // x2 = 20
        // x3 = 5
        //
        // MAC address map:
        // 0x10005000 -> A
        // 0x10005004 -> B
        // 0x10005008 -> C
        // 0x1000500C -> START
        //
        // x10 is preloaded with 0x10005000 below.
        // ------------------------------------------------

        dut.cpu.u_if.instruction_memory[0] = 32'h00A00093; // ADDI x1,x0,10
        dut.cpu.u_if.instruction_memory[1] = 32'h01400113; // ADDI x2,x0,20
        dut.cpu.u_if.instruction_memory[2] = 32'h00500193; // ADDI x3,x0,5

        // NOPs to allow register writeback
        dut.cpu.u_if.instruction_memory[3] = 32'h00000013;
        dut.cpu.u_if.instruction_memory[4] = 32'h00000013;

        // SW x1, 0(x10)
        dut.cpu.u_if.instruction_memory[5] = 32'h00152023;

        // SW x2, 4(x10)
        dut.cpu.u_if.instruction_memory[6] = 32'h00252223;

        // SW x3, 8(x10)
        dut.cpu.u_if.instruction_memory[7] = 32'h00352423;

        // SW x0, 12(x10) -> START
        dut.cpu.u_if.instruction_memory[8] = 32'h00052623;

        // NOPs
        dut.cpu.u_if.instruction_memory[9]  = 32'h00000013;
        dut.cpu.u_if.instruction_memory[10] = 32'h00000013;
        dut.cpu.u_if.instruction_memory[11] = 32'h00000013;

        // ------------------------------------------------
        // Hold reset for a few cycles
        // ------------------------------------------------
        #20;
        rst = 0;

        // ------------------------------------------------
        // Preload x10 with MAC base address
        // ------------------------------------------------
        dut.cpu.u_id.rf.regs[10] = 32'h10005000;

        $display("x10 = %h", dut.cpu.u_id.rf.regs[10]);

        // ------------------------------------------------
        // Monitor CPU memory writes and MAC completion
        // ------------------------------------------------
        repeat (50) begin
            @(posedge clk);

            if (dut.cpu.mem_write) begin
                $display("CPU WRITE: address=%h data=%h",
                         dut.cpu.mem_address,
                         dut.cpu.mem_write_data);
            end

            if (mac_done) begin
                done_seen = 1'b1;
                $display("MAC DONE detected!");
                $display("MAC RESULT = %d", mac_result);
            end
        end

        $display("--------------------------------");
        $display("FINAL MAC RESULT = %d", mac_result);
        $display("MAC DONE SEEN     = %b", done_seen);
        $display("--------------------------------");

        if ((mac_result == 64'd205) && done_seen) begin
            $display("TEST PASSED: CPU -> BUS -> MAC");
        end
        else begin
            $display("TEST FAILED");
        end

        $finish;
    end

endmodule
