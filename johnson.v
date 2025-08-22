module johnson_counter (
    input clk, rst,
    output reg [3:0] out
);
    always @(posedge clk or posedge rst) begin
        if (rst) 
            out <= 4'b0000;
        else 
            out <= {out[2:0], ~out[3]};
    end
endmodule
