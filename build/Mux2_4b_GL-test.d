#=========================================================================
# Makefile dependency fragment
#=========================================================================

Mux2_4b_GL-test: \
  Mux2_4b_GL-test.v \
  ece2300-test.v \
  Mux2_4b_GL.v \
  Mux2_1b_GL.v \

Mux2_4b_GL-test.d: \
  Mux2_4b_GL-test.v \
  ece2300-test.v \
  Mux2_4b_GL.v \
  Mux2_1b_GL.v \

ece2300-test.v:

Mux2_4b_GL.v:

Mux2_1b_GL.v:
