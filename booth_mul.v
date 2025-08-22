
// 4-bit Booth Multiplier
module booth_multiplier_4bit (
    input signed [3:0] A,    // Multiplicand
    input signed [3:0] B,    // Multiplier
    output reg signed [7:0] Product
);

    reg signed [7:0] M, Q, Qn, A_reg;
    integer i;

    always @(*) begin
        // Initialization
        M     = { {4{A[3]}}, A };   // Sign-extended multiplicand (8-bit)
        Q     = { {4{B[3]}}, B };   // Sign-extended multiplier (8-bit)
        Qn    = 0;
        A_reg = 0;
        Product = 0;

        // Booth Algorithm
        for (i = 0; i < 4; i = i + 1) begin
            case ({Q[0], Qn})
                2'b01: A_reg = A_reg + M;   // Add M
                2'b10: A_reg = A_reg - M;   // Sub M
                default: ;                  // Do nothing
            endcase

            // Arithmetic right shift
            {A_reg, Q, Qn} = {A_reg[7], A_reg, Q, Qn} >>> 1;
        end

        Product = {A_reg[3:0], Q[7:4]};  // Final product
    end
endmodule
