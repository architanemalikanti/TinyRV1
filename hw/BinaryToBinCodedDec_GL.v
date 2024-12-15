//========================================================================
// BinaryToBinCodedDec_GL
//========================================================================

`ifndef BINARY_TO_BIN_CODED_DEC_GL_V
`define BINARY_TO_BIN_CODED_DEC_GL_V

module BinaryToBinCodedDec_GL
(
  (* keep=1 *) input  wire [4:0] in,
  (* keep=1 *) output wire [3:0] tens,
  (* keep=1 *) output wire [3:0] ones
);

assign tens[0] = ~in[4] & in[3] & ~in[2] & in[1] & ~in[0]| //10
~in[4] & in[3] & ~in[2] & in[1] & in[0]| //11
~in[4] & in[3] & in[2] & ~in[1] & ~in[0]| //12
~in[4] & in[3] & in[2] & ~in[1] & in[0]| //13
~in[4] & in[3] & in[2] & in[1] & ~in[0]| //14
~in[4] & in[3] & in[2] & in[1] & in[0]| //15
in[4] & ~in[3] & ~in[2] & ~in[1] & ~in[0]| //16
in[4] & ~in[3] & ~in[2] & ~in[1] & in[0]| //17
in[4] & ~in[3] & ~in[2] & in[1] & ~in[0]| //18
in[4] & ~in[3] & ~in[2] & in[1] & in[0]| //19
in[4] & in[3] & in[2] & in[1] & ~in[0]| //30
in[4] & in[3] & in[2] & in[1] & in[0]; //31

assign tens[1] = in[4] & ~in[3] & in[2] & ~in[1] & ~in[0]| //20
in[4] & ~in[3] & in[2] & ~in[1] & in[0]| //21
in[4] & ~in[3] & in[2] & in[1] & ~in[0]| //22
in[4] & ~in[3] & in[2] & in[1] & in[0]| //23
in[4] & in[3] & ~in[2] & ~in[1] & ~in[0]| //24
in[4] & in[3] & ~in[2] & ~in[1] & in[0]| //25
in[4] & in[3] & ~in[2] & in[1] & ~in[0]| //26
in[4] & in[3] & ~in[2] & in[1] & in[0]| //27
in[4] & in[3] & in[2] & ~in[1] & ~in[0]| //28
in[4] & in[3] & in[2] & ~in[1] & in[0]| //29
in[4] & in[3] & in[2] & in[1] & ~in[0]| //30
in[4] & in[3] & in[2] & in[1] & in[0]; //31

assign tens[2] = 0;
assign tens[3] = 0;

assign ones[0] = ~in[4] & ~in[3] & ~in[2] & ~in[1] & in[0]| //1
~in[4] & ~in[3] & ~in[2] & in[1] & in[0]| //3
~in[4] & ~in[3] & in[2] & ~in[1] & in[0]| //5
~in[4] & ~in[3] & in[2] & in[1] & in[0]| //7
~in[4] & in[3] & ~in[2] & ~in[1] & in[0]| //9
~in[4] & in[3] & ~in[2] & in[1] & in[0]| //11
~in[4] & in[3] & in[2] & ~in[1] & in[0]| //13
~in[4] & in[3] & in[2] & in[1] & in[0]| //15
in[4] & ~in[3] & ~in[2] & ~in[1] & in[0]| //17
in[4] & ~in[3] & ~in[2] & in[1] & in[0]| //19
in[4] & ~in[3] & in[2] & ~in[1] & in[0]| //21
in[4] & ~in[3] & in[2] & in[1] & in[0]| //23
in[4] & in[3] & ~in[2] & ~in[1] & in[0]| //25
in[4] & in[3] & ~in[2] & in[1] & in[0]| //27
in[4] & in[3] & in[2] & ~in[1] & in[0]| //29
in[4] & in[3] & in[2] & in[1] & in[0]; //31

assign ones[1] = ~in[4] & ~in[3] & ~in[2] & in[1] & ~in[0]| //2
~in[4] & ~in[3] & ~in[2] & in[1] & in[0]| //3
~in[4] & ~in[3] & in[2] & in[1] & ~in[0]| //6
~in[4] & ~in[3] & in[2] & in[1] & in[0]| //7
~in[4] & in[3] & in[2] & ~in[1] & ~in[0]| //12
~in[4] & in[3] & in[2] & ~in[1] & in[0]| //13
in[4] & ~in[3] & ~in[2] & ~in[1] & ~in[0]| //16
in[4] & ~in[3] & ~in[2] & ~in[1] & in[0]| //17
in[4] & ~in[3] & in[2] & in[1] & ~in[0]| //22
in[4] & ~in[3] & in[2] & in[1] & in[0]| //23
in[4] & in[3] & ~in[2] & in[1] & ~in[0]| //26
in[4] & in[3] & ~in[2] & in[1] & in[0]; //27

assign ones[2] = ~in[4] & ~in[3] & in[2] & ~in[1] & ~in[0]| //4
~in[4] & ~in[3] & in[2] & ~in[1] & in[0]| //5
~in[4] & ~in[3] & in[2] & in[1] & ~in[0]| //6
~in[4] & ~in[3] & in[2] & in[1] & in[0]| //7
~in[4] & in[3] & in[2] & in[1] & ~in[0]| //14
~in[4] & in[3] & in[2] & in[1] & in[0]| //15
in[4] & ~in[3] & ~in[2] & ~in[1] & ~in[0]| //16
in[4] & ~in[3] & ~in[2] & ~in[1] & in[0]| //17
in[4] & in[3] & ~in[2] & ~in[1] & ~in[0]| //24
in[4] & in[3] & ~in[2] & ~in[1] & in[0]| //25
in[4] & in[3] & ~in[2] & in[1] & ~in[0]| //26
in[4] & in[3] & ~in[2] & in[1] & in[0]; //27

assign ones[3] = ~in[4] & in[3] & ~in[2] & ~in[1] & ~in[0]| //8
~in[4] & in[3] & ~in[2] & ~in[1] & in[0]| //9
in[4] & ~in[3] & ~in[2] & in[1] & ~in[0]| //18
in[4] & ~in[3] & ~in[2] & in[1] & in[0]| //19
in[4] & in[3] & in[2] & ~in[1] & ~in[0]| //28
in[4] & in[3] & in[2] & ~in[1] & in[0]; //29

endmodule

`endif /* BINARY_TO_BIN_CODED_DEC_GL_V */

