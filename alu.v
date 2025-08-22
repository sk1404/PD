// 4-bit ALU with basic operations
module alu_4bit (
    input  [3:0] A, B,          // 4-bit operands
    input  [2:0] ALU_Sel,       // ALU control signal
    output reg [3:0] ALU_Out,   // ALU result
    output reg CarryOut         // Carry flag for addition/subtraction
);

    wire [4:0] sum, diff;

    assign sum  = A + B;
    assign diff = A - B;

    always @(*) begin
        case (ALU_Sel)
            3'b000: begin // ADD
                ALU_Out  = sum[3:0];
                CarryOut = sum[4];
            end

            3'b001: begin // SUB
                ALU_Out  = diff[3:0];
                CarryOut = diff[4];
            end

            3'b010: begin // AND
                ALU_Out  = A & B;
                CarryOut = 0;
            end

            3'b011: begin // OR
                ALU_Out  = A | B;
                CarryOut = 0;
            end

            3'b100: begin // XOR
                ALU_Out  = A ^ B;
                CarryOut = 0;
            end

            default: begin
                ALU_Out  = 4'b0000;
                CarryOut = 0;
            end
        endcase
    end
endmodule
