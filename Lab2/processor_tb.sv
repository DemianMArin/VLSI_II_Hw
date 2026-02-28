module processor_tb();
  // Declare inputs (drive these in your test sequence)
  logic clk, // clock
  logic rstN, // active low reset signal
  logic [31:0] data˙in,
  logic [31:0] i˙data,
  logic data˙select,
  logic [15:0] status˙flags,
  // Declare outputs (check these match expected)
  logic [31:0] data˙out;
  logic [ 7:0] status;
  logic [ 2:0] Q;
  // Instantiate DUT (ports match names, so wildcard is OK)
  processor DUT(.*);
  // Simple clock generator (edit period if you want)
  initial clk = 0;
  always #5 clk = ˜clk;
  initial begin
  // Write your test sequence here
  end
endmodule
