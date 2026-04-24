module counter_tb();

logic       clk;

// length=10 signals
logic        cen10, ld10, u_d10;
logic [9:0]  d_in10, q10;
logic        cout10;

counter #(.length(10)) DUT10 (
    .clk(clk), .cen(cen10), .ld(ld10), .u_d(u_d10),
    .d_in(d_in10), .q(q10), .cout(cout10)
);

initial clk = 0;
always #5 clk = ~clk;

// initial begin: fsdb_dump
//   $fsdbDumpfile("dump.fsdb");
//   $fsdbDumpvars;
// end: fsdb_dump

initial begin: testbench

  cen10 = 0; ld10 = 0; u_d10 = 0; d_in10 = '0;

  // ===== length=10 =====

  // 1. Load
  cen10 = 1; ld10 = 1; d_in10 = 10'h155;
  @(posedge clk); #1;
  if (q10 !== 10'h155) begin
    $display("@@@FAIL: length=10 load");
    $finish;
  end

  // 2. cen=0: counter must not change
  ld10 = 0; cen10 = 0; u_d10 = 1;
  @(posedge clk); #1;
  if (q10 !== 10'h155) begin
    $display("@@@FAIL: length=10 cen=0 blocks count");
    $finish;
  end

  // 3. Count up
  cen10 = 1;
  @(posedge clk); #1;
  if (q10 !== 10'h156) begin
    $display("@@@FAIL: length=10 count up step 1");
    $finish;
  end
  @(posedge clk); #1;
  if (q10 !== 10'h157) begin
    $display("@@@FAIL: length=10 count up step 2");
    $finish;
  end

  // 4. Count down
  u_d10 = 0;
  @(posedge clk); #1;
  if (q10 !== 10'h156) begin
    $display("@@@FAIL: length=10 count down step 1");
    $finish;
  end
  @(posedge clk); #1;
  if (q10 !== 10'h155) begin
    $display("@@@FAIL: length=10 count down step 2");
    $finish;
  end

  // 5. Overflow: count to max (no cout), roll over (cout=1)
  ld10 = 1; d_in10 = 10'h3FE; u_d10 = 1;
  @(posedge clk); #1;
  ld10 = 0;
  @(posedge clk); #1;
  if (q10 !== 10'h3FF || cout10 !== 0) begin
    $display("@@@FAIL: length=10 pre-overflow cout should be 0");
    $finish;
  end
  @(posedge clk); #1;
  if (q10 !== 10'h000 || cout10 !== 1) begin
    $display("@@@FAIL: length=10 overflow cout=1 at rollover");
    $finish;
  end

  // 6. Underflow: count to 0 (no cout), roll over (cout=1)
  ld10 = 1; d_in10 = 10'h001; u_d10 = 0;
  @(posedge clk); #1;
  ld10 = 0;
  @(posedge clk); #1;
  if (q10 !== 10'h000 || cout10 !== 0) begin
    $display("@@@FAIL: length=10 pre-underflow cout should be 0");
    $finish;
  end
  @(posedge clk); #1;
  if (q10 !== 10'h3FF || cout10 !== 1) begin
    $display("@@@FAIL: length=10 underflow cout=1 at rollover");
    $finish;
  end

  // 7. ld priority over u_d=1: ld must win, counter must not increment
  cen10 = 1; ld10 = 1; u_d10 = 1; d_in10 = 10'h155;
  @(posedge clk); #1;
  if (q10 !== 10'h155) begin
    $display("@@@FAIL: length=10 ld priority over u_d=1");
    $finish;
  end

  // 8. ld priority over u_d=0: ld must win, counter must not decrement
  ld10 = 1; u_d10 = 0; d_in10 = 10'h200;
  @(posedge clk); #1;
  if (q10 !== 10'h200) begin
    $display("@@@FAIL: length=10 ld priority over u_d=0");
    $finish;
  end

  // 9. cen=0 blocks ld: counter must not load
  cen10 = 0; ld10 = 1; d_in10 = 10'h3FF;
  @(posedge clk); #1;
  if (q10 !== 10'h200) begin
    $display("@@@FAIL: length=10 cen=0 blocks ld");
    $finish;
  end

  $display("@@@PASS");
  $finish;
end: testbench

initial begin: monitor
  $monitor("%t clk:%b | q10:%h cout10:%b",
           $realtime, clk, q10, cout10);
end: monitor

endmodule: counter_tb
