`timescale 1ns/1ps

module writeback_tb;

    logic        clk;
    logic        rst;

    logic [31:0] alu_result;
    logic [31:0] memory_data;
    logic        mem_to_reg;

    logic [31:0] wb_write_data;

    logic        wb_reg_write;
    logic [4:0]  wb_rd;

    logic [4:0]  rs1_addr;
    logic [4:0]  rs2_addr;

    logic [31:0] rs1_data;
    logic [31:0] rs2_data;

    wb_stage wb (
        .alu_result  (alu_result),
        .memory_data (memory_data),
        .mem_to_reg  (mem_to_reg),
        .write_data  (wb_write_data)
    );

    regfile rf (
        .clk     (clk),
        .rst     (rst),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .rd_we   (wb_reg_write),
        .rd_addr  (wb_rd),
        .rd_data  (wb_write_data)
    );

    always #5 clk = ~clk;

    initial begin

        clk = 1'b0;
        rst = 1'b1;

        alu_result  = 32'b0;
        memory_data = 32'b0;
        mem_to_reg  = 1'b0;

        wb_reg_write = 1'b0;
        wb_rd = 5'd0;

        rs1_addr = 5'd0;
        rs2_addr = 5'd0;

        #10;
        rst = 1'b0;

        // Write ALU result into x10
        alu_result = 32'h12345678;
        mem_to_reg = 1'b0;

        wb_reg_write = 1'b1;
        wb_rd = 5'd10;

        @(posedge clk);
        #1;

        wb_reg_write = 1'b0;

        // Read x10
        rs1_addr = 5'd10;

        #2;

        $display("x10 = %h", rs1_data);

        if (rs1_data === 32'h12345678)
            $display("PASS: ALU result reached register file");
        else
            $display("ERROR: ALU result write-back");

        // Write memory result into x11
        memory_data = 32'hABCDEF01;
        mem_to_reg = 1'b1;

        wb_reg_write = 1'b1;
        wb_rd = 5'd11;

        @(posedge clk);
        #1;

        wb_reg_write = 1'b0;

        // Read x11
        rs2_addr = 5'd11;

        #2;

        $display("x11 = %h", rs2_data);

        if (rs2_data === 32'hABCDEF01)
            $display("PASS: Memory result reached register file");
        else
            $display("ERROR: Memory result write-back");

        // Verify x0 remains zero
        rs1_addr = 5'd0;

        #2;

        if (rs1_data === 32'b0)
            $display("PASS: x0 remains zero");
        else
            $display("ERROR: x0 was modified");

        $display("========================================");
        $display("Write-back integration test completed");
        $display("========================================");

        $finish;
    end

endmodule