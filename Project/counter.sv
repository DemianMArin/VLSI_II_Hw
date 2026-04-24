module counter #(parameter length = 10) (
    input  logic              clk,
    input  logic              cen,
    input  logic              ld,
    input  logic              u_d,
    input  logic [length-1:0] d_in,
    output logic [length-1:0] q,
    output logic              cout
);

    always_ff @(posedge clk) begin
        if (cen) begin
            if (ld)
                q <= d_in;
            else if (u_d)
                q <= q + 1;
            else
                q <= q - 1;
        end
    end

    assign cout = (u_d) ? (&q) : (~|q);

endmodule
