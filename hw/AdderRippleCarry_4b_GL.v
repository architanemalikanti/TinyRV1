//========================================================================
// AdderRippleCarry_4b_GL
//========================================================================

`ifndef ADDER_RIPPLE_CARRY_4B_GL_V
`define ADDER_RIPPLE_CARRY_4B_GL_V

`include "FullAdder_GL.v"

module AdderRippleCarry_4b_GL
(
  (* keep=1 *) input  wire [3:0] in0,
  (* keep=1 *) input  wire [3:0] in1,
  (* keep=1 *) input  wire       cin,
  (* keep=1 *) output wire       cout,
  (* keep=1 *) output wire [3:0] sum
);
  wire [2:0] carries;

  FullAdder_GL one(
  .in0(in0[0]),
  .in1(in1[0]),
  .cin(cin),
  .cout(carries[0]),
  .sum(sum[0])
  );

  FullAdder_GL two(
  .in0(in0[1]),
  .in1(in1[1]),
  .cin(carries[0]),
  .cout(carries[1]),
  .sum(sum[1])
  );

  FullAdder_GL three(
  .in0(in0[2]),
  .in1(in1[2]),
  .cin(carries[1]),
  .cout(carries[2]),
  .sum(sum[2])
  );

  FullAdder_GL four(
  .in0(in0[3]),
  .in1(in1[3]),
  .cin(carries[2]),
  .cout(cout),
  .sum(sum[3])
  );




endmodule

`endif /* ADDER_RIPPLE_CARRY_4B_GL_V */

