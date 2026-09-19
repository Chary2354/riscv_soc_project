module ex_stage (
    input logic [31:0] rs1_data,
    input logic [31:0] rs2_data,
    input logic [31:0] immediate,

    input logic        alu_src,
    input logic [3:0]  alu_op,

    output logic [31:0] alu_result,
    output logic [31:0] store_data,
    output logic        zero
);

    logic [31:0] alu_b;

    assign alu_b = alu_src ? immediate : rs2_data;

    assign store_data = rs2_data;

    alu alu_unit (
        .a       (rs1_data),
        .b       (alu_b),
        .alu_op  (alu_op),
        .result  (alu_result),
        .zero    (zero)
    );

endmodule