// 8-bit Accumulator
module accumulator_8bit (
    input  wire        clk,
    input  wire        rst,      // active-high synchronous reset
    input  wire        load,     // enable add
    input  wire [7:0]  data_in,  // input data
    output reg  [7:0]  acc_out   // accumulator output
);

    always @(posedge clk) begin
        if (rst)
            acc_out <= 8'b00000000;            // reset
        else if (load)
            acc_out <= acc_out + data_in;      // accumulate
        else
            acc_out <= acc_out;                // hold
    end
endmodule
