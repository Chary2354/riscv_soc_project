module interconnect (
    input  wire [31:0] address,
    input  wire        mem_read,
    input  wire        mem_write,

    output reg         ram_sel,
    output reg         uart_sel,
    output reg         spi_sel,
    output reg         i2c_sel,
    output reg         gpio_sel,
    output reg         timer_sel,
    output reg         accel_sel
);

    // Replaced 'always_comb' with standard Verilog 'always @*'
    always @* begin
        // Default values to prevent latches
        ram_sel   = 1'b0;
        uart_sel  = 1'b0;
        spi_sel   = 1'b0;
        i2c_sel   = 1'b0;
        gpio_sel  = 1'b0;
        timer_sel = 1'b0;
        accel_sel = 1'b0;

        if (mem_read || mem_write) begin
            case (address[31:12])
                20'h00000: ram_sel   = 1'b1;
                20'h10000: uart_sel  = 1'b1;
                20'h10001: spi_sel   = 1'b1;
                20'h10002: i2c_sel   = 1'b1;
                20'h10003: gpio_sel  = 1'b1;
                20'h10004: timer_sel = 1'b1;
                20'h10005: accel_sel = 1'b1;
                default: begin
                    // Kept empty intentionally
                end
            endcase
        end
    end

endmodule