// Mealy FSM for detecting sequence "1101"
// Output goes HIGH (1) as soon as pattern is detected
// Synthesizable in Genus (Verilog-2001)

module mealy_1101 (
    input  wire clk,      // clock
    input  wire reset,    // synchronous active-high reset
    input  wire din,      // serial data input
    output reg  dout      // output = 1 when "1101" detected
);

    // State encoding
    parameter S0 = 3'b000; // no match
    parameter S1 = 3'b001; // got "1"
    parameter S2 = 3'b010; // got "11"
    parameter S3 = 3'b011; // got "110"

    reg [2:0] current_state, next_state;

    // Sequential state transition
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // Next-state and output logic (Mealy)
    always @(*) begin
        // Default assignments
        next_state = S0;
        dout       = 1'b0;

        case (current_state)
            S0: begin
                if (din) next_state = S1;
                else     next_state = S0;
            end

            S1: begin
                if (din) next_state = S2;
                else     next_state = S0;
            end

            S2: begin
                if (din) next_state = S2;   // still "11"
                else     next_state = S3;   // got "110"
            end

            S3: begin
                if (din) begin
                    next_state = S1;        // overlap allowed, last '1' reused
                    dout       = 1'b1;      // "1101" detected!
                end
                else begin
                    next_state = S0;
                end
            end

            default: next_state = S0;
        endcase
    end

endmodule
