
//========================================================================
// EqComparator_32b_RTL-test
//========================================================================

`include "ece2300-test.v"
`include "EqComparator_32b_RTL.v"

module Top();

  //----------------------------------------------------------------------
  // Setup
  //----------------------------------------------------------------------

  // verilator lint_off UNUSED
  logic clk;
  logic reset;
  // verilator lint_on UNUSED

  ece2300_TestUtils t( .* );

  //----------------------------------------------------------------------
  // Instantiate design under test
  //----------------------------------------------------------------------

  logic [31:0] dut_in0;
  logic [31:0] dut_in1;
  logic        dut_eq;

  EqComparator_32b_RTL dut
  (
    .in0 (dut_in0),
    .in1 (dut_in1),
    .eq  (dut_eq)
  );

  //----------------------------------------------------------------------
  // check
  //----------------------------------------------------------------------
  // All tasks start at #1 after the rising edge of the clock. So we
  // write the inputs #1 after the rising edge, and check the outputs #1
  // before the next rising edge.

  task check
  (
    input logic [31:0] in0,
    input logic [31:0] in1,
    input logic        eq
  );
    if ( !t.failed ) begin

      dut_in0 = in0;
      dut_in1 = in1;

      #8;

      if ( t.n != 0 ) begin
        $display( "%3d: %h == %h (%10d == %10d) > %b", t.cycles,
                  dut_in0, dut_in1, dut_in0, dut_in1,
                  dut_eq );
      end

      `ECE2300_CHECK_EQ( dut_eq, eq );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );

    //     in0    in1    eq
    check( 32'd0, 32'd0, 1 );
    check( 32'd0, 32'd1, 0 );
    check( 32'd1, 32'd0, 0 );
    check( 32'd1, 32'd1, 1 );

  endtask

  task test_case_2_directed();
    t.test_case_begin( "test_case_1_directed" );

      //     in0        in1      eq
    check( 32'd0,    32'd2,    0 );
    check( 32'd2,    32'd2,    1 );
    check( 32'd3,    32'd2,    0 );
    check( 32'd15,   32'd15,   1 );
    check( 32'd15,   32'd14,   0 );
    check( 32'd100,  32'd100,  1 );
    check( 32'd100,  32'd99,   0 );
    check( 32'd255,  32'd255,  1 );
    check( 32'd256,  32'd255,  0 );
    check( 32'd1023, 32'd1023, 1 );
    check( 32'd1024, 32'd1023, 0 );

  endtask

  logic [31:0] random_in0;
  logic [31:0] random_in1;
  task test_case_3_random();
    t.test_case_begin( "test_case_1_random" );

    
    for (int i = 0; i < 10; i = i+1) begin 
      random_in0 = 32'($urandom(t.seed));
      random_in1 = 32'($urandom(t.seed));
      check(random_in0, random_in1, random_in0==random_in1);
    end   

  endtask
  

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin( `__FILE__ );

    if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();
    if ((t.n <= 1) || (t.n == 1)) test_case_2_directed();
    if ((t.n <= 2) || (t.n == 1)) test_case_3_random();

    t.test_bench_end();
  end

endmodule


