//========================================================================
// AdderCarrySelect_8b_GL
//========================================================================

`ifndef ADDER_CARRY_SELECT_8B_GL
`define ADDER_CARRY_SELECT_8B_GL

`include "AdderRippleCarry_4b_GL.v"
`include "Mux2_4b_GL.v"

module AdderCarrySelect_8b_GL
(
  (* keep=1 *) input  wire [7:0] in0,
  (* keep=1 *) input  wire [7:0] in1,
  (* keep=1 *) input  wire       cin,
  (* keep=1 *) output wire       cout,
  (* keep=1 *) output wire [7:0] sum
);
  wire cout_lower, cout_upper0, cout_upper1;
  wire [3:0] sum_upper0;
  wire [3:0] sum_upper1;

  AdderRippleCarry_4b_GL lower(
    .in0(in0[3:0]),
    .in1(in1[3:0]),
    .cin(cin),
    .cout(cout_lower),
    .sum(sum[3:0])
  );

  AdderRippleCarry_4b_GL upper_zero(
    .in0(in0[7:4]),
    .in1(in1[7:4]),
    .cin(1'b0),
    .cout(cout_upper0),
    .sum(sum_upper0)
  );

  AdderRippleCarry_4b_GL upper_one(
    .in0(in0[7:4]),
    .in1(in1[7:4]),
    .cin(1'b1),
    .cout(cout_upper1),
    .sum(sum_upper1)
  );

  Mux2_4b_GL upper_selector(
    .in0(sum_upper0),
    .in1(sum_upper1),
    .sel(cout_lower),
    .out(sum[7:4])
  );

  Mux2_1b_GL carry(
    .in0(cout_upper0),
    .in1(cout_upper1),
    .sel(cout_lower),
    .out(cout)
  );

endmodule

`endif /* ADDER_CARRY_SELECT_8B_GL */

