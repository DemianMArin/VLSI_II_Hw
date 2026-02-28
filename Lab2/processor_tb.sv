module processor_tb();

logic        clk;
logic        rstN;
logic [31:0] data_in;
logic [31:0] i_data;
logic        data_select;
logic [15:0] status_flags;
logic [31:0] data_out;
logic [ 7:0] status;
logic [ 2:0] Q;

processor DUT(.*);

initial clk = 0;
always #5 clk = ~clk;

initial begin: fsdb_dump
  $fsdbDumpfile("dump.fsdb");
  $fsdbDumpvars;
end: fsdb_dump

initial begin: testbench

  // Initialize all inputs, assert reset
  rstN = 1'b0; data_in = 32'h0; i_data = 32'h0;
  data_select = 1'b0; status_flags = 16'hFFFF;

  // ----------- Reset on status_reg
  rstN = 1'b0; status_flags = 16'hFFFF;
  @(posedge clk); #1;
  if (status !== 8'h60) begin
    $display("@@@FAIL");
    $finish;
  end

  rstN = 1'b1;

  // ----------- Mux 
  data_in = 32'hAAAAAAAA; i_data = 32'h55555555; data_select = 1'b1;
  #1;
  if (data_out !== 32'hAAAAAAAA) begin
    $display("@@@FAIL");
    $finish;
  end

  data_select = 1'b0;
  #1;
  if (data_out !== 32'h55555555) begin
    $display("@@@FAIL");
    $finish;
  end

  // ----------- Pri_en
  status_flags = 16'h0000;
  #1;
  if (Q !== 3'd0) begin
    $display("@@@FAIL");
    $finish;
  end

  status_flags = 16'h8000;
  #1;
  if (Q !== 3'd7) begin
    $display("@@@FAIL");
    $finish;
  end
 
  // Value of status should be 60 since a posedge hasn't arrived even if
  // status_flags has 0xFF at [0:7]

  status_flags = 16'hFFFF;
  #1;
  if (Q !== 3'd7 || status != 8'h60) begin
    $display("@@@FAIL");
    $finish;
  end

  // Pos edge has arrived. Q should not change. But status should be updated.
  @(posedge clk)#1 
  if (Q !== 3'd7 || status != 8'hFF) begin
    $display("@@@FAIL");
    $finish;
  end


  status_flags = 16'h0F00;
  #1;
  if (Q !== 3'd3) begin
    $display("@@@FAIL");
    $finish;
  end

  status_flags = 16'h0100;
  #1;
  if (Q !== 3'd0) begin
    $display("@@@FAIL");
    $finish;
  end

  status_flags = 16'h0000;
  #1;
  if (Q !== 3'd0) begin
    $display("@@@FAIL");
    $finish;
  end

  // ----------- Status Register 
  status_flags = 16'h0000;
  @(posedge clk); #1;
  if (status !== 8'h60) begin
    $display("@@@FAIL");
    $finish;
  end

  status_flags = 16'h0080;
  @(posedge clk); #1;
  if (status !== 8'hE0) begin
    $display("@@@FAIL");
    $finish;
  end

  status_flags = 16'h0008;
  @(posedge clk); #1;
  if (status !== 8'h68) begin
    $display("@@@FAIL");
    $finish;
  end

  status_flags = 16'h00FF;
  @(posedge clk); #1;
  if (status !== 8'hFF) begin
    $display("@@@FAIL");
    $finish;
  end

  $display("@@@PASS");
  $finish;
end: testbench

initial begin: monitor
  $monitor("%t CLK:%b RSTN:%b DATA_IN:%h I_DATA:%h SEL:%b FLAGS:%h | DATA_OUT:%h STATUS:%h Q:%b",
           $realtime, clk, rstN, data_in, i_data, data_select, status_flags, data_out, status, Q);
end: monitor

endmodule: processor_tb
