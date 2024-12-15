//========================================================================
// Adder_32b_GL
//========================================================================

`ifndef ADDER_32B_GL
`define ADDER_32B_GL

`include "AdderCarrySelect_8b_GL.v"

module Adder_32b_GL
(
  (* keep=1 *) input  wire [31:0] in0,
  (* keep=1 *) input  wire [31:0] in1,
  (* keep=1 *) output wire [31:0] sum
);
  // Intermediate carry signals between each 8-bit adder stage
  wire carry_out0, carry_out1, carry_out2;

  // First 8-bit carry select adder (least significant 8 bits)
  AdderCarrySelect_8b_GL adder0 (
    .in0(in0[7:0]),
    .in1(in1[7:0]),
    .cin(1'b0),            // No carry-in for the first adder
    .sum(sum[7:0]),
    .cout(carry_out0)      // Carry-out to the next stage
  );

  // Second 8-bit carry select adder
  AdderCarrySelect_8b_GL adder1 (
    .in0(in0[15:8]),
    .in1(in1[15:8]),
    .cin(carry_out0),      // Carry-in from the previous stage
    .sum(sum[15:8]),
    .cout(carry_out1)
  );

  // Third 8-bit carry select adder
  AdderCarrySelect_8b_GL adder2 (
    .in0(in0[23:16]),
    .in1(in1[23:16]),
    .cin(carry_out1),      // Carry-in from the previous stage
    .sum(sum[23:16]),
    .cout(carry_out2)
  );

  wire cout_unused;
  // Fourth 8-bit carry select adder (most significant 8 bits)
  AdderCarrySelect_8b_GL adder3 (
    .in0(in0[31:24]),
    .in1(in1[31:24]),
    .cin(carry_out2),      // Carry-in from the previous stage
    .sum(sum[31:24]),
    .cout(cout_unused)                // Final carry-out (unused here)
  );

endmodule

`endif /* ADDER_32B_GL */

