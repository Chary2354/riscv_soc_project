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

        // Test 1: No forwarding
        id_ex_rs1 = 5;
        id_ex_rs2 = 6;
        ex_mem_rd = 0;
        ex_mem_reg_write = 0;
        mem_wb_rd = 0;
        mem_wb_reg_write = 0;

        #10;

        if (forward_a == 2'b00 && forward_b == 2'b00)
            $display("TEST 1 PASS: No forwarding");
        else
            $display("TEST 1 FAIL");


        // Test 2: EX/MEM forwarding to A
        id_ex_rs1 = 5;
        id_ex_rs2 = 6;
        ex_mem_rd = 5;
        ex_mem_reg_write = 1;
        mem_wb_rd = 0;
        mem_wb_reg_write = 0;

        #10;

        if (forward_a == 2'b10 && forward_b == 2'b00)
            $display("TEST 2 PASS: EX/MEM -> A");
        else
            $display("TEST 2 FAIL");


        // Test 3: EX/MEM forwarding to B
        id_ex_rs1 = 5;
        id_ex_rs2 = 6;
        ex_mem_rd = 6;
        ex_mem_reg_write = 1;
        mem_wb_rd = 0;
        mem_wb_reg_write = 0;

        #10;

        if (forward_a == 2'b00 && forward_b == 2'b10)
            $display("TEST 3 PASS: EX/MEM -> B");
        else
            $display("TEST 3 FAIL");


        // Test 4: MEM/WB forwarding to A
        id_ex_rs1 = 5;
        id_ex_rs2 = 6;
        ex_mem_rd = 0;
        ex_mem_reg_write = 0;
        mem_wb_rd = 5;
        mem_wb_reg_write = 1;

        #10;

        if (forward_a == 2'b01 && forward_b == 2'b00)
            $display("TEST 4 PASS: MEM/WB -> A");
        else
            $display("TEST 4 FAIL");


        // Test 5: MEM/WB forwarding to B
        id_ex_rs1 = 5;
        id_ex_rs2 = 6;
        ex_mem_rd = 0;
        ex_mem_reg_write = 0;
        mem_wb_rd = 6;
        mem_wb_reg_write = 1;

        #10;

        if (forward_a == 2'b00 && forward_b == 2'b01)
            $display("TEST 5 PASS: MEM/WB -> B");
        else
            $display("TEST 5 FAIL");


        // Test 6: EX/MEM has priority over MEM/WB
        id_ex_rs1 = 5;
        id_ex_rs2 = 6;
        ex_mem_rd = 5;
        ex_mem_reg_write = 1;
        mem_wb_rd = 5;
        mem_wb_reg_write = 1;

        #10;

        if (forward_a == 2'b10)
            $display("TEST 6 PASS: EX/MEM priority");
        else
            $display("TEST 6 FAIL");


        // Test 7: x0 must never be forwarded
        id_ex_rs1 = 0;
        id_ex_rs2 = 0;
        ex_mem_rd = 0;
        ex_mem_reg_write = 1;
        mem_wb_rd = 0;
        mem_wb_reg_write = 1;

        #10;

        if (forward_a == 2'b00 && forward_b == 2'b00)
            $display("TEST 7 PASS: x0 not forwarded");
        else
            $display("TEST 7 FAIL");


        $display("--------------------------------");
        $display("Forwarding Unit Test Complete");
        $display("--------------------------------");

        $finish;
    end

endmodule