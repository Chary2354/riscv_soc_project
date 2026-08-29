`timescale 1ns/1ps

module forwarding_unit_tb;

    logic [4:0] id_ex_rs1;
    logic [4:0] id_ex_rs2;

    logic [4:0] ex_mem_rd;
    logic       ex_mem_reg_write;

    logic [4:0] mem_wb_rd;
    logic       mem_wb_reg_write;

    logic [1:0] forward_a;
    logic [1:0] forward_b;

    forwarding_unit dut (
        .id_ex_rs1(id_ex_rs1),
        .id_ex_rs2(id_ex_rs2),

        .ex_mem_rd(ex_mem_rd),
        .ex_mem_reg_write(ex_mem_reg_write),

        .mem_wb_rd(mem_wb_rd),
        .mem_wb_reg_write(mem_wb_reg_write),

        .forward_a(forward_a),
        .forward_b(forward_b)
    );

    initial begin

        $display("====================================");
        $display(" Data Forwarding Unit Test");
        $display("====================================");

        // -------------------------------------------------
        // Test 1: No forwarding
        // -------------------------------------------------

        id_ex_rs1 = 5'd1;
        id_ex_rs2 = 5'd2;

        ex_mem_rd = 5'd5;
        ex_mem_reg_write = 1'b0;

        mem_wb_rd = 5'd6;
        mem_wb_reg_write = 1'b0;

        #10;

        if ((forward_a == 2'b00) &&
            (forward_b == 2'b00))

            $display("PASS: No forwarding");

        else
            $display("FAIL: No forwarding");


        // -------------------------------------------------
        // Test 2: EX/MEM forwarding to A
        // -------------------------------------------------

        id_ex_rs1 = 5'd5;
        id_ex_rs2 = 5'd2;

        ex_mem_rd = 5'd5;
        ex_mem_reg_write = 1'b1;

        mem_wb_rd = 5'd6;
        mem_wb_reg_write = 1'b0;

        #10;

        if (forward_a == 2'b10)
            $display("PASS: EX/MEM forwarding to A");
        else
            $display("FAIL: EX/MEM forwarding to A");


        // -------------------------------------------------
        // Test 3: EX/MEM forwarding to B
        // -------------------------------------------------

        id_ex_rs1 = 5'd1;
        id_ex_rs2 = 5'd7;

        ex_mem_rd = 5'd7;
        ex_mem_reg_write = 1'b1;

        #10;

        if (forward_b == 2'b10)
            $display("PASS: EX/MEM forwarding to B");
        else
            $display("FAIL: EX/MEM forwarding to B");


        // -------------------------------------------------
        // Test 4: MEM/WB forwarding to A
        // -------------------------------------------------

        id_ex_rs1 = 5'd8;
        id_ex_rs2 = 5'd2;

        ex_mem_rd = 5'd9;
        ex_mem_reg_write = 1'b0;

        mem_wb_rd = 5'd8;
        mem_wb_reg_write = 1'b1;

        #10;

        if (forward_a == 2'b01)
            $display("PASS: MEM/WB forwarding to A");
        else
            $display("FAIL: MEM/WB forwarding to A");


        // -------------------------------------------------
        // Test 5: MEM/WB forwarding to B
        // -------------------------------------------------

        id_ex_rs1 = 5'd1;
        id_ex_rs2 = 5'd10;

        mem_wb_rd = 5'd10;
        mem_wb_reg_write = 1'b1;

        #10;

        if (forward_b == 2'b01)
            $display("PASS: MEM/WB forwarding to B");
        else
            $display("FAIL: MEM/WB forwarding to B");


        // -------------------------------------------------
        // Test 6: EX/MEM has priority over MEM/WB
        // -------------------------------------------------

        id_ex_rs1 = 5'd11;

        ex_mem_rd = 5'd11;
        ex_mem_reg_write = 1'b1;

        mem_wb_rd = 5'd11;
        mem_wb_reg_write = 1'b1;

        #10;

        if (forward_a == 2'b10)
            $display("PASS: EX/MEM priority");
        else
            $display("FAIL: EX/MEM priority");


        // -------------------------------------------------
        // Test 7: x0 must never be forwarded
        // -------------------------------------------------

        id_ex_rs1 = 5'd0;

        ex_mem_rd = 5'd0;
        ex_mem_reg_write = 1'b1;

        mem_wb_rd = 5'd0;
        mem_wb_reg_write = 1'b1;

        #10;

        if (forward_a == 2'b00)
            $display("PASS: x0 forwarding blocked");
        else
            $display("FAIL: x0 forwarding");


        $display("====================================");
        $display("Data Forwarding Test Completed");
        $display("====================================");

        $finish;

    end

endmodule