module bist #(
    parameter size   = 6,
    parameter length = 8
) (
    input  logic             clk,
    input  logic             rst,
    input  logic             start,
    input  logic             csin,
    input  logic             rwbarin,
    input  logic             opr,
    input  logic [size-1:0]  address,
    input  logic [length-1:0] datain,
    output logic [length-1:0] dataout,
    output logic              fail
);

    logic       cen;   // counter always enabled during BIST
    logic       u_d;   // always count up 
    logic [9:0] d_in;  // reload value: counter restarts from zero after each BIST run

    assign cen  = 1'b1;
    assign u_d  = 1'b1;
    assign d_in = 10'b0;

    // Internal signals
    logic [9:0] q;
    logic       cout;
    logic       NbarT;
    logic       ld;
    logic [7:0] data_t;
    logic [5:0] addr_mux;
    logic [7:0] data_mux;
    logic [7:0] ramout;
    logic       eq, gt, lt;

    logic rwbar_temp; // q[6] in BIST mode, rwbarin in normal mode
    logic cs_wire;    // 1 in BIST mode, csin in normal mode

    assign rwbar_temp = NbarT ? q[6] : rwbarin;
    assign cs_wire    = NbarT ? 1'b1 : csin;

    controller ctrl (
        .clk   (clk),
        .rst   (rst),
        .start (start),
        .cout  (cout),
        .NbarT (NbarT),
        .ld    (ld)
    );

    counter #(.length(10)) cnt (
        .clk  (clk),
        .cen  (cen),
        .ld   (ld),
        .u_d  (u_d),
        .d_in (d_in),
        .q    (q),
        .cout (cout)
    );

    decoder dec (
        .q      (q[9:7]),
        .data_t (data_t)
    );

    multiplexer #(.WIDTH(size)) mux_a (
        .normal_in (address),
        .bist_in   (q[5:0]),
        .NbarT     (NbarT),
        .out       (addr_mux)
    );

    multiplexer #(.WIDTH(length)) mux_d (
        .normal_in (datain),
        .bist_in   (data_t),
        .NbarT     (NbarT),
        .out       (data_mux)
    );

    sram mem (
        .clk     (clk),
        .cs      (cs_wire),
        .rwbar   (rwbar_temp),
        .ramaddr (addr_mux),
        .ramin   (data_mux),
        .ramout  (ramout)
    );

    comparator cmp (
        .data_t (data_t),
        .ramout (ramout),
        .gt     (gt),
        .eq     (eq),
        .lt     (lt)
    );

    // fail is registered each cycle: high only when a read mismatch is detected
    always_ff @(posedge clk) begin
        if (NbarT && rwbar_temp && ~eq && opr)
            fail <= 1'b1;
        else
            fail <= 1'b0;
    end

    assign dataout = ramout;

endmodule
