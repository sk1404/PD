// 8-bit Parallel-In Serial-Out (PISO) Shift Register
// Synthesizable in Cadence Genus (Verilog-2001)

module piso_8bit (
    input  wire       clk,       // clock
    input  wire       reset,     // synchronous active-high reset
    input  wire       load,      // load enable: when high, parallel data is loaded
    input  wire [7:0] data_in,   // parallel data input
    output reg        serial_out // serial data output (MSB first)
);

    reg [7:0] shift_reg;

    // Sequential block
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg   <= 8'b0;
            serial_out  <= 1'b0;
        end
        else if (load) begin
            // Load parallel data into shift register
            shift_reg   <= data_in;
            serial_out  <= data_in[7]; // output MSB first
        end
        else begin
            // Shift left, output MSB
            shift_reg   <= {shift_reg[6:0], 1'b0};
            serial_out  <= shift_reg[7];
        end
    end

endmodule
