module mod9_counter (
    input clk, rst,
    output reg [3:0] count
);
    always @(posedge clk) begin
        if (rst) 
            count <= 4'b0000;        // synchronous reset
        else if (count == 4'd8) 
            count <= 4'b0000;        // wrap at 9
        else 
            count <= count + 1;
    end
endmodule
