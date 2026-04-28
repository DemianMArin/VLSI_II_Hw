module tb_multiplexer();

logic [7:0] normal_in;
logic [7:0] bist_in;
logic       NbarT;
logic [7:0] out;

multiplexer #(.WIDTH(8)) DUT(.*);

// initial begin: fsdb_dump
//   $fsdbDumpfile("dump.fsdb");
//   $fsdbDumpvars;
// end: fsdb_dump

initial begin: testbench

    // --- NbarT=0: output must follow normal_in ---
    NbarT = 0; normal_in = 8'h00; bist_in = 8'hFF;
    #10;
    if (out !== 8'h00) begin
        $display("@@@FAIL: NbarT=0, expected normal_in=0x00, got 0x%h", out);
        $finish;
    end

    NbarT = 0; normal_in = 8'hAB; bist_in = 8'h00;
    #10;
    if (out !== 8'hAB) begin
        $display("@@@FAIL: NbarT=0, expected normal_in=0xAB, got 0x%h", out);
        $finish;
    end

    // --- NbarT=1: output must follow bist_in ---
    NbarT = 1; normal_in = 8'hFF; bist_in = 8'h00;
    #10;
    if (out !== 8'h00) begin
        $display("@@@FAIL: NbarT=1, expected bist_in=0x00, got 0x%h", out);
        $finish;
    end

    NbarT = 1; normal_in = 8'h00; bist_in = 8'hCD;
    #10;
    if (out !== 8'hCD) begin
        $display("@@@FAIL: NbarT=1, expected bist_in=0xCD, got 0x%h", out);
        $finish;
    end

    // --- switching NbarT: output follows select immediately ---
    normal_in = 8'h12; bist_in = 8'h34;
    NbarT = 0; #10;
    if (out !== 8'h12) begin
        $display("@@@FAIL: switch NbarT=0, expected 0x12, got 0x%h", out);
        $finish;
    end
    NbarT = 1; #10;
    if (out !== 8'h34) begin
        $display("@@@FAIL: switch NbarT=1, expected 0x34, got 0x%h", out);
        $finish;
    end

    $display("@@@PASS");
    $finish;
end: testbench

initial begin: monitor
    $monitor("%t NbarT:%b normal_in:%h bist_in:%h | out:%h",
             $realtime, NbarT, normal_in, bist_in, out);
end: monitor

endmodule: tb_multiplexer
