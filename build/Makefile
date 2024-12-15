#=========================================================================
# Makefile for ECE 2300
#=========================================================================
# Author : Christopher Batten (Cornell)
# Date   : September 7, 2024

hws = \
  BinaryToBinCodedDec_GL.v \
  BinaryToSevenSeg_GL.v \
  Display_GL.v \
  FullAdder_GL.v \
  AdderRippleCarry_4b_GL.v \
  Mux2_1b_GL.v \
  Mux2_4b_GL.v \
  AdderCarrySelect_8b_GL.v \
  Mux2_RTL.v \
  Mux4_RTL.v \
  Mux8_RTL.v \
  Register_RTL.v \
  Adder_32b_GL.v \
  EqComparator_32b_RTL.v \
  ALU_32b.v \
  Multiplier_32x32b_RTL.v \
  ImmGen_RTL.v \
  RegfileZ1r1w_32x32b_RTL.v \
  RegfileZ2r1w_32x32b_RTL.v \
  tinyrv1.v \
	ProcScycleDpath.v \
	ProcScycleCtrl.v \
	ProcScycle.v \
	AccumXcel.v \

tests_partA = \
  BinaryToBinCodedDec_GL-test.v \
  BinaryToSevenSeg_GL-test.v \
  Display_GL-test.v \
  FullAdder_GL-test.v \
  AdderRippleCarry_4b_GL-test.v \
  Mux2_1b_GL-test.v \
  Mux2_4b_GL-test.v \
  AdderCarrySelect_8b_GL-test.v \
  Mux2_RTL-test.v \
  Mux4_RTL-test.v \
  Mux8_RTL-test.v \
  Register_RTL-test.v \
  Adder_32b_GL-test.v \
  EqComparator_32b_RTL-test.v \
  ALU_32b-test.v \
  Multiplier_32x32b_RTL-test.v \
  ImmGen_RTL-test.v \
  RegfileZ1r1w_32x32b_RTL-test.v \
  RegfileZ2r1w_32x32b_RTL-test.v \

tests_partB = \
  tinyrv1-test.v \
	TestMemory-test.v \
  ProcFL-addi-test.v \
  ProcFL-add-test.v \
  ProcFL-mul-test.v \
  ProcFL-lw-test.v \
  ProcFL-sw-test.v \
  ProcFL-jal-test.v \
  ProcFL-jr-test.v \
  ProcFL-bne-test.v \
  ProcFL-csr-test.v \
  ProcScycle-addi-test.v \
  ProcScycle-add-test.v \
  ProcScycle-mul-test.v \
  ProcScycle-lw-test.v \
  ProcScycle-sw-test.v \
  ProcScycle-jal-test.v \
  ProcScycle-jr-test.v \
  ProcScycle-bne-test.v \
  ProcScycle-csr-test.v \

tests_partC = \
	AccumXcel-test.v \

tests = \
  $(tests_partA) \
  $(tests_partB) \
  $(tests_partC) \

sims = \
  proc-fl-sim.v \
  proc-scycle-sim.v \
  accum-xcel-sim.v \

#-------------------------------------------------------------------------
# Basic setup
#-------------------------------------------------------------------------

# Remove all default implicit rules since they can cause subtle bugs
# and they just make things run slower
.SUFFIXES:
% : %,v
% : RCS/%,v
% : RCS/%
% : s.%
% : SCCS/s.%

# Default is to build the prereqs of the all target (defined at bottom)
default : all
.PHONY : default

#-------------------------------------------------------------------------
# Directories
#-------------------------------------------------------------------------

top_dir     := ..
scripts_dir := $(top_dir)/scripts
hw_dir      := $(top_dir)/hw
test_dir    := $(top_dir)/test
sim_dir     := $(top_dir)/sim

VPATH := $(hw_dir) $(test_dir) $(sim_dir)

#-------------------------------------------------------------------------
# Programs
#-------------------------------------------------------------------------

VMKDEPS          := $(scripts_dir)/mk-verilog-deps
WARN2ERR         := $(scripts_dir)/warnings2errors

VERILATOR_FLAGS  := --quiet --timing -Wall -Wno-DECLFILENAME -Wno-UNOPTFLAT -Wno-VARHIDDEN
VERILATOR_LINT   := verilator --lint-only $(VERILATOR_FLAGS)

IVERILOG_FLAGS   := -Wall -Winfloop -Wno-timescale -g2012
IVERILOG_COMPILE := $(WARN2ERR) iverilog $(IVERILOG_FLAGS)

#-------------------------------------------------------------------------
# Tests
#-------------------------------------------------------------------------

test_deps       := $(patsubst %.v, %.d,   $(tests))
test_exes       := $(patsubst %.v, %,     $(tests))
test_logs_partA := $(patsubst %.v, %.log, $(tests_partA))
test_logs_partB := $(patsubst %.v, %.log, $(tests_partB))
test_logs_partC := $(patsubst %.v, %.log, $(tests_partC))
test_logs       := $(patsubst %.v, %.log, $(tests))

$(test_deps) : %.d : %.v
	$(VMKDEPS) -I $(hw_dir) -I $(test_dir) $* $<

$(test_exes) : % : %.v
	$(VERILATOR_LINT) -I$(hw_dir) -I$(test_dir) --top-module Top $<
	$(IVERILOG_COMPILE) -I $(hw_dir) -I $(test_dir) -s Top -o $@ $<

$(test_logs) : %.log : %
	./$< > $@

check-partA : $(test_logs_partA)
	@sed -e '/^$$/N;/\n.*finish/d' $(test_logs_partA) | tee test-summary-partA.txt
	@echo ""

check-partB : $(test_logs_partB)
	@sed -e '/^$$/N;/\n.*finish/d' $(test_logs_partB) | tee test-summary-partB.txt
	@echo ""

check-partC : $(test_logs_partC)
	@sed -e '/^$$/N;/\n.*finish/d' $(test_logs_partC) | tee test-summary-partC.txt
	@echo ""

check : $(test_logs)
	@sed -e '/^$$/N;/\n.*finish/d' $(test_logs) | tee test-summary.txt
	@echo ""

deps += $(test_deps)
exes += $(test_exes)
logs += $(test_logs)
junk += $(test_deps) $(test_exes) $(test_logs)
junk += test-summary-partA.txt test-summary-partB.txt test-summary-partC.txt test-summary.txt

#-------------------------------------------------------------------------
# Sims
#-------------------------------------------------------------------------

sim_deps := $(patsubst %.v, %.d, $(sims))
sim_exes := $(patsubst %.v, %,   $(sims))

$(sim_deps) : %.d : %.v
	$(VMKDEPS) -I $(hw_dir) -I $(sim_dir) $* $<

$(sim_exes) : % : %.v
	$(VERILATOR_LINT) -I$(hw_dir) -I$(test_dir) -I$(sim_dir) --top-module Top $<
	$(IVERILOG_COMPILE) -I $(hw_dir) -I $(test_dir) -I $(sim_dir) -s Top -o $@ $<

deps += $(sim_deps)
exes += $(sim_exes)
junk += $(sim_deps) $(sim_exes)

#-------------------------------------------------------------------------
# Autodependency files
#-------------------------------------------------------------------------

-include $(deps)

deps : $(deps)
.PHONY : deps

#-------------------------------------------------------------------------
# configure information
#-------------------------------------------------------------------------

configure_prereq = $(top_dir)/configure.ac

$(top_dir)/configure : $(configure_prereq)
	cd $(top_dir) && autoconf

config.status : $(top_dir)/configure
	./config.status --recheck

Makefile : $(top_dir)/Makefile.in config.status
	./config.status

dist_junk += config.status Makefile config.log

#-------------------------------------------------------------------------
# Default
#-------------------------------------------------------------------------

all : $(sim_exes)

.PHONY : all

#-------------------------------------------------------------------------
# Makefile debugging
#-------------------------------------------------------------------------
# This handy rule will display the contents of any make variable by
# using the target debug-<varname>. So for example, make debug-junk will
# display the contents of the junk variable.

debug-% :
	@echo $* = $($*)

#-------------------------------------------------------------------------
# Clean up junk
#-------------------------------------------------------------------------

clean :
	rm -rf *~ \#* *.vcd $(junk)

distclean :
	rm -rf *~ \#* *.vcd $(junk) $(dist_junk)

.PHONY : clean distclean

