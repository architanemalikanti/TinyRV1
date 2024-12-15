#=========================================================================
# Makefile dependency fragment
#=========================================================================

TestMemory-test: \
  TestMemory-test.v \
  ece2300-test.v \
  TestMemory.v \
  tinyrv1.v \

TestMemory-test.d: \
  TestMemory-test.v \
  ece2300-test.v \
  TestMemory.v \
  tinyrv1.v \

ece2300-test.v:

TestMemory.v:

tinyrv1.v:

