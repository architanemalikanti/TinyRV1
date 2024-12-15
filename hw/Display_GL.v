//========================================================================
// Display_GL
//========================================================================

`ifndef DISPLAY_GL_V
`define DISPLAY_GL_V

`include "BinaryToBinCodedDec_GL.v"
`include "BinaryToSevenSeg_GL.v"

module Display_GL
(
  (* keep=1 *) input  wire [4:0] in,
  (* keep=1 *) output wire [6:0] seg_tens,
  (* keep=1 *) output wire [6:0] seg_ones
);

  wire  [3:0] out_tens;
  wire [3:0] out_ones;

  BinaryToBinCodedDec_GL bdc
    (
      .in (in),
      .tens (out_tens),
      .ones (out_ones)
    );

  BinaryToSevenSeg_GL ones
    (
      .in (out_ones),
      .seg (seg_ones)
    );

  BinaryToSevenSeg_GL tens
    (
      .in (out_tens),
      .seg (seg_tens)
    );


endmodule

`endif /* DISPLAY_GL_V */

