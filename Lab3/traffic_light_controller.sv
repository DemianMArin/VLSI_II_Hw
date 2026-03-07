module traffic_light_controller (
  input logic clk,
  input logic reset, // asynchronous active-high reset
  output logic [1:0] light_NS, // 00=Red, 01=Yellow, 10=Green
  output logic [1:0] light_EW // 00=Red, 01=Yellow, 10=Green
);

always_ff begin
// Block 1: Reset and State Update
end

always_comb begin
// Block 2: Next-State and Output Logic
end

endmodule
