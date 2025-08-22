// 8-bit Universal Shift Register
// Supports Hold / Shift Left / Shift Right / Parallel Load
// Synthesizable in Cadence Genus (Verilog-2001)

module universal_shift_reg (
    input  wire       clk,        // clock
    input  wire       reset,      // synchronous active-high reset
    input  wire [1:0] mode,       // control: 00=Hold, 01=Shift Right, 10=Shift Left, 11=Parallel Load
    input  wire [7:0] data_in,    // parallel data input
    input  wire       s_left,     // serial input for shift left
    input  wire       s_right,    // serial input for shift right
    output reg  [7:0] q           // register output
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 8'b0;
        end
        else begin
            case (mode)
                2'b00: q <= q;                           // Hold
                2'b01: q <= {s_left, q[7:1]};            // Shift Right
                2'b10: q <= {q[6:0], s_right};           // Shift Left
                2'b11: q <= data_in;                     // Parallel Load
                default: q <= q;                         // Safe hold
            endcase
        end
    end

endmodule
