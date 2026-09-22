`timescale 1ns/1ps

module cpu_memory_interface_tb;

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

    logic [31:0] external_memory [0:255];

    integer i;
    integer cycle;
    integer store_seen;
    integer load_seen;
    integer load_value_correct;

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

    // External memory model
    always_comb begin
        if (mem_read)
            mem_read_data = external_memory[mem_address[9:2]];
        else
            mem_read_data = 32'b0;
    end

    // External memory write
    always @(posedge clk) begin
        if (mem_write) begin
            external_memory[mem_address[9:2]] <= mem_write_data;

            $display(
                "EXTERNAL MEMORY WRITE: address=%h data=%0d",
                mem_address,
                mem_write_data
            );
        end
    end

    initial begin

        clk = 1'b0;
        rst = 1'b1;

        store_seen = 0;
        load_seen = 0;
        load_value_correct = 0;

        for (i = 0; i < 256; i = i + 1)
            external_memory[i] = 32'b0;

        // ------------------------------------------------
        // Program
        // ------------------------------------------------

        // ADDI x5, x0, 42
        dut.u_if.instruction_memory[0] = 32'h02A00293;

        // SW x5, 0(x0)
        dut.u_if.instruction_memory[1] = 32'h00502023;

        // LW x6, 0(x0)
        dut.u_if.instruction_memory[2] = 32'h00002303;

        // NOP
        dut.u_if.instruction_memory[3] = 32'h00000013;

        // NOP
        dut.u_if.instruction_memory[4] = 32'h00000013;

        // NOP
        dut.u_if.instruction_memory[5] = 32'h00000013;

        // ------------------------------------------------
        // Reset
        // ------------------------------------------------

        #20;
        rst = 1'b0;

        // ------------------------------------------------
        // Run
        // ------------------------------------------------

        for (cycle = 0; cycle < 30; cycle = cycle + 1) begin

            @(posedge clk);
            #1;

            $display(
                "Cycle=%0d | PC=%h | MEM_R=%b | MEM_W=%b | ADDR=%h | WDATA=%0d | WB_EN=%b | WB_RD=x%0d | WB_DATA=%0d",
                cycle,
                debug_pc,
                mem_read,
                mem_write,
                mem_address,
                mem_write_data,
                debug_wb_reg_write,
                debug_wb_rd,
                debug_wb_data
            );

            // Check external store
            if (mem_write) begin
                if ((mem_address == 32'd0) &&
                    (mem_write_data == 32'd42)) begin

                    store_seen = 1;

                    $display(
                        "PASS: CPU generated correct external memory write."
                    );
                end
            end

            // Check external load request
            if (mem_read) begin
                if (mem_address == 32'd0) begin

                    load_seen = 1;

                    $display(
                        "PASS: CPU generated external memory read."
                    );
                end
            end

            // Check loaded value reaching WB
            if (debug_wb_reg_write &&
                (debug_wb_rd == 5'd6) &&
                (debug_wb_data == 32'd42)) begin

                load_value_correct = 1;

                $display(
                    "PASS: Loaded value 42 reached register x6."
                );
            end

        end

        // ------------------------------------------------
        // Final result
        // ------------------------------------------------

        $display("");
        $display("==========================================");
        $display("CPU EXTERNAL MEMORY INTERFACE TEST");
        $display("==========================================");

        if (store_seen)
            $display("PASS: External STORE interface.");
        else
            $display("FAIL: External STORE interface.");

        if (load_seen)
            $display("PASS: External LOAD interface.");
        else
            $display("FAIL: External LOAD interface.");

        if (load_value_correct)
            $display("PASS: LOAD data reached WB correctly.");
        else
            $display("FAIL: LOAD data did not reach WB correctly.");

        if (store_seen && load_seen && load_value_correct)
            $display("PASS: CPU MEMORY INTERFACE TEST PASSED.");
        else
            $display("FAIL: CPU MEMORY INTERFACE TEST FAILED.");

        $display("==========================================");

        $finish;

    end

endmodule