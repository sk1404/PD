// 8-bit Serial Adder
// Uses: one full adder, two shift registers, carry FF
// Synthesizable in Cadence Genus (Verilog-2001)

module serial_adder_8bit (
    input  wire       clk,
    input  wire       reset,       // synchronous active-high reset
    input  wire       load,        // load parallel data into shift registers
    input  wire [7:0] a_in,        // parallel operand A
    input  wire [7:0] b_in,        // parallel operand B
    output reg  [7:0] sum_out,     // final 8-bit sum (after 8 cycles)
    output reg        carry_out    // final carry
);

    // Internal shift registers
    reg [7:0] A_reg, B_reg;
    reg [7:0] SUM_reg;
    reg       carry;

    integer i; // used for counting cycles (not synthesis-critical)

    // Full Adder function
    function [1:0] full_adder;
        input a, b, cin;
        begin
            full_adder[0] = a ^ b ^ cin;              // sum
            full_adder[1] = (a & b) | (b & cin) | (a & cin); // carry
        end
    endfunction

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            A_reg     <= 8'b0;
            B_reg     <= 8'b0;
            SUM_reg   <= 8'b0;
            carry     <= 1'b0;
            sum_out   <= 8'b0;
            carry_out <= 1'b0;
            i         <= 0;
        end
        else if (load) begin
            // Load operands into shift registers
            A_reg     <= a_in;
            B_reg     <= b_in;
            SUM_reg   <= 8'b0;
            carry     <= 1'b0;
            sum_out   <= 8'b0;
            carry_out <= 1'b0;
            i         <= 0;
        end
        else begin
            if (i < 8) begin
                // Take LSBs of shift registers, add with carry
                {carry, SUM_reg[i]} <= full_adder(A_reg[0], B_reg[0], carry);

                // Shift right operands
                A_reg <= {1'b0, A_reg[7:1]};
                B_reg <= {1'b0, B_reg[7:1]};

                i <= i + 1;
            end
            else begin
                // After 8 cycles, latch result
                sum_out   <= SUM_reg;
                carry_out <= carry;
            end
        end
    end

endmodule
