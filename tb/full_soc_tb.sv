`timescale 1ns/1ps

module full_soc_tb;

    // =========================================================
    // CLOCK / RESET
    // =========================================================

    logic clk;
    logic rst;

    // =========================================================
    // UART
    // =========================================================

    logic uart_tx;
    logic uart_rx;

    // =========================================================
    // SPI
    // =========================================================

    logic spi_sclk;
    logic spi_mosi;
    logic spi_miso;
    logic spi_cs;

    // =========================================================
    // I2C
    // =========================================================

    logic i2c_scl;
    logic i2c_sda_out;
    logic i2c_sda_in;

    // =========================================================
    // GPIO
    // =========================================================

    logic [7:0] gpio_in;
    logic [7:0] gpio_out;

    // =========================================================
    // TIMER
    // =========================================================

    logic timer_irq;

    // =========================================================
    // MAC ACCELERATOR
    // =========================================================

    logic [63:0] mac_result;
    logic        mac_done;

    // =========================================================
    // DUT
    // =========================================================

    soc_top dut (
        .clk        (clk),
        .rst        (rst),

        .uart_tx    (uart_tx),
        .uart_rx    (uart_rx),

        .spi_sclk   (spi_sclk),
        .spi_mosi   (spi_mosi),
        .spi_miso   (spi_miso),
        .spi_cs     (spi_cs),

        .i2c_scl    (i2c_scl),
        .i2c_sda_out(i2c_sda_out),
        .i2c_sda_in (i2c_sda_in),

        .gpio_in    (gpio_in),
        .gpio_out   (gpio_out),

        .timer_irq  (timer_irq),

        .mac_result (mac_result),
        .mac_done   (mac_done)
    );

    // =========================================================
    // CLOCK
    // =========================================================

    always #5 clk = ~clk;

    // =========================================================
    // TEST
    // =========================================================

    initial begin

        clk = 1'b0;
        rst = 1'b1;

        // -----------------------------------------------------
        // External inputs
        // -----------------------------------------------------

        uart_rx   = 1'b1;
        spi_miso  = 1'b0;
        i2c_sda_in = 1'b0;
        gpio_in   = 8'hA5;

        // =====================================================
        // CPU PROGRAM (UPDATED SEQUENCE)
        // =====================================================

        // -----------------------------------------------------
        // Instruction 0
        // ADDI x1, x0, 0x55 -> x1 = 0x55
        // -----------------------------------------------------
        dut.cpu.u_if.instruction_memory[0] = 32'h05500093;

        // -----------------------------------------------------
        // Instruction 1
        // Extra NOPs so x1 reaches WB before SW needs it
        // -----------------------------------------------------
        dut.cpu.u_if.instruction_memory[1] = 32'h00000013;

        // -----------------------------------------------------
        // Instruction 2
        // NOP
        // -----------------------------------------------------
        dut.cpu.u_if.instruction_memory[2] = 32'h00000013;

        // -----------------------------------------------------
        // Instruction 3
        // NOP
        // -----------------------------------------------------
        dut.cpu.u_if.instruction_memory[3] = 32'h00000013;

        // -----------------------------------------------------
        // Instruction 4
        // SW x1, 0(x10) -> GPIO[0] <= 0x55 (via address 0x10003000)
        // -----------------------------------------------------
        dut.cpu.u_if.instruction_memory[4] = 32'h00152023;

        // -----------------------------------------------------
        // Additional NOPs
        // -----------------------------------------------------
        dut.cpu.u_if.instruction_memory[5] = 32'h00000013;
        dut.cpu.u_if.instruction_memory[6] = 32'h00000013;
        dut.cpu.u_if.instruction_memory[7] = 32'h00000013;

        // =====================================================
        // RELEASE RESET
        // =====================================================

        #20;

        rst = 1'b0;

        // -----------------------------------------------------
        // Preload x10 with GPIO base address
        //
        // Interconnect mapping:
        // 10000000 -> UART | 10001000 -> SPI  | 10002000 -> I2C
        // 10003000 -> GPIO | 10004000 -> TIMER| 10005000 -> MAC
        // -----------------------------------------------------

        dut.cpu.u_id.rf.regs[10] = 32'h10003000;

        $display("");
        $display("--------------------------------------------");
        $display("FULL SOC TEST STARTED");
        $display("x10 = %h (GPIO BASE)", dut.cpu.u_id.rf.regs[10]);
        $display("Expected GPIO DATA = 55");
        $display("--------------------------------------------");

        // =====================================================
        // RUN CPU
        // =====================================================

        repeat (30) begin

            @(posedge clk);

            // -------------------------------------------------
            // WRITEBACK DEBUG
            // -------------------------------------------------
            if (dut.cpu.debug_wb_reg_write) begin
                $display(
                    "WB: rd=x%0d data=%h",
                    dut.cpu.debug_wb_rd,
                    dut.cpu.debug_wb_data
                );
            end

            // -------------------------------------------------
            // EX STORE DEBUG
            // -------------------------------------------------
            if (dut.cpu.ex_mem_write) begin
                $display(
                    "EX STORE DEBUG: rs2=x%0d ex_rs2=%h forward_b=%b ex_forward_b=%h store_data=%h",
                    dut.cpu.ex_rs2,
                    dut.cpu.ex_rs2_data,
                    dut.cpu.forward_b,
                    dut.cpu.ex_forward_b,
                    dut.cpu.ex_store_data
                );
            end

            // -------------------------------------------------
            // MEMORY WRITE DEBUG
            // -------------------------------------------------
            if (dut.cpu.mem_write) begin
                $display(
                    "CPU WRITE: address=%h data=%h",
                    dut.cpu.mem_address,
                    dut.cpu.mem_write_data
                );
                $display(
                    "MEM STORE DEBUG: mem_store_data=%h",
                    dut.cpu.mem_store_data
                );
            end

            // -------------------------------------------------
            // MAC DEBUG
            // -------------------------------------------------
            if (mac_done) begin
                $display(
                    "MAC DONE: result=%d",
                    mac_result
                );
            end

        end

        // =====================================================
        // FINAL RESULTS
        // =====================================================

        $display("");
        $display("--------------------------------------------");
        $display("FINAL SOC RESULTS");
        $display("--------------------------------------------");

        $display("GPIO OUT  = %h", gpio_out);
        $display("TIMER IRQ  = %b", timer_irq);
        $display("MAC RESULT = %d", mac_result);
        $display("--------------------------------------------");

        $finish;
        
    end

endmodule
