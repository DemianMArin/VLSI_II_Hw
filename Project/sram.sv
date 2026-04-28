module sram (
    input  logic [5:0] ramaddr,
    input  logic [7:0] ramin,
    input  logic       rwbar,
    input  logic       clk,
    input  logic       cs,
    output logic [7:0] ramout
);

    logic [7:0] ram [0:63];
    logic [5:0] addr_reg;

    always_ff @(posedge clk) begin
        if (cs) begin
            addr_reg <= ramaddr;
            if (!rwbar)
                ram[ramaddr] <= ramin;
        end
    end

    assign ramout = (cs && rwbar) ? ram[addr_reg] : 8'h00;

endmodule
