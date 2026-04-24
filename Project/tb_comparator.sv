module comparator_tb();

logic [7:0] data_t;
logic [7:0] ramout;
logic       gt;
logic       eq;
logic       lt;

comparator DUT(.*);

// initial begin: fsdb_dump
//   $fsdbDumpfile("dump.fsdb");
//   $fsdbDumpvars;
// end: fsdb_dump

initial begin: testbench

  // --- Equal cases (eq=1, gt=0, lt=0) ---
  data_t = 8'h00; ramout = 8'h00;
  #10;
  if (eq !== 1 || gt !== 0 || lt !== 0) begin
    $display("@@@FAIL: eq case 0x00==0x00");
    $finish;
  end

  data_t = 8'hFF; ramout = 8'hFF;
  #10;
  if (eq !== 1 || gt !== 0 || lt !== 0) begin
    $display("@@@FAIL: eq case 0xFF==0xFF");
    $finish;
  end

  data_t = 8'h55; ramout = 8'h55;
  #10;
  if (eq !== 1 || gt !== 0 || lt !== 0) begin
    $display("@@@FAIL: eq case 0x55==0x55");
    $finish;
  end

  // --- Greater-than cases (gt=1, eq=0, lt=0) ---
  data_t = 8'hFF; ramout = 8'h00;
  #10;
  if (gt !== 1 || eq !== 0 || lt !== 0) begin
    $display("@@@FAIL: gt case 0xFF>0x00");
    $finish;
  end

  data_t = 8'h80; ramout = 8'h7F;
  #10;
  if (gt !== 1 || eq !== 0 || lt !== 0) begin
    $display("@@@FAIL: gt case 0x80>0x7F");
    $finish;
  end

  data_t = 8'h01; ramout = 8'h00;
  #10;
  if (gt !== 1 || eq !== 0 || lt !== 0) begin
    $display("@@@FAIL: gt case 0x01>0x00");
    $finish;
  end

  // --- Less-than cases (lt=1, eq=0, gt=0) ---
  data_t = 8'h00; ramout = 8'hFF;
  #10;
  if (lt !== 1 || eq !== 0 || gt !== 0) begin
    $display("@@@FAIL: lt case 0x00<0xFF");
    $finish;
  end

  data_t = 8'h7F; ramout = 8'h80;
  #10;
  if (lt !== 1 || eq !== 0 || gt !== 0) begin
    $display("@@@FAIL: lt case 0x7F<0x80");
    $finish;
  end

  data_t = 8'h00; ramout = 8'h01;
  #10;
  if (lt !== 1 || eq !== 0 || gt !== 0) begin
    $display("@@@FAIL: lt case 0x00<0x01");
    $finish;
  end

  $display("@@@PASS");
  $finish;
end: testbench

initial begin: monitor
  $monitor("%t data_t:%h ramout:%h gt:%b eq:%b lt:%b", $realtime, data_t, ramout, gt, eq, lt);
end: monitor

endmodule: comparator_tb
