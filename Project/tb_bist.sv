module tb_bist();

logic        clk, rst, start, csin, rwbarin, opr;
logic [5:0]  address;
logic [7:0]  datain;
logic [7:0]  dataout;
logic        fail;

bist #(.size(6), .length(8)) DUT(.*);

initial clk = 0;
always #5 clk = ~clk;

// initial begin: fsdb_dump
//   $fsdbDumpfile("dump.fsdb");
//   $fsdbDumpvars;
// end: fsdb_dump

initial begin: testbench

    rst = 1; start = 0; csin = 0; rwbarin = 1;
    opr = 1; address = 0; datain = 0;

    repeat(2) @(posedge clk); #1;
    rst = 0;

    // --- Test 1: Normal mode write/read ---
    csin = 1; rwbarin = 0; address = 6'd7; datain = 8'hBE;
    @(posedge clk); #1;
    rwbarin = 1;
    @(posedge clk); #1;
    if (dataout !== 8'hBE) begin
        $display("@@@FAIL: normal mode read, expected 0xBE, got 0x%h", dataout);
        $finish;
    end
    csin = 0;

    // --- Test 2: BIST run (128 cycles = 64 writes + 64 reads for pattern 0) ---
    start = 1;
    @(posedge clk); #1;  // controller enters TEST, NbarT goes high
    start = 0;

    repeat(128) begin
        @(posedge clk); #1;
        if (fail) begin
            $display("@@@FAIL: fail asserted during BIST (q=%0b)", DUT.q);
            $finish;
        end
    end

    // --- Test 3: rst mid-BIST forces NbarT low ---
    rst = 1;
    @(posedge clk); #1;
    if (DUT.NbarT !== 0) begin
        $display("@@@FAIL: rst should have dropped NbarT, got %b", DUT.NbarT);
        $finish;
    end
    rst = 0;

    $display("@@@PASS");
    $finish;
end: testbench

initial begin: monitor
    $monitor("%t rst:%b start:%b NbarT:%b opr:%b fail:%b | dataout:%h",
             $realtime, rst, start, DUT.NbarT, opr, fail, dataout);
end: monitor

endmodule: tb_bist
