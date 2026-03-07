`include "fsm_pkg.svh"
import fsm10_pkg::*;

module fsm_tb;

  logic rst_n, clk, jmp, go;
  logic y;
  state_e state;

  fsm dut (.*);

  initial clk = 0;
  always #5 clk = ~clk;

  task tick;
    @(posedge clk); #1;
  endtask

// initial begin: fsdb_dump
//   $fsdbDumpfile("dump.fsdb");
//   $fsdbDumpvars;
// end: fsdb_dump

  initial begin: testbench

    // Initialize with reset asserted
    rst_n = 0; jmp = 0; go = 0;
    #1;

    // TEST 1: Async reset → S0 immediately (no clock needed)
    if (state !== S0 || y !== 1'b0) begin
      $display("@@@FAIL"); $finish;
    end

    // Release reset, verify S0 holds (go=0 → no transition)
    rst_n = 1;
    tick;
    if (state !== S0 || y !== 1'b0) begin $display("@@@FAIL"); $finish; end

    // Walk S0 → S1 → S2 → S3
    go = 1; jmp = 0; tick;
    if (state !== S1 || y !== 1'b0) begin $display("@@@FAIL"); $finish; end

    go = 0; tick;
    if (state !== S2 || y !== 1'b0) begin $display("@@@FAIL"); $finish; end

    tick;
    if (state !== S3 || y !== 1'b1) begin $display("@@@FAIL"); $finish; end

    // TEST 2: Async reset mid-cycle (2 units into low phase = "down2")
    // Without reset, next posedge would take S3 → S4. Reset must preempt it.
    @(negedge clk); #2;
    rst_n = 0;
    #1; // allow propagation
    if (state !== S0 || y !== 1'b0) begin // must be S0 NOW, before any posedge
      $display("@@@FAIL"); $finish;
    end
    #1; // verify still S0 without a posedge
    if (state !== S0 || y !== 1'b0) begin
      $display("@@@FAIL"); $finish;
    end

    // TEST 3: Sync property — input change mid-cycle must not affect state
    tick; rst_n = 1; // release reset just after posedge
    if (state !== S0) begin $display("@@@FAIL"); $finish; end

    @(negedge clk); #2;    // mid-cycle: change go
    go = 1; jmp = 0;
    if (state !== S0) begin // state must NOT update yet
      $display("@@@FAIL"); $finish;
    end
    @(posedge clk); #1;    // only NOW should the transition happen
    if (state !== S1 || y !== 1'b0) begin $display("@@@FAIL"); $finish; end

    // TEST 4: All remaining state transitions
    go = 0; jmp = 0; tick;             // S1 → S2
    if (state !== S2 || y !== 1'b0) begin $display("@@@FAIL"); $finish; end

    tick;                               // S2 → S3
    if (state !== S3 || y !== 1'b1) begin $display("@@@FAIL"); $finish; end

    jmp = 1; tick;                      // S3 jmp=1 → S3 (stays)
    if (state !== S3 || y !== 1'b1) begin $display("@@@FAIL"); $finish; end

    jmp = 0; tick;                      // S3 → S4
    if (state !== S4 || y !== 1'b0) begin $display("@@@FAIL"); $finish; end

    jmp = 1; tick;                      // S4 jmp=1 → S3
    if (state !== S3 || y !== 1'b1) begin $display("@@@FAIL"); $finish; end

    jmp = 0; tick; tick;                // S3 → S4 → S5
    if (state !== S5 || y !== 1'b0) begin $display("@@@FAIL"); $finish; end

    jmp = 1; tick;                      // S5 jmp=1 → S3
    if (state !== S3 || y !== 1'b1) begin $display("@@@FAIL"); $finish; end

    jmp = 0; repeat(3) tick;            // S3 → S4 → S5 → S6
    if (state !== S6 || y !== 1'b0) begin $display("@@@FAIL"); $finish; end

    jmp = 1; tick;                      // S6 jmp=1 → S3
    if (state !== S3 || y !== 1'b1) begin $display("@@@FAIL"); $finish; end

    jmp = 0; repeat(4) tick;            // S3 → ... → S7
    if (state !== S7 || y !== 1'b0) begin $display("@@@FAIL"); $finish; end

    jmp = 1; tick;                      // S7 jmp=1 → S3
    if (state !== S3 || y !== 1'b1) begin $display("@@@FAIL"); $finish; end

    jmp = 0; repeat(5) tick;            // S3 → ... → S8
    if (state !== S8 || y !== 1'b0) begin $display("@@@FAIL"); $finish; end

    jmp = 1; tick;                      // S8 jmp=1 → S3
    if (state !== S3 || y !== 1'b1) begin $display("@@@FAIL"); $finish; end

    jmp = 0; repeat(6) tick;            // S3 → ... → S9
    if (state !== S9 || y !== 1'b0) begin $display("@@@FAIL"); $finish; end

    jmp = 1; tick;                      // S9 jmp=1 → S3
    if (state !== S3 || y !== 1'b1) begin $display("@@@FAIL"); $finish; end

    jmp = 0; repeat(7) tick;            // S3 → ... → S9 → S0
    if (state !== S0 || y !== 1'b0) begin $display("@@@FAIL"); $finish; end

    // S0 go=1 jmp=1 → S3 directly
    go = 1; jmp = 1; tick;
    if (state !== S3 || y !== 1'b1) begin $display("@@@FAIL"); $finish; end

    go = 0; jmp = 0; repeat(7) tick;   // S3 → ... → S0
    if (state !== S0) begin $display("@@@FAIL"); $finish; end
    go = 1; jmp = 0; tick;             // S0 → S1
    if (state !== S1) begin $display("@@@FAIL"); $finish; end

    // S1 jmp=1 → S3 (skipping S2)
    go = 0; jmp = 1; tick;             // S1 jmp=1 → S3
    if (state !== S3 || y !== 1'b1) begin $display("@@@FAIL"); $finish; end

    $display("@@@PASS");
    $finish;

  end: testbench

  initial begin: monitor
    $monitor("%t rst_n:%b clk:%b go:%b jmp:%b state:%s y:%b",
             $realtime, rst_n, clk, go, jmp, state.name(), y);
  end: monitor

endmodule: fsm_tb
