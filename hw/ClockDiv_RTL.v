//========================================================================
// ClockDiv_RTL.v
//========================================================================
// A staff-provided clock divider that divides the clock frequency by a
// factor of 2^(p_factor)

`ifndef CLOCKDIV_RTL_V
`define CLOCKDIV_RTL_V

module ClockDiv_RTL
(
  input  logic clk_in,
  output logic clk_out
);

  parameter p_factor = 2;

  logic [p_factor-1:0] count;

  always @( posedge clk_in ) begin
    count <= count + 1;
  end

  assign clk_out = count[p_factor-1];

endmodule

`endif /* CLOCKDIV_RTL_V */
