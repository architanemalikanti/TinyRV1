//========================================================================
// Mux4_RTL
//========================================================================

`ifndef MUX4_RTL
`define MUX4_RTL

module Mux4_RTL
#(
  parameter p_nbits = 1
)(
  (* keep=1 *) input  logic [p_nbits-1:0] in0,
  (* keep=1 *) input  logic [p_nbits-1:0] in1,
  (* keep=1 *) input  logic [p_nbits-1:0] in2,
  (* keep=1 *) input  logic [p_nbits-1:0] in3,
  (* keep=1 *) input  logic         [1:0] sel,
  (* keep=1 *) output logic [p_nbits-1:0] out
);

  always_comb begin 
    case(sel)
      2'b00 : out = in0; //when sel is 00, output takes on the value of in0.
      2'b01 : out = in1; //when sel is 01, output takes on the value of in1.
      2'b10 : out = in2; //when sel is 10, output takes on the value of in2.
      2'b11 : out = in3; //when sel is 11, output takes on the value of in3.
      default: out = {p_nbits{1'b0}}; // Default case to avoid latches
    endcase
  end

  




endmodule

`endif /* MUX4_RTL */

