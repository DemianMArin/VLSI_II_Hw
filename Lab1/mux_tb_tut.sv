module test(
  input logic en,
  input logic sel,
  input logic [3:0] D0,
  input logic [3:0] D1,
  output logic [3:0] Y
);

timeunit 1ns/1ns;

initial begin: fsdb_dump
  $fsdbDumpfile("dump.fsdb"); 
  $fsdbDumpvars;
end: fsdb_dump

initial begin: testbench
  D0 = 4'b0101;
  D1 = 4'b1101;
  en = 1;
  sel = 1;
  #10 
  $finish;
end: testbench

initial begin: monitor 
  $monitor("%t EN:%b SEL:%b D0:%b D1:%b Y:%Y", $realtime, en, sel, D0, D1, Y);
  end: monitor
endmodule: test

module top;
  timeunit 1ns/1ns;
  logic sel,en;
  logic [3:0] D0, D1;
  logic [3:0] Y;
  mux dut(.*);
  test test1(.*);
endmodule: top

