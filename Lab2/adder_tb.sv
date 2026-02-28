module adder_tb();

logic [15:0] a;
logic [15:0] b;
logic        cin;
logic [15:0] s;
logic        cout;

rtl_16bit_adder DUT(.*);

initial begin: fsdb_dump
  $fsdbDumpfile("dump.fsdb");
  $fsdbDumpvars;
end: fsdb_dump

initial begin: testbench

  // Trivial: zero case
  // Input:    a=0x0000, b=0x0000, cin=0
  // Expected: s=0x0000, cout=0
  a = 16'h0000; b = 16'h0000; cin = 1'b0;
  #10;
  if (s !== 16'h0000 || cout !== 1'b0) begin
    $display("@@@FAIL");
    $finish;
  end

  // Trivial: zero inputs with cin asserted
  // Input:    a=0x0000, b=0x0000, cin=1
  // Expected: s=0x0001, cout=0
  a = 16'h0000; b = 16'h0000; cin = 1'b1;
  #10;
  if (s !== 16'h0001 || cout !== 1'b0) begin
    $display("@@@FAIL");
    $finish;
  end

  // Basic: simple addition, no carry generated
  // Input:    a=0x0001, b=0x0001, cin=0
  // Expected: s=0x0002, cout=0
  a = 16'h0001; b = 16'h0001; cin = 1'b0;
  #10;
  if (s !== 16'h0002 || cout !== 1'b0) begin
    $display("@@@FAIL");
    $finish;
  end

  // cin effect: cin increments the result by 1
  // Input:    a=0x0005, b=0x0003, cin=1
  // Expected: s=0x0009, cout=0
  a = 16'h0005; b = 16'h0003; cin = 1'b1;
  #10;
  if (s !== 16'h0009 || cout !== 1'b0) begin
    $display("@@@FAIL");
    $finish;
  end

  // Carry boundary: carry propagates from add0 to add1 (bits 3->4)
  // Input:    a=0x000F, b=0x0001, cin=0
  // Expected: s=0x0010, cout=0
  a = 16'h000F; b = 16'h0001; cin = 1'b0;
  #10;
  if (s !== 16'h0010 || cout !== 1'b0) begin
    $display("@@@FAIL");
    $finish;
  end

  // Carry boundary: carry propagates from add1 to add2 (bits 7->8)
  // Input:    a=0x00FF, b=0x0001, cin=0
  // Expected: s=0x0100, cout=0
  a = 16'h00FF; b = 16'h0001; cin = 1'b0;
  #10;
  if (s !== 16'h0100 || cout !== 1'b0) begin
    $display("@@@FAIL");
    $finish;
  end

  // Carry boundary: carry propagates from add2 to add3 (bits 11->12)
  // Input:    a=0x0FFF, b=0x0001, cin=0
  // Expected: s=0x1000, cout=0
  a = 16'h0FFF; b = 16'h0001; cin = 1'b0;
  #10;
  if (s !== 16'h1000 || cout !== 1'b0) begin
    $display("@@@FAIL");
    $finish;
  end

  // Overflow: carry exits out of add3 as cout (bits 15->cout)
  // Input:    a=0xFFFF, b=0x0001, cin=0
  // Expected: s=0x0000, cout=1
  a = 16'hFFFF; b = 16'h0001; cin = 1'b0;
  #10;
  if (s !== 16'h0000 || cout !== 1'b1) begin
    $display("@@@FAIL");
    $finish;
  end

  // Maximum: all operand bits set, no cin
  // Input:    a=0xFFFF, b=0xFFFF, cin=0
  // Expected: s=0xFFFE, cout=1
  a = 16'hFFFF; b = 16'hFFFF; cin = 1'b0;
  #10;
  if (s !== 16'hFFFE || cout !== 1'b1) begin
    $display("@@@FAIL");
    $finish;
  end

  // Maximum: all inputs saturated including cin
  // Input:    a=0xFFFF, b=0xFFFF, cin=1
  // Expected: s=0xFFFF, cout=1
  a = 16'hFFFF; b = 16'hFFFF; cin = 1'b1;
  #10;
  if (s !== 16'hFFFF || cout !== 1'b1) begin
    $display("@@@FAIL");
    $finish;
  end

  $display("@@@PASS");
  $finish;
end: testbench

initial begin: monitor
  $monitor("%t A:%h B:%h CIN:%b S:%h COUT:%b", $realtime, a, b, cin, s, cout);
end: monitor

endmodule: adder_tb

