module tb_sram();

logic [5:0] ramaddr;
logic [7:0] ramin;
logic       rwbar;
logic       clk;
logic       cs;
logic [7:0] ramout;

sram DUT(.*);

initial clk = 0;
always #5 clk = ~clk;

// initial begin: fsdb_dump
//   $fsdbDumpfile("dump.fsdb");
//   $fsdbDumpvars;
// end: fsdb_dump

initial begin: testbench

    cs = 0; rwbar = 1; ramaddr = 0; ramin = 0;

    // --- Basic write then read (addr 53 = 0xDE) ---
    cs = 1; rwbar = 0; ramaddr = 53; ramin = 8'hDE;
    @(posedge clk); #1;
    rwbar = 1;
    if (ramout !== 8'hDE) begin
        $display("@@@FAIL: read after write, expected 0xDE, got 0x%h", ramout);
        $finish;
    end

    // Persistence: data still readable next cycle
    @(posedge clk); #1;
    if (ramout !== 8'hDE) begin
        $display("@@@FAIL: persistence check, expected 0xDE, got 0x%h", ramout);
        $finish;
    end

    // --- cs=0 forces ramout to 0x00 ---
    cs = 0; #1;
    if (ramout !== 8'h00) begin
        $display("@@@FAIL: cs=0 should give 0x00, got 0x%h", ramout);
        $finish;
    end
    cs = 1;

    // --- rwbar=0 (write mode) forces ramout to 0x00 ---
    rwbar = 0; #1;
    if (ramout !== 8'h00) begin
        $display("@@@FAIL: rwbar=0 should give 0x00, got 0x%h", ramout);
        $finish;
    end
    rwbar = 1;

    // --- Two-address independence (adjacent addrs 10 and 11) ---
    // Write 0xAB to addr 10
    cs = 1; rwbar = 0; ramaddr = 10; ramin = 8'hAB;
    @(posedge clk); #1;
    // Write 0xCD to addr 11
    ramaddr = 11; ramin = 8'hCD;
    @(posedge clk); #1;
    // Switch to read addr 10 — addr_reg is still 11 this cycle, so ramout = ram[11]
    rwbar = 1; ramaddr = 10; #1;
    if (ramout !== 8'hCD) begin
        $display("@@@FAIL: same-cycle addr_reg still 11, expected 0xCD, got 0x%h", ramout);
        $finish;
    end
    // After one clock addr_reg updates to 10
    @(posedge clk); #1;
    if (ramout !== 8'hAB) begin
        $display("@@@FAIL: addr 10 expected 0xAB, got 0x%h", ramout);
        $finish;
    end
    // Read addr 11
    ramaddr = 11;
    @(posedge clk); #1;
    if (ramout !== 8'hCD) begin
        $display("@@@FAIL: addr 11 expected 0xCD, got 0x%h", ramout);
        $finish;
    end

    // --- cs=0 prevents write (addr 10 must remain 0xAB) ---
    cs = 0; rwbar = 0; ramaddr = 10; ramin = 8'hFF;
    @(posedge clk); #1;
    cs = 1; rwbar = 1; ramaddr = 10;
    @(posedge clk); #1;
    if (ramout !== 8'hAB) begin
        $display("@@@FAIL: cs=0 write should not modify memory, expected 0xAB, got 0x%h", ramout);
        $finish;
    end

    $display("@@@PASS");
    $finish;
end: testbench

initial begin: monitor
    $monitor("%t cs:%b rwbar:%b ramaddr:%0d ramin:%h | ramout:%h",
             $realtime, cs, rwbar, ramaddr, ramin, ramout);
end: monitor

endmodule: tb_sram
