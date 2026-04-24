module decoder_tb();

logic [2:0] q;
logic [7:0] data_t;

decoder DUT(.*);

// initial begin: fsdb_dump
//   $fsdbDumpfile("dump.fsdb");
//   $fsdbDumpvars;
// end: fsdb_dump

initial begin: testbench

  q = 3'b000; #10;
  if (data_t !== 8'b10101010) begin
    $display("@@@FAIL: q=000 expected 10101010");
    $finish;
  end

  q = 3'b001; #10;
  if (data_t !== 8'b01010101) begin
    $display("@@@FAIL: q=001 expected 01010101");
    $finish;
  end

  q = 3'b010; #10;
  if (data_t !== 8'b11110000) begin
    $display("@@@FAIL: q=010 expected 11110000");
    $finish;
  end

  q = 3'b011; #10;
  if (data_t !== 8'b00001111) begin
    $display("@@@FAIL: q=011 expected 00001111");
    $finish;
  end

  q = 3'b100; #10;
  if (data_t !== 8'b00000000) begin
    $display("@@@FAIL: q=100 expected 00000000");
    $finish;
  end

  q = 3'b101; #10;
  if (data_t !== 8'b11111111) begin
    $display("@@@FAIL: q=101 expected 11111111");
    $finish;
  end

  q = 3'b110; #10;
  if (data_t !== 8'bxxxxxxxx) begin
    $display("@@@FAIL: q=110 expected x");
    $finish;
  end

  q = 3'b111; #10;
  if (data_t !== 8'bxxxxxxxx) begin
    $display("@@@FAIL: q=111 expected x");
    $finish;
  end

  $display("@@@PASS");
  $finish;
end: testbench

initial begin: monitor
  $monitor("%t q:%b data_t:%b", $realtime, q, data_t);
end: monitor

endmodule: decoder_tb
