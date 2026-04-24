module controller (
    input  logic clk,
    input  logic rst,
    input  logic start,
    input  logic cout,
    output logic NbarT,
    output logic ld
);

    typedef enum logic {RESET = 1'b0, TEST = 1'b1} state_t;
    state_t state;

    always_ff @(posedge clk) begin
        if (rst)
            state <= RESET;
        else begin
            case (state)
                RESET: state <= start ? TEST : RESET;
                TEST:  state <= cout  ? RESET : TEST;
            endcase
        end
    end

    assign NbarT = (state == TEST);
    assign ld    = (state == RESET);

endmodule
