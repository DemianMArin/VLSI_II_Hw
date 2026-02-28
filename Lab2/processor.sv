module processor(
  input logic clk, // clock
  input logic rstN, // active low reset signal
  input logic [31:0] data˙in,
  input logic [31:0] i˙data,
  input logic data˙select,
  input logic [15:0] status˙flags,
  output logic [31:0] data˙out,
  output logic [ 7:0] status,
  output logic [ 2:0] Q
);
