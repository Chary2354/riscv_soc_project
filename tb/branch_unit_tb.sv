`timescale 1ns/1ps

module branch_unit_tb;

    logic [31:0] pc;
    logic [31:0] rs1_data;
    logic [31:0] rs2_data;
    logic [31:0] immediate;

    logic branch;
    logic jump;

    logic branch_taken;
    logic [31:0] branch_target;

    branch_unit dut (
        .pc           (pc),
        .rs1_data     (rs1_data),
        .rs2_data     (rs2_data),
        .immediate    (immediate),
        .branch       (branch),
        .jump         (jump),
        .branch_taken (branch_taken),
        .branch_target(branch_target)
    );

    initial begin

        $display("========================================");
        $display("Branch and Jump Functional Test");
        $display("========================================");

        // Test 1: BEQ taken
        pc        = 32'h00001000;
        rs1_data  = 32'd50;
        rs2_data  = 32'd50;
        immediate = 32'd16;
        branch    = 1'b1;
        jump      = 1'b0;

        #10;

        $display("BEQ taken:");
        $display("branch_taken  = %b", branch_taken);
        $display("branch_target = %h", branch_target);

        if ((branch_taken === 1'b1) &&
            (branch_target === 32'h00001010))
            $display("PASS: BEQ taken");
        else
            $display("ERROR: BEQ taken");

        // Test 2: BEQ not taken
        rs1_data = 32'd50;
        rs2_data = 32'd60;

        #10;

        $display("BEQ not taken:");
        $display("branch_taken  = %b", branch_taken);
        $display("branch_target = %h", branch_target);

        if ((branch_taken === 1'b0) &&
            (branch_target === 32'h00001004))
            $display("PASS: BEQ not taken");
        else
            $display("ERROR: BEQ not taken");

        // Test 3: JUMP
        branch    = 1'b0;
        jump      = 1'b1;
        immediate = 32'd32;

        #10;

        $display("JUMP:");
        $display("branch_taken  = %b", branch_taken);
        $display("branch_target = %h", branch_target);

        if ((branch_taken === 1'b1) &&
            (branch_target === 32'h00001020))
            $display("PASS: JUMP");
        else
            $display("ERROR: JUMP");

        // Test 4: Negative branch offset
        jump      = 1'b0;
        branch    = 1'b1;
        rs1_data  = 32'd100;
        rs2_data  = 32'd100;
        immediate = -32'sd16;

        #10;

        $display("Negative branch:");
        $display("branch_taken  = %b", branch_taken);
        $display("branch_target = %h", branch_target);

        if ((branch_taken === 1'b1) &&
            (branch_target === 32'h00000FF0))
            $display("PASS: Negative branch offset");
        else
            $display("ERROR: Negative branch offset");

        // Test 5: No branch/no jump
        branch    = 1'b0;
        jump      = 1'b0;
        immediate = 32'd100;

        #10;

        $display("Normal sequential execution:");
        $display("branch_taken  = %b", branch_taken);
        $display("branch_target = %h", branch_target);

        if ((branch_taken === 1'b0) &&
            (branch_target === 32'h00001004))
            $display("PASS: PC + 4");
        else
            $display("ERROR: PC + 4");

        $display("========================================");
        $display("Branch/jump test completed");
        $display("========================================");

        $finish;
    end

endmodule