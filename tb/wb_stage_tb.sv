`timescale 1ns/1ps

module wb_stage_tb;

    logic [31:0] alu_result;
    logic [31:0] memory_data;

    logic        mem_to_reg;

    logic [31:0] write_data;

    wb_stage dut (
        .alu_result (alu_result),
        .memory_data(memory_data),
        .mem_to_reg (mem_to_reg),
        .write_data (write_data)
    );

    initial begin

        // Test ALU result path
        alu_result  = 32'h12345678;
        memory_data = 32'hABCDEF01;
        mem_to_reg  = 1'b0;

        #10;

        $display("ALU result  = %h", alu_result);
        $display("Memory data = %h", memory_data);
        $display("Write data  = %h", write_data);

        if (write_data === 32'h12345678)
            $display("PASS: ALU result write-back");
        else
            $display("ERROR: ALU result write-back");

        // Test memory result path
        mem_to_reg = 1'b1;

        #10;

        $display("ALU result  = %h", alu_result);
        $display("Memory data = %h", memory_data);
        $display("Write data  = %h", write_data);

        if (write_data === 32'hABCDEF01)
            $display("PASS: Memory data write-back");
        else
            $display("ERROR: Memory data write-back");

        // Test another ALU value
        alu_result = 32'd100;
        mem_to_reg = 1'b0;

        #10;

        if (write_data === 32'd100)
            $display("PASS: Second ALU write-back");
        else
            $display("ERROR: Second ALU write-back");

        $display("========================================");
        $display("WB stage test completed");
        $display("========================================");

        $finish;
    end

endmodule