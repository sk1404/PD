module mod6_counter (
    input clk, rst,
    output reg [2:0] count
);
    always @(posedge clk or posedge rst) begin
        if (rst) 
            count <= 3'b0;
        else if (count == 3'd5) 
            count <= 3'b0;
        else 
            count <= count + 1;
    end
endmodule
