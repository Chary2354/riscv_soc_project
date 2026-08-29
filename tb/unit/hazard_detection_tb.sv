`timescale 1ns/1ps

module hazard_detection_tb;

    logic        id_ex_mem_read;
    logic [4:0]  id_ex_rd;

    logic [4:0]  if_id_rs1;
    logic [4:0]  if_id_rs2;

    logic        pc_write;
    logic        if_id_write;
    logic        control_stall;

    hazard_detection dut (
        .id_ex_mem_read(id_ex_mem_read),
        .id_ex_rd(id_ex_rd),
        .if_id_rs1(if_id_rs1),
        .if_id_rs2(if_id_rs2),
        .pc_write(pc_write),
        .if_id_write(if_id_write),
        .control_stall(control_stall)
    );

    initial begin

        $display("====================================");
        $display("Hazard Detection Unit Test");
        $display("====================================");

        // Test 1: No hazard
        id_ex_mem_read = 1'b0;
        id_ex_rd       = 5'd5;
        if_id_rs1      = 5'd5;
        if_id_rs2      = 5'd3;

        #10;

        $display("Test 1: No hazard");
        $display("PC Write = %b, IF/ID Write = %b, Stall = %b",
                 pc_write, if_id_write, control_stall);

        // Test 2: Load-use hazard
        id_ex_mem_read = 1'b1;
        id_ex_rd       = 5'd5;
        if_id_rs1      = 5'd5;
        if_id_rs2      = 5'd3;

        #10;

        $display("Test 2: Load-use hazard");
        $display("PC Write = %b, IF/ID Write = %b, Stall = %b",
                 pc_write, if_id_write, control_stall);

        // Test 3: Hazard through rs2
        id_ex_mem_read = 1'b1;
        id_ex_rd       = 5'd7;
        if_id_rs1      = 5'd2;
        if_id_rs2      = 5'd7;

        #10;

        $display("Test 3: Hazard through rs2");
        $display("PC Write = %b, IF/ID Write = %b, Stall = %b",
                 pc_write, if_id_write, control_stall);

        // Test 4: Register x0 should not cause hazard
        id_ex_mem_read = 1'b1;
        id_ex_rd       = 5'd0;
        if_id_rs1      = 5'd0;
        if_id_rs2      = 5'd2;

        #10;

        $display("Test 4: x0 check");
        $display("PC Write = %b, IF/ID Write = %b, Stall = %b",
                 pc_write, if_id_write, control_stall);

        $display("====================================");
        $display("Hazard Detection Test Completed");
        $display("====================================");

        $finish;
    end

endmodule