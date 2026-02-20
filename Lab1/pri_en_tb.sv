module pri_en_tb();

logic [3:0] I;
logic [1:0] Y;

pri_en DUT(.*);

initial begin: fsdb_dump
  $fsdbDumpfile("dump.fsdb");
  $fsdbDumpvars;
end: fsdb_dump

initial begin: testbench
  I = 4'b0000;
  #10;
  if (Y !== 2'b00) begin     
    $display("@@@FAIL");
    $finish;
  end

  I = 4'b0001;
  #10;
  I = 4'b0000;
  #10;
  I = 4'b0010;
  #10;
  I = 4'b0011;
  #10;
  I = 4'b0100;
  #10;
  I = 4'b0101;
  #10;
  I = 4'b0110;
  #10;
  if (Y !== 2'b10) begin     
    $display("@@@FAIL");
    $finish;
  end

  I = 4'b0111;
  #10;
  I = 4'b1000;
  #10;
  I = 4'b1001;
  #10;
  I = 4'b1010;
  #10;
  I = 4'b1011;
  #10;
  I = 4'b1100;
  #10;
  I = 4'b1101;
  #10;
  I = 4'b1110;
  #10;
  I = 4'b1111;
  #10;
  if (Y !== 2'b11) begin     
    $display("@@@FAIL");
    $finish;
  end

  I = 4'b0000;
  #10;
  if (Y !== 2'b00) begin     
    $display("@@@FAIL");
    $finish;
  end

  $display("@@@PASS");
  $finish;
end: testbench

initial begin: monitor
  $monitor("%t I:%b Y:%b", $realtime, I, Y);
end: monitor

endmodule: pri_en_tb
