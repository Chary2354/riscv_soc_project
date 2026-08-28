`timescale 1ns/1ps

module control_unit_tb;

    logic [6:0] opcode;

    logic reg_write;
    logic mem_read;
    logic mem_write;
    logic mem_to_reg;
    logic alu_src;
    logic branch;
    logic jump;
    logic [1:0] alu_op;

    control_unit dut (
        .opcode(opcode),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .alu_src(alu_src),
        .branch(branch),
        .jump(jump),
        .alu_op(alu_op)
    );

    initial begin

        // R-type
        opcode = 7'b0110011;
        #10;

        if (reg_write !== 1'b1 || alu_src !== 1'b0)
            $display("FAIL: R-type");
        else
            $display("PASS: R-type");

        // I-type
        opcode = 7'b0010011;
        #10;

        if (reg_write !== 1'b1 || alu_src !== 1'b1)
            $display("FAIL: I-type");
        else
            $display("PASS: I-type");

        // Load
        opcode = 7'b0000011;
        #10;

        if (reg_write !== 1'b1 || mem_read !== 1'b1 ||
            mem_to_reg !== 1'b1)
            $display("FAIL: Load");
        else
            $display("PASS: Load");

        // Store
        opcode = 7'b0100011;
        #10;

        if (mem_write !== 1'b1 || alu_src !== 1'b1)
            $display("FAIL: Store");
        else
            $display("PASS: Store");

        // Branch
        opcode = 7'b1100011;
        #10;

        if (branch !== 1'b1)
            $display("FAIL: Branch");
        else
            $display("PASS: Branch");

        // JAL
        opcode = 7'b1101111;
        #10;

        if (jump !== 1'b1 || reg_write !== 1'b1)
            $display("FAIL: JAL");
        else
            $display("PASS: JAL");

        $display("==============================");
        $display("Control Unit Test Completed");
        $display("==============================");

        $finish;
    end

endmodule