// Moore FSM for detecting 1101
// Synthesizable in Cadence Genus + Innovus

module moore_1101 (
    input  wire clk,    // clock
    input  wire reset,  // active high synchronous reset
    input  wire din,    // serial input bit stream
    output reg  dout    // output = 1 when 1101 detected
);

    // State encoding (one-hot or binary — binary chosen here)
    parameter S0 = 3'b000; // no match
    parameter S1 = 3'b001; // got '1'
    parameter S2 = 3'b010; // got "11"
    parameter S3 = 3'b011; // got "110"
    parameter S4 = 3'b100; // got "1101" → detected

    reg [2:0] current_state, next_state;

    // Sequential: state transition
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // Next-state combinational logic
    always @(*) begin
        case (current_state)
            S0: next_state = (din) ? S1 : S0;
            S1: next_state = (din) ? S2 : S0;
            S2: next_state = (din) ? S2 : S3;
            S3: next_state = (din) ? S4 : S0;
            S4: next_state = (din) ? S2 : S3; // allow overlapping sequences
            default: next_state = S0;
        endcase
    end

    // Moore output logic (depends only on state)
    always @(*) begin
        if (current_state == S4)
            dout = 1'b1;
        else
            dout = 1'b0;
    end

endmodule
