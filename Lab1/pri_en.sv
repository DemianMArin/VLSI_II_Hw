module pri_en(
	input logic [3:0] I,
	output logic [1:0] Y
);


  always_comb begin: selector
    casez(I)
      4'b1???: Y = 2'b11; // I[3] highest priority
      4'b01??: Y = 2'b10; // I[2] highest priority
      4'b001?: Y = 2'b01; // I[1] highest priority
      default: Y = 2'b00; // no active input
    endcase
  end: selector

endmodule: pri_en
