#=========================================================================
# Makefile dependency fragment
#=========================================================================

Display_GL-test: \
  Display_GL-test.v \
  ece2300-test.v \
  Display_GL.v \
  BinaryToBinCodedDec_GL.v \
  BinaryToSevenSeg_GL.v \

Display_GL-test.d: \
  Display_GL-test.v \
  ece2300-test.v \
  Display_GL.v \
  BinaryToBinCodedDec_GL.v \
  BinaryToSevenSeg_GL.v \

ece2300-test.v:

Display_GL.v:

BinaryToBinCodedDec_GL.v:

BinaryToSevenSeg_GL.v:

