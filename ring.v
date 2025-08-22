module ring_counter (
    input clk, rst,
    output reg [3:0] out
);
    always @(posedge clk or posedge rst) begin
        if (rst) 
            out <= 4'b0001;         // initialize with one-hot
        else 
            out <= {out[2:0], out[3]};  // rotate left
    end
endmodule
