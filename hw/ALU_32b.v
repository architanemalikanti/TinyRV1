//========================================================================
// ALU_32b
//========================================================================
// Simple ALU which supports both addition and equality comparision. For
// equality comparison the least-significant bit will be one if in0
// equals in1 and zero otherwise; the remaining 31 bits will always be
// zero.
//
//  - op == 0 : add
//  - op == 1 : equality comparison
//

`ifndef ALU_32B_V
`define ALU_32B_V

`include "Adder_32b_GL.v"
`include "EqComparator_32b_RTL.v"
`include "Mux2_RTL.v"

module ALU_32b
(
  (* keep=1 *) input  logic [31:0] in0,
  (* keep=1 *) input  logic [31:0] in1,
  (* keep=1 *) input  logic        op,
  (* keep=1 *) output logic [31:0] out
);
   // Intermediate signals
  logic [31:0] add_result;
  logic eq_result;

  // Instantiate the 32-bit adder
  Adder_32b_GL adder (
    .in0(in0),
    .in1(in1),
    .sum(add_result)
  );

  // Instantiate the 32-bit equality comparator
  EqComparator_32b_RTL eq_comp (
    .in0(in0),
    .in1(in1),
    .eq(eq_result)
  );

  //instatiate the 2 to 1 mux
  Mux2_RTL#(32) ALU_operator (
    .in0(add_result),
    .in1({31'b0, eq_result}),
    .sel(op),
    .out(out)
  );




endmodule

`endif /* ALU_32B_V */

