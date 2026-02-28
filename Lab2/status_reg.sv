module status_reg(
  input logic clk,
  input logic rstN, // active low reset
  input logic int˙en,
  input logic zero,
  input logic carry,
  input logic neg,
  input logic [1:0] parity,
  output logic [7:0] status
);

endmodule
