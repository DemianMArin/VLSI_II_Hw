module rtl_4bit_adder(
  input logic [3:0] a, // Input A
  input logic [3:0] b, // Input B
  input logic cin, // Carry in
  output logic [3:0] s, // Sum
  output logic cout // Carry out
);

  assign {cout, s} = a + b + cin;

endmodule

module rtl_16bit_adder(
  input logic [15:0] a, // Input A
  input logic [15:0] b, // Input B
  input logic cin, // Carry in
  output logic [15:0] s, // Sum
  output logic cout // Carry out
);

  logic c1, c2, c3; // Internal carry chain

  rtl_4bit_adder add0 (.a(a[ 3: 0]), .b(b[ 3: 0]), .cin(cin), .s(s[ 3: 0]), .cout(c1));
  rtl_4bit_adder add1 (.a(a[ 7: 4]), .b(b[ 7: 4]), .cin(c1),  .s(s[ 7: 4]), .cout(c2));
  rtl_4bit_adder add2 (.a(a[11: 8]), .b(b[11: 8]), .cin(c2),  .s(s[11: 8]), .cout(c3));
  rtl_4bit_adder add3 (.a(a[15:12]), .b(b[15:12]), .cin(c3),  .s(s[15:12]), .cout(cout));

endmodule
