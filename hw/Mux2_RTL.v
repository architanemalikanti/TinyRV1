//========================================================================
// Mux2_RTL
//========================================================================

`ifndef MUX2_RTL
`define MUX2_RTL

module Mux2_RTL
#(
  parameter p_nbits = 1
)(
  (* keep=1 *) input  logic [p_nbits-1:0] in0,
  (* keep=1 *) input  logic [p_nbits-1:0] in1,
  (* keep=1 *) input  logic               sel,
  (* keep=1 *) output logic [p_nbits-1:0] out
);

  //always block to assign out based on sel. 

  always_comb begin 
    if (sel) begin 
      out = in1; //when sel == 1, output takes the value of in1. 
    end else begin 
      out = in0;  //when sel == 0, output takes the value of in0. 

    end 
  end



endmodule

`endif /* MUX2_RTL */

