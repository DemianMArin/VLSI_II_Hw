module traffic_light_controller_tb;

  logic clk, reset;
  logic [1:0] light_NS, light_EW;

  traffic_light_controller dut (.*);

  initial clk = 0;
  always #5 clk = ~clk;

  localparam RED    = 2'b00;
  localparam YELLOW = 2'b01;
  localparam GREEN  = 2'b10;

  // initial begin: fsdb_dump
  //   $fsdbDumpfile("dump.fsdb");
  //   $fsdbDumpvars;
  // end: fsdb_dump

  initial begin: testbench

    // TEST 1: Async reset → both lights Red immediately (no clock needed)
    reset = 1;
    #1;
    if (light_NS !== RED || light_EW !== RED) begin
      $display("@@@FAIL"); $finish;
    end

    // Deassert reset before first posedge (posedge is at t=5)
    reset = 0;

    // At posedge: S0 → S1 (NS=Green, EW=Red)
    @(posedge clk); #1;
    if (light_NS !== GREEN || light_EW !== RED) begin
      $display("@@@FAIL"); $finish;
    end

    // TEST 2: S1 (NS=Green, EW=Red) → S2 (NS=Yellow, EW=Red)
    // Check mid-cycle: lights must not change before posedge
    @(negedge clk); #2;
    if (light_NS !== GREEN || light_EW !== RED) begin
      $display("@@@FAIL"); $finish;
    end
    @(posedge clk); #1;
    if (light_NS !== YELLOW || light_EW !== RED) begin
      $display("@@@FAIL"); $finish;
    end

    // TEST 3: S2 (NS=Yellow, EW=Red) → S3 (NS=Red, EW=Green)
    @(negedge clk); #2;
    if (light_NS !== YELLOW || light_EW !== RED) begin
      $display("@@@FAIL"); $finish;
    end
    @(posedge clk); #1;
    if (light_NS !== RED || light_EW !== GREEN) begin
      $display("@@@FAIL"); $finish;
    end

    // TEST 4: S3 (NS=Red, EW=Green) → S4 (NS=Red, EW=Yellow)
    @(negedge clk); #2;
    if (light_NS !== RED || light_EW !== GREEN) begin
      $display("@@@FAIL"); $finish;
    end
    @(posedge clk); #1;
    if (light_NS !== RED || light_EW !== YELLOW) begin
      $display("@@@FAIL"); $finish;
    end

    // TEST 5: S4 (NS=Red, EW=Yellow) → S1 (NS=Green, EW=Red)
    @(negedge clk); #2;
    if (light_NS !== RED || light_EW !== YELLOW) begin
      $display("@@@FAIL"); $finish;
    end
    @(posedge clk); #1;
    if (light_NS !== GREEN || light_EW !== RED) begin
      $display("@@@FAIL"); $finish;
    end

    // TEST 6: Async reset mid-cycle from S1
    // Assert reset during low phase, check immediate Red, then release
    @(negedge clk); #2;
    reset = 1;
    #1;
    if (light_NS !== RED || light_EW !== RED) begin
      $display("@@@FAIL"); $finish;
    end
    reset = 0;

    // After reset released: next posedge must go to S1 (NS=Green, EW=Red)
    @(posedge clk); #1;
    if (light_NS !== GREEN || light_EW !== RED) begin
      $display("@@@FAIL"); $finish;
    end

    $display("@@@PASS");
    $finish;

  end: testbench

  initial begin: monitor
    $monitor("%t reset:%b clk:%b NS:%b EW:%b",
             $realtime, reset, clk, light_NS, light_EW);
  end: monitor

endmodule: traffic_light_controller_tb
