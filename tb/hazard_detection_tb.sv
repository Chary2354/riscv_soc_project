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

        $display("========================================");
        $display("Hazard Detection Test");
        $display("========================================");

        // Test 1: No hazard
        id_ex_mem_read = 1'b0;
        id_ex_rd       = 5'd5;
        if_id_rs1      = 5'd5;
        if_id_rs2      = 5'd6;

        #10;

        $display("Test 1: No hazard");
        $display("pc_write      = %b", pc_write);
        $display("if_id_write   = %b", if_id_write);
        $display("control_stall = %b", control_stall);

        if ((pc_write === 1'b1) &&
            (if_id_write === 1'b1) &&
            (control_stall === 1'b0))
            $display("PASS: No hazard");
        else
            $display("ERROR: No hazard");

        // Test 2: Load-use hazard on rs1
        id_ex_mem_read = 1'b1;
        id_ex_rd       = 5'd5;
        if_id_rs1      = 5'd5;
        if_id_rs2      = 5'd6;

        #10;

        $display("Test 2: Hazard on rs1");
        $display("pc_write      = %b", pc_write);
        $display("if_id_write   = %b", if_id_write);
        $display("control_stall = %b", control_stall);

        if ((pc_write === 1'b0) &&
            (if_id_write === 1'b0) &&
            (control_stall === 1'b1))
            $display("PASS: rs1 load-use hazard");
        else
            $display("ERROR: rs1 load-use hazard");

        // Test 3: Load-use hazard on rs2
        id_ex_mem_read = 1'b1;
        id_ex_rd       = 5'd10;
        if_id_rs1      = 5'd7;
        if_id_rs2      = 5'd10;

        #10;

        $display("Test 3: Hazard on rs2");
        $display("pc_write      = %b", pc_write);
        $display("if_id_write   = %b", if_id_write);
        $display("control_stall = %b", control_stall);

        if ((pc_write === 1'b0) &&
            (if_id_write === 1'b0) &&
            (control_stall === 1'b1))
            $display("PASS: rs2 load-use hazard");
        else
            $display("ERROR: rs2 load-use hazard");

        // Test 4: x0 must not create a hazard
        id_ex_mem_read = 1'b1;
        id_ex_rd       = 5'd0;
        if_id_rs1      = 5'd0;
        if_id_rs2      = 5'd0;

        #10;

        $display("Test 4: x0");
        $display("pc_write      = %b", pc_write);
        $display("if_id_write   = %b", if_id_write);
        $display("control_stall = %b", control_stall);

        if ((pc_write === 1'b1) &&
            (if_id_write === 1'b1) &&
            (control_stall === 1'b0))
            $display("PASS: x0 does not create hazard");
        else
            $display("ERROR: x0 incorrectly creates hazard");

        $display("========================================");
        $display("Hazard detection test completed");
        $display("========================================");

        $finish;
    end

endmodule