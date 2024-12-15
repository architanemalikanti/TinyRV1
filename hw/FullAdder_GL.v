//========================================================================
// FullAdder_GL
//========================================================================

`ifndef FULL_ADDER_GL_V
`define FULL_ADDER_GL_V

module FullAdder_GL
(
  (* keep=1 *) input  wire in0,
  (* keep=1 *) input  wire in1,
  (* keep=1 *) input  wire cin,
  (* keep=1 *) output wire cout,
  (* keep=1 *) output wire sum
);

  assign cout = (in0 & in1) | (in1 & cin) | (in0 & cin);
  assign sum = ~in0&~in1&cin | ~in0&in1&~cin | in0&~in1&~cin | in0&in1&cin;



endmodule

`endif /* FULL_ADDER_GL_V */

