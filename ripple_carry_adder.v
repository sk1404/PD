//m1
// 8-bit Ripple Carry Adder
module ripple_carry_adder (
    input  [7:0] a, b,
    input        cin,
    output [7:0] sum,
    output       cout
);

    wire [6:0] c;  // intermediate carries

    full_adder fa0 (a[0], b[0], cin,   sum[0], c[0]);
    full_adder fa1 (a[1], b[1], c[0],  sum[1], c[1]);
    full_adder fa2 (a[2], b[2], c[1],  sum[2], c[2]);
    full_adder fa3 (a[3], b[3], c[2],  sum[3], c[3]);
    full_adder fa4 (a[4], b[4], c[3],  sum[4], c[4]);
    full_adder fa5 (a[5], b[5], c[4],  sum[5], c[5]);
    full_adder fa6 (a[6], b[6], c[5],  sum[6], c[6]);
    full_adder fa7 (a[7], b[7], c[6],  sum[7], cout);

endmodule


// Full Adder Module
module full_adder (
    input  a, b, cin,
    output sum, cout
);

    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule












//m2
//===========================================================
// 8-bit Ripple-Carry Adder
// Compatible with Cadence Genus Synthesis
//===========================================================

module full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule


module ripple_carry_adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire [7:0] c;  // internal carry signals

    // Instantiate 8 full adders
    full_adder fa0 (.a(a[0]), .b(b[0]), .cin(cin),    .sum(sum[0]), .cout(c[0]));
    full_adder fa1 (.a(a[1]), .b(b[1]), .cin(c[0]),   .sum(sum[1]), .cout(c[1]));
    full_adder fa2 (.a(a[2]), .b(b[2]), .cin(c[1]),   .sum(sum[2]), .cout(c[2]));
    full_adder fa3 (.a(a[3]), .b(b[3]), .cin(c[2]),   .sum(sum[3]), .cout(c[3]));
    full_adder fa4 (.a(a[4]), .b(b[4]), .cin(c[3]),   .sum(sum[4]), .cout(c[4]));
    full_adder fa5 (.a(a[5]), .b(b[5]), .cin(c[4]),   .sum(sum[5]), .cout(c[5]));
    full_adder fa6 (.a(a[6]), .b(b[6]), .cin(c[5]),   .sum(sum[6]), .cout(c[6]));
    full_adder fa7 (.a(a[7]), .b(b[7]), .cin(c[6]),   .sum(sum[7]), .cout(cout));

endmodule
