// ─── mux32 ───────────────────────────────────────────────────────────────────
module mux32(
  input logic [31:0] a,
  input logic [31:0] b,
  input logic sel,
  output logic [31:0] y
);

  assign y = sel ? a : b;

endmodule

// ─── status_reg ──────────────────────────────────────────────────────────────
module status_reg(
  input logic clk,
  input logic rstN, // active low reset
  input logic int_en,
  input logic zero,
  input logic carry,
  input logic neg,
  input logic [1:0] parity,
  output logic [7:0] status
);

  always_ff @(posedge clk) begin
    if (!rstN)
      status <= 8'h00;
    else
      status <= {int_en, 1'b1, 1'b1, zero, carry, neg, parity};
  end

endmodule

// ─── Pri_En ──────────────────────────────────────────────────────────────────
module Pri_En(
  input logic [7:0] D,
  output logic [2:0] Q
);

  always_comb begin
    casez (D)
      8'b1???????: Q = 3'd7;
      8'b01??????: Q = 3'd6;
      8'b001?????: Q = 3'd5;
      8'b0001????: Q = 3'd4;
      8'b00001???: Q = 3'd3;
      8'b000001??: Q = 3'd2;
      8'b0000001?: Q = 3'd1;
      8'b00000001: Q = 3'd0;
      default:     Q = 3'd0;
    endcase
  end

endmodule

// ─── processor ───────────────────────────────────────────────────────────────
module processor(
  input logic clk, // clock
  input logic rstN, // active low reset signal
  input logic [31:0] data_in,
  input logic [31:0] i_data,
  input logic data_select,
  input logic [15:0] status_flags,

  output logic [31:0] data_out,
  output logic [ 7:0] status,
  output logic [ 2:0] Q
);

  mux32 mux_inst (
    .a   (data_in),
    .b   (i_data),
    .sel (data_select),
    .y   (data_out)
  );

  status_reg status_inst (
    .clk    (clk),
    .rstN   (rstN),
    .int_en (status_flags[7]),
    .zero   (status_flags[4]),
    .carry  (status_flags[3]),
    .neg    (status_flags[2]),
    .parity (status_flags[1:0]),
    .status (status)
  );

  Pri_En pri_inst (
    .D (status_flags[15:8]),
    .Q (Q)
  );

endmodule
