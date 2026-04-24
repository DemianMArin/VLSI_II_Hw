module controller_tb();

logic clk;
logic rst;
logic start;
logic cout;
logic NbarT;
logic ld;

controller DUT(.*);

initial clk = 0;
always #5 clk = ~clk;

// initial begin: fsdb_dump
//   $fsdbDumpfile("dump.fsdb");
//   $fsdbDumpvars;
// end: fsdb_dump

initial begin: testbench

  start = 0; cout = 0; rst = 0;

  // 1. rst=1: FSM must go to RESET regardless of state
  rst = 1;
  @(posedge clk); #1;
  if (ld !== 1 || NbarT !== 0) begin
    $display("@@@FAIL: rst -> RESET");
    $finish;
  end

  // 2. RESET + start=0: must stay in RESET
  rst = 0; start = 0;
  @(posedge clk); #1;
  if (ld !== 1 || NbarT !== 0) begin
    $display("@@@FAIL: RESET + start=0 should stay in RESET");
    $finish;
  end

  // 3. RESET + start=1: must transition to TEST
  start = 1;
  @(posedge clk); #1;
  if (NbarT !== 1 || ld !== 0) begin
    $display("@@@FAIL: RESET + start=1 should go to TEST");
    $finish;
  end

  // 4. rst=1 from TEST state: must go back to RESET
  start = 0; rst = 1;
  @(posedge clk); #1;
  if (ld !== 1 || NbarT !== 0) begin
    $display("@@@FAIL: rst from TEST should go to RESET");
    $finish;
  end

  // re-enter TEST for remaining cases
  rst = 0; start = 1;
  @(posedge clk); #1;

  // 5. TEST + cout=0: must stay in TEST
  start = 0; cout = 0;
  @(posedge clk); #1;
  if (NbarT !== 1 || ld !== 0) begin
    $display("@@@FAIL: TEST + cout=0 should stay in TEST");
    $finish;
  end

  // 5. TEST + cout=1: must transition back to RESET
  cout = 1;
  @(posedge clk); #1;
  if (ld !== 1 || NbarT !== 0) begin
    $display("@@@FAIL: TEST + cout=1 should go to RESET");
    $finish;
  end

  $display("@@@PASS");
  $finish;
end: testbench

initial begin: monitor
  $monitor("%t clk:%b rst:%b start:%b cout:%b | NbarT:%b ld:%b",
           $realtime, clk, rst, start, cout, NbarT, ld);
end: monitor

endmodule: controller_tb
