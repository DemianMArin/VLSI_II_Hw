`include "fsm_pkg.svh"
import fsm10_pkg::*;

module fsm(
  input  logic   rst_n,  // asynchronous active-low reset
  input  logic   clk,
  input  logic   jmp,
  input  logic   go,
  output logic   y,
  output state_e state
);

  state_e next_state;

  // Sequential: state register with async active-low reset
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      state <= S0;
    else
      state <= next_state;
  end

  // Combinational: next-state logic
  always_comb begin
    case (state)
      S0:      next_state = go ? (jmp ? S3 : S1) : S0;
      S1:      next_state = jmp ? S3 : S2;
      S2:      next_state = S3;
      S3:      next_state = jmp ? S3 : S4;
      S4:      next_state = jmp ? S3 : S5;
      S5:      next_state = jmp ? S3 : S6;
      S6:      next_state = jmp ? S3 : S7;
      S7:      next_state = jmp ? S3 : S8;
      S8:      next_state = jmp ? S3 : S9;
      S9:      next_state = jmp ? S3 : S0;
      default: next_state = S0;
    endcase
  end

  // Output logic (Moore: depends only on current state)
  assign y = (state == S3);

endmodule
