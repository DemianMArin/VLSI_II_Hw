module traffic_light_controller (
  input  logic        clk,
  input  logic        reset,    // asynchronous active-high reset
  output logic [1:0]  light_NS, // 00=Red, 01=Yellow, 10=Green
  output logic [1:0]  light_EW  // 00=Red, 01=Yellow, 10=Green
);

  typedef enum logic [2:0] {S0, S1, S2, S3, S4} state_t;

  state_t state, next_state;

  // Block 1: Reset and State Update
  always_ff @(posedge clk or posedge reset) begin
    if (reset)
      state <= S0;
    else
      state <= next_state;
  end

  // Block 2: Next-State and Output Logic
  always_comb begin
    case (state)
      S0: begin next_state = S1; light_NS = 2'b00; light_EW = 2'b00; end
      S1: begin next_state = S2; light_NS = 2'b10; light_EW = 2'b00; end
      S2: begin next_state = S3; light_NS = 2'b01; light_EW = 2'b00; end
      S3: begin next_state = S4; light_NS = 2'b00; light_EW = 2'b10; end
      S4: begin next_state = S1; light_NS = 2'b00; light_EW = 2'b01; end
      default: begin next_state = S0; light_NS = 2'b00; light_EW = 2'b00; end
    endcase
  end

endmodule
