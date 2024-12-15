//========================================================================
// Mux2_RTL-test
//========================================================================

`include "ece2300-test.v"
`include "Mux2_RTL.v"

//========================================================================
// Parameterized Test Suite
//========================================================================

module TestSuiteMux2
#(
  parameter p_test_suite,
  parameter p_nbits
)();

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

  logic [p_nbits-1:0] dut_in0;
  logic [p_nbits-1:0] dut_in1;
  logic               dut_sel;
  logic [p_nbits-1:0] dut_out;

  Mux2_RTL
  #(
    .p_nbits (p_nbits)
  )
  dut
  (
    .in0 (dut_in0),
    .in1 (dut_in1),
    .sel (dut_sel),
    .out (dut_out)
  );

  //----------------------------------------------------------------------
  // check
  //----------------------------------------------------------------------
  // All tasks start at #1 after the rising edge of the clock. So we
  // write the inputs #1 after the rising edge, and check the outputs #1
  // before the next rising edge.

  task check
  (
    input logic [p_nbits-1:0] in0,
    input logic [p_nbits-1:0] in1,
    input logic               sel,
    input logic [p_nbits-1:0] out
  );
    if ( !t.failed ) begin

      dut_in0 = in0;
      dut_in1 = in1;
      dut_sel = sel;

      #8;

      if ( t.n != 0 ) begin
        if ( p_nbits <= 8 )
          $display( "%3d: %b %b %b > %b", t.cycles,
                    dut_in0, dut_in1, dut_sel, dut_out );
        else
          $display( "%3d: %h %h %b > %h", t.cycles,
                    dut_in0, dut_in1, dut_sel, dut_out );
      end

      `ECE2300_CHECK_EQ( dut_out, out );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );

    //     in0 in1 sel out
    check( 0,  0,  0,  0 );
    check( 0,  0,  1,  0 );

  endtask

  //----------------------------------------------------------------------
  // test_case_2_directed_4bit
  //----------------------------------------------------------------------

  task test_case_2_directed_4bit();
    t.test_case_begin( "test_case_2_directed_4bit" );

    //     in0                in1                sel                out
    check( p_nbits'(4'b1111), p_nbits'(4'b0000), 0, p_nbits'(4'b1111) ); // sel = 0, choose in0
    check( p_nbits'(4'b1111), p_nbits'(4'b0000), 1, p_nbits'(4'b0000) ); // sel = 1, choose in1

    check( p_nbits'(4'b0101), p_nbits'(4'b1010), 0, p_nbits'(4'b0101) ); // mixed bits, sel = 0
    check( p_nbits'(4'b0101), p_nbits'(4'b1010), 1, p_nbits'(4'b1010) ); // mixed bits, sel = 1

    check( p_nbits'(4'b0001), p_nbits'(4'b0010), 0, p_nbits'(4'b0001) ); // different by one bit, sel = 0
    check( p_nbits'(4'b0001), p_nbits'(4'b0010), 1, p_nbits'(4'b0010) ); // different by one bit, sel = 1

    check( p_nbits'(4'b1001), p_nbits'(4'b0110), 0, p_nbits'(4'b1001) ); // random bits, sel = 0
    check( p_nbits'(4'b1001), p_nbits'(4'b0110), 1, p_nbits'(4'b0110) ); // random bits, sel = 1

  endtask


  logic [p_nbits-1:0] rand_in0;
  logic [p_nbits-1:0] rand_in1;
  logic              rand_sel;
  logic [p_nbits-1:0] rand_out;

  //----------------------------------------------------------------------
  // Random test cases
  //----------------------------------------------------------------------

  task test_case_3_random();
    t.test_case_begin( "test_case_4_random" );

    for ( int i = 0; i < 50; i = i+1 ) begin

      // Generate random values for inputs and sel

      rand_in0 = p_nbits'($urandom(t.seed));
      rand_in1 = p_nbits'($urandom(t.seed));
      rand_sel = 1'($urandom(t.seed));

      // Determine correct answer

      if ( rand_sel == 0 )
        rand_out = rand_in0;
      else if ( rand_sel == 1 )
        rand_out = rand_in1;

      // Check DUT output matches correct answer

      check( rand_in0, rand_in1, rand_sel, rand_out );

    end
  endtask
  //----------------------------------------------------------------------
  // run_test_suite
  //----------------------------------------------------------------------

  string test_suite_name;

  task run_test_suite( input int test_suite, input int n );
    if (( test_suite <= 0 ) || ( test_suite == p_test_suite )) begin
      $sformat( test_suite_name, "TestSuite: %0d\nMux2(.p_nbits(%0d))", p_test_suite, p_nbits );
      t.test_suite_begin( test_suite_name );

      if ((n <= 0) || (n == 1)) test_case_1_basic();
      if ((n <= 0) || (n == 2)) test_case_2_directed_4bit();
      if ((n <= 0) || (n == 4)) test_case_3_random();

      t.test_suite_end();
    end
  endtask

endmodule

//========================================================================
// Top
//========================================================================

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
  // Parameterized Test Suites
  //----------------------------------------------------------------------

  TestSuiteMux2
  #(
    .p_test_suite(1),
    .p_nbits(1)
  )
  test_suite_mux2_nbits_1();

  TestSuiteMux2
  #(
    .p_test_suite(2),
    .p_nbits(5)
  )
  test_suite_mux2_nbits_5();

  TestSuiteMux2
  #(
    .p_test_suite(3),
    .p_nbits(32)
  )
  test_suite_mux2_nbits_32();

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin( `__FILE__ );

    test_suite_mux2_nbits_1.run_test_suite ( t.test_suite, t.test_case );
    test_suite_mux2_nbits_5.run_test_suite ( t.test_suite, t.test_case );
    test_suite_mux2_nbits_32.run_test_suite ( t.test_suite, t.test_case );

    t.test_bench_end();
  end

endmodule

