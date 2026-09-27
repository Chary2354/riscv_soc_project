module soc_top (
    input  logic        clk,
    input  logic        rst,

    // UART
    output logic        uart_tx,
    input  logic        uart_rx,

    // SPI
    output logic        spi_sclk,
    output logic        spi_mosi,
    input  logic        spi_miso,
    output logic        spi_cs,

    // I2C
    output logic        i2c_scl,
    output logic        i2c_sda_out,
    input  logic        i2c_sda_in,

    // GPIO
    input  logic [7:0]  gpio_in,
    output logic [7:0]  gpio_out,

    // Timer
    output logic        timer_irq,

    // MAC
    output logic [63:0] mac_result,
    output logic        mac_done
);

    // =========================================================
    // CPU memory interface
    // =========================================================

    logic        mem_read;
    logic        mem_write;
    logic [31:0] mem_address;
    logic [31:0] mem_write_data;
    logic [31:0] mem_read_data;

    logic [31:0] debug_pc;
    logic [31:0] debug_wb_data;
    logic [4:0]  debug_wb_rd;
    logic        debug_wb_reg_write;

    // =========================================================
    // CPU
    // =========================================================

    pipelined_cpu cpu (
        .clk               (clk),
        .rst               (rst),
        .mem_read          (mem_read),
        .mem_write         (mem_write),
        .mem_address       (mem_address),
        .mem_write_data    (mem_write_data),
        .mem_read_data     (mem_read_data),
        .debug_pc          (debug_pc),
        .debug_wb_data     (debug_wb_data),
        .debug_wb_rd       (debug_wb_rd),
        .debug_wb_reg_write(debug_wb_reg_write)
    );

    // =========================================================
    // BUS INTERCONNECT
    // =========================================================

    logic ram_sel;
    logic uart_sel;
    logic spi_sel;
    logic i2c_sel;
    logic gpio_sel;
    logic timer_sel;
    logic accel_sel;

    bus_interconnect bus (
        .address   (mem_address),
        .mem_read  (mem_read),
        .mem_write (mem_write),

        .ram_sel   (ram_sel),
        .uart_sel  (uart_sel),
        .spi_sel   (spi_sel),
        .i2c_sel   (i2c_sel),
        .gpio_sel  (gpio_sel),
        .timer_sel (timer_sel),
        .accel_sel (accel_sel)
    );

    // =========================================================
    // RAM
    // =========================================================

    logic [31:0] ram_read_data;
    logic        ram_ready;

    memory_interface ram (
        .clk       (clk),
        .rst       (rst),
        .mem_read  (ram_sel && mem_read),
        .mem_write (ram_sel && mem_write),
        .address   (mem_address),
        .write_data(mem_write_data),
        .read_data (ram_read_data),
        .ready     (ram_ready)
    );

    // =========================================================
    // UART
    // =========================================================

    logic [31:0] uart_read_data;

    uart uart_peripheral (
        .clk   (clk),
        .reset (rst),
        .cs    (uart_sel),
        .we    (mem_write),
        .wdata (mem_write_data),
        .rdata (uart_read_data),
        .tx    (uart_tx),
        .rx    (uart_rx)
    );

    // =========================================================
    // SPI
    // =========================================================

    logic [31:0] spi_read_data;

    spi spi_peripheral (
        .clk    (clk),
        .reset  (rst),
        .cs     (spi_sel),
        .we     (mem_write),
        .wdata  (mem_write_data),
        .rdata  (spi_read_data),
        .sclk   (spi_sclk),
        .mosi   (spi_mosi),
        .miso   (spi_miso),
        .spi_cs (spi_cs)
    );

    // =========================================================
    // I2C
    // =========================================================

    logic [31:0] i2c_read_data;

    i2c i2c_peripheral (
        .clk     (clk),
        .reset   (rst),
        .cs      (i2c_sel),
        .we      (mem_write),
        .wdata   (mem_write_data),
        .rdata   (i2c_read_data),
        .scl     (i2c_scl),
        .sda_out (i2c_sda_out),
        .sda_in  (i2c_sda_in)
    );

    // =========================================================
    // GPIO
    // =========================================================

    logic [31:0] gpio_read_data;

    gpio gpio_peripheral (
        .clk      (clk),
        .reset    (rst),
        .cs       (gpio_sel),
        .we       (mem_write),
        .wdata    (mem_write_data),
        .rdata    (gpio_read_data),
        .gpio_in  (gpio_in),
        .gpio_out (gpio_out)
    );

    // =========================================================
    // TIMER
    // =========================================================

    logic [31:0] timer_read_data;

    timer timer_peripheral (
        .clk   (clk),
        .reset (rst),
        .cs    (timer_sel),
        .we    (mem_write),
        .wdata (mem_write_data),
        .rdata (timer_read_data),
        .irq   (timer_irq)
    );

    // =========================================================
    // MAC ACCELERATOR
    // =========================================================

    logic        mac_start;
    logic [31:0] mac_a;
    logic [31:0] mac_b;
    logic [31:0] mac_c;

    mac_accelerator mac (
        .clk    (clk),
        .reset  (rst),
        .start  (mac_start),
        .a      (mac_a),
        .b      (mac_b),
        .c      (mac_c),
        .result (mac_result),
        .done   (mac_done)
    );

    // =========================================================
    // MAC CONTROL REGISTERS
    //
    // 0x10005000 -> A
    // 0x10005004 -> B
    // 0x10005008 -> C
    // 0x1000500C -> START
    // =========================================================

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            mac_start <= 1'b0;
            mac_a     <= 32'd0;
            mac_b     <= 32'd0;
            mac_c     <= 32'd0;
        end
        else begin
            mac_start <= 1'b0;

            if (accel_sel && mem_write) begin
                case (mem_address[3:2])
                    2'b00: mac_a <= mem_write_data;
                    2'b01: mac_b <= mem_write_data;
                    2'b10: mac_c <= mem_write_data;
                    2'b11: mac_start <= 1'b1;
                    default: ;
                endcase
            end
        end
    end

    logic [31:0] accel_read_data;

    always_comb begin
        accel_read_data = 32'h00000000;

        if (accel_sel && mem_read) begin
            case (mem_address[3:2])
                2'b00: accel_read_data = mac_a;
                2'b01: accel_read_data = mac_b;
                2'b10: accel_read_data = mac_c;
                2'b11: accel_read_data = mac_result[31:0];
                default: accel_read_data = 32'h00000000;
            endcase
        end
    end

    // =========================================================
    // CPU READ-DATA MULTIPLEXER
    // =========================================================

    always_comb begin
        mem_read_data = 32'h00000000;

        if (ram_sel)
            mem_read_data = ram_read_data;
        else if (uart_sel)
            mem_read_data = uart_read_data;
        else if (spi_sel)
            mem_read_data = spi_read_data;
        else if (i2c_sel)
            mem_read_data = i2c_read_data;
        else if (gpio_sel)
            mem_read_data = gpio_read_data;
        else if (timer_sel)
            mem_read_data = timer_read_data;
        else if (accel_sel)
            mem_read_data = accel_read_data;
    end

endmodule
