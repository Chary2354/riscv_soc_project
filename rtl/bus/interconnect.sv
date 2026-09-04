module interconnect (
    input  logic [31:0] address,
    input  logic        mem_read,
    input  logic        mem_write,

    output logic        ram_sel,
    output logic        uart_sel,
    output logic        spi_sel,
    output logic        i2c_sel,
    output logic        gpio_sel,
    output logic        timer_sel,
    output logic        accel_sel
);

    always @(*) begin

        // Default: no device selected
        ram_sel   = 1'b0;
        uart_sel  = 1'b0;
        spi_sel   = 1'b0;
        i2c_sel   = 1'b0;
        gpio_sel  = 1'b0;
        timer_sel = 1'b0;
        accel_sel = 1'b0;

        // Address decoding
        if (address >= 32'h0000_0000 &&
            address <= 32'h0000_FFFF) begin
            ram_sel = 1'b1;

        end else if (address >= 32'h1000_0000 &&
                     address <= 32'h1000_0FFF) begin
            uart_sel = 1'b1;

        end else if (address >= 32'h1000_1000 &&
                     address <= 32'h1000_1FFF) begin
            spi_sel = 1'b1;

        end else if (address >= 32'h1000_2000 &&
                     address <= 32'h1000_2FFF) begin
            i2c_sel = 1'b1;

        end else if (address >= 32'h1000_3000 &&
                     address <= 32'h1000_3FFF) begin
            gpio_sel = 1'b1;

        end else if (address >= 32'h1000_4000 &&
                     address <= 32'h1000_4FFF) begin
            timer_sel = 1'b1;

        end else if (address >= 32'h1000_5000 &&
                     address <= 32'h1000_5FFF) begin
            accel_sel = 1'b1;
        end

    end

endmodule