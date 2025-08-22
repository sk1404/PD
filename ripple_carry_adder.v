// 8-bit Serial Adder
// Uses one full adder, two operand shift registers, and a carry flip-flop
// Synthesizable in Cadence Genus (SentOS)

module serial_adder_8bit (
    input  wire       clk,
    input  wire       reset,      // synchronous active-high reset
    input  wire       load,       // load parallel operands when high
    input  wire [7:0] a_in,       // operand A (parallel input)
    input  wire [7:0] b_in,       // operand B (parallel input)
    output reg  [7:0] sum_out,    // final sum (valid after 8 cycles)
    output reg        carry_out,  // final carry (valid after 8 cycles)
    output reg        done        // high when sum_out/carry_out are valid
);

    // Internal registers
    reg [7:0] A_reg, B_reg;       // operand shift registers
    reg [7:0] SUM_reg;            // sum shift register
    reg [2:0] count;              // 3-bit counter (0..7)
    reg       carry;              // carry flip-flop
    reg       busy;               // operation in progress

    // Combinational full adder for current LSBs
    wire sum_bit    = A_reg[0] ^ B_reg[0] ^ carry;
    wire carry_next = (A_reg[0] & B_reg[0]) | 
                      (A_reg[0] & carry)   | 
                      (B_reg[0] & carry);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            A_reg     <= 8'b0;
            B_reg     <= 8'b0;
            SUM_reg   <= 8'b0;
            sum_out   <= 8'b0;
            carry     <= 1'b0;
            carry_out <= 1'b0;
            count     <= 3'd0;
            busy      <= 1'b0;
            done      <= 1'b0;
        end else begin
            if (load && !busy) begin
                // Load operands into shift registers
                A_reg   <= a_in;
                B_reg   <= b_in;
                SUM_reg <= 8'b0;
                carry   <= 1'b0;
                count   <= 3'd0;
                busy    <= 1'b1;
                done    <= 1'b0;
            end else if (busy) begin
                // Perform one-bit addition
                SUM_reg <= {sum_bit, SUM_reg[7:1]}; // shift sum right, insert new MSB
                A_reg   <= {1'b0, A_reg[7:1]};      // shift right operand A
                B_reg   <= {1'b0, B_reg[7:1]};      // shift right operand B
                carry   <= carry_next;
                count   <= count + 3'd1;

                // After 8 cycles, finish
                if (count == 3'd7) begin
                    busy      <= 1'b0;
                    done      <= 1'b1;
                    sum_out   <= {sum_bit, SUM_reg[7:1]}; // final sum
                    carry_out <= carry_next;              // final carry
                end
            end
        end
    end

endmodule
