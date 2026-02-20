module mux(
  input logic en,
  input logic sel,
  input logic [3:0] D0,
  input logic [3:0] D1,
  output logic [3:0] Y
);


  always_comb begin: selector
    if (en)
      if (sel)  Y = D1;
      else Y = D0;
    else begin
       Y = 0; 
      end
  end: selector

endmodule: mux
