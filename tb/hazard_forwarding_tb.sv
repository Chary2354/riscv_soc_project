`timescale 1ns/1ps

module hazard_forwarding_tb;

    // Hazard detection signals
    logic       id_ex_mem_read;
    logic [4:0] id_ex_rd;
    logic [4:0] if_id_rs1;
    logic [4:0] if_id_rs2;

    logic       pc_write;
    logic       if_id_write;
    logic       control_stall;

    // Forwarding signals
    logic [4:0] id_ex_rs1;
    logic [4:0] id_ex_rs2;

    logic [4:0] ex_mem_rd;
    logic       ex_mem_reg_write;

    logic [4:0] mem_wb_rd;
    logic       mem_wb_reg_write;

    logic [1:0] forward_a;
    logic [1:0] forward_b;

    hazard_detection hazard_unit (
        .id_ex_mem_read(id_ex_mem_read),
        .id_ex_rd(id_ex_rd),
        .if_id_rs1(if_id_rs1),
        .if_id_rs2(if_id_rs2),
        .pc_write(pc_write),
        .if_id_write(if_id_write),
        .control_stall(control_stall)
    );

    forwarding_unit forwarding_unit_inst (
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

        // Test 1: Normal instruction
        id_ex_mem_read = 0;
        id_ex_rd = 5;
        if_id_rs1 = 1;
        if_id_rs2 = 2;

        id_ex_rs1 = 1;
        id_ex_rs2 = 2;
        ex_mem_rd = 0;
        ex_mem_reg_write = 0;
        mem_wb_rd = 0;
        mem_wb_reg_write = 0;

        #10;

        if (pc_write && if_id_write && !control_stall &&
            forward_a == 2'b00 && forward_b == 2'b00)
            $display("TEST 1 PASS: Normal operation");
        else
            $display("TEST 1 FAIL");


        // Test 2: Load-use hazard
        id_ex_mem_read = 1;
        id_ex_rd = 5;
        if_id_rs1 = 5;
        if_id_rs2 = 2;

        #10;

        if (!pc_write && !if_id_write && control_stall)
            $display("TEST 2 PASS: Load-use hazard detected");
        else
            $display("TEST 2 FAIL");


        // Test 3: Forward from EX/MEM
        id_ex_mem_read = 0;

        id_ex_rs1 = 5;
        id_ex_rs2 = 2;
        ex_mem_rd = 5;
        ex_mem_reg_write = 1;
        mem_wb_rd = 0;
        mem_wb_reg_write = 0;

        #10;

        if (forward_a == 2'b10 && forward_b == 2'b00)
            $display("TEST 3 PASS: EX/MEM forwarding");
        else
            $display("TEST 3 FAIL");


        // Test 4: Forward from MEM/WB
        ex_mem_rd = 0;
        ex_mem_reg_write = 0;

        mem_wb_rd = 5;
        mem_wb_reg_write = 1;

        #10;

        if (forward_a == 2'b01 && forward_b == 2'b00)
            $display("TEST 4 PASS: MEM/WB forwarding");
        else
            $display("TEST 4 FAIL");


        // Test 5: x0 must not create hazard
        id_ex_mem_read = 1;
        id_ex_rd = 0;
        if_id_rs1 = 0;
        if_id_rs2 = 0;

        #10;

        if (pc_write && if_id_write && !control_stall)
            $display("TEST 5 PASS: x0 ignored by hazard unit");
        else
            $display("TEST 5 FAIL");


        $display("----------------------------------------");
        $display("Hazard + Forwarding Test Complete");
        $display("----------------------------------------");

        $finish;
    end

endmodule