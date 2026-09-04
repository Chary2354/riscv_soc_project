module csr_interrupt (
    input  logic        clk,
    input  logic        rst,

    input  logic        interrupt_request,

    input  logic        csr_write,
    input  logic [11:0] csr_addr,
    input  logic [31:0] csr_write_data,

    output logic [31:0] csr_read_data,
    output logic        interrupt_taken,
    output logic [31:0] interrupt_vector
);

    logic [31:0] mtvec;
    logic [31:0] mstatus;
    logic [31:0] mie;

    always_ff @(posedge clk) begin

        if (rst) begin
            mtvec   <= 32'h00000100;
            mstatus <= 32'b0;
            mie     <= 32'b0;
        end

        else if (csr_write) begin

            case (csr_addr)

                12'h305:
                    mtvec <= csr_write_data;

                12'h300:
                    mstatus <= csr_write_data;

                12'h304:
                    mie <= csr_write_data;

                default: begin
                end

            endcase

        end

    end

    always_comb begin

        case (csr_addr)

            12'h305:
                csr_read_data = mtvec;

            12'h300:
                csr_read_data = mstatus;

            12'h304:
                csr_read_data = mie;

            default:
                csr_read_data = 32'b0;

        endcase

    end

    assign interrupt_taken =
        interrupt_request &&
        mstatus[3] &&
        mie[7];

    assign interrupt_vector = mtvec;

endmodule