// `timescale 1ns/1ns

module mux_tb();

logic en;
logic sel;
logic [3:0] D0;
logic [3:0] D1;
logic [3:0] Y;

mux DUT(.*);

// initial begin: fsdb_dump
//   $fsdbDumpfile("dump.fsdb");
//   $fsdbDumpvars;
// end: fsdb_dump

initial begin: testbench
  D0 = 4'b0101; D1 = 4'b1101; en = 1; sel = 1;
  #10;
  if (Y !== D1) begin     // en=1, sel=1 -> D1
    $display("@@@FAIL");
    $finish;
  end

  sel = 0;
  #10;
  if (Y !== D0) begin     // en=1, sel=0 -> D0
    $display("@@@FAIL");
    $finish;
  end

  en = 0;
  #10;
  if (Y !== 4'b0000) begin // en=0, sel=0 -> 0
    $display("@@@FAIL");
    $finish;
  end

  sel = 1;
  #10;
  if (Y !== 4'b0000) begin // en=0, sel=1 -> 0
    $display("@@@FAIL");
    $finish;
  end

  en = 1;
  #10;
  if (Y !== D1) begin     // en=1, sel=1 -> D1
    $display("@@@FAIL");
    $finish;
  end

  $display("@@@PASS");
  $finish;
end: testbench

initial begin: monitor
  $monitor("%t EN:%b SEL:%b D0:%b D1:%b Y:%b", $realtime, en, sel, D0, D1, Y);
end: monitor

endmodule: mux_tb
