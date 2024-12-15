//========================================================================
// Mux8_RTL-test
//========================================================================

`include "ece2300-test.v"
`include "Mux8_RTL.v"

//========================================================================
// Parameterized Test Suite
//========================================================================

module TestSuiteMux8
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
  logic [p_nbits-1:0] dut_in2;
  logic [p_nbits-1:0] dut_in3;
  logic [p_nbits-1:0] dut_in4;
  logic [p_nbits-1:0] dut_in5;
  logic [p_nbits-1:0] dut_in6;
  logic [p_nbits-1:0] dut_in7;
  logic         [2:0] dut_sel;
  logic [p_nbits-1:0] dut_out;

  Mux8_RTL
  #(
    .p_nbits (p_nbits)
  )
  dut
  (
    .in0 (dut_in0),
    .in1 (dut_in1),
    .in2 (dut_in2),
    .in3 (dut_in3),
    .in4 (dut_in4),
    .in5 (dut_in5),
    .in6 (dut_in6),
    .in7 (dut_in7),
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
    input logic [p_nbits-1:0] in2,
    input logic [p_nbits-1:0] in3,
    input logic [p_nbits-1:0] in4,
    input logic [p_nbits-1:0] in5,
    input logic [p_nbits-1:0] in6,
    input logic [p_nbits-1:0] in7,
    input logic         [2:0] sel,
    input logic [p_nbits-1:0] out
  );
    if ( !t.failed ) begin

      dut_in0 = in0;
      dut_in1 = in1;
      dut_in2 = in2;
      dut_in3 = in3;
      dut_in4 = in4;
      dut_in5 = in5;
      dut_in6 = in6;
      dut_in7 = in7;
      dut_sel = sel;

      #8;

      if ( t.n != 0 ) begin
        if ( p_nbits <= 8 )
          $display( "%3d: %b %b %b %b %b %b %b %b %b > %b", t.cycles,
                    dut_in0, dut_in1, dut_in2, dut_in3,
                    dut_in4, dut_in5, dut_in6, dut_in7,
                    dut_sel, dut_out );
        else
          $display( "%3d: %h %h %h %h %h %h %h %h %b > %h", t.cycles,
                    dut_in0, dut_in1, dut_in2, dut_in3,
                    dut_in4, dut_in5, dut_in6, dut_in7,
                    dut_sel, dut_out );
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

    //     in0 in1 in2 in3 in4 in5 in6 in7 sel out
    check( 0,  0,  0,  0,  0,  0,  0,  0,  0,  0 );
    check( 0,  0,  0,  0,  0,  0,  0,  0,  1,  0 );
    check( 0,  0,  0,  0,  0,  0,  0,  0,  2,  0 );
    check( 0,  0,  0,  0,  0,  0,  0,  0,  3,  0 );

  endtask

  task test_case_2_directed_1bit();
      t.test_case_begin( "test_case_2_directed_1bit" );

      //       in0 in1 in2 in3 in4 in5 in6 in7 sel out
      check(   1,  0,  1,  0,  1,  0,  1,  0,  0,  1 );
      check(   1,  0,  1,  0,  1,  0,  1,  0,  1,  0 );
      check(   0,  1,  0,  1,  0,  1,  0,  1,  2,  0 );
      check(   0,  1,  0,  1,  0,  1,  0,  1,  3,  1 );
      check(   1,  1,  1,  0,  0,  0,  0,  0,  4,  0 );
      check(   0,  0,  0,  0,  1,  1,  0,  1,  5,  1 );
      check(   1,  0,  0,  1,  0,  1,  1,  0,  6,  1 );
      check(   1,  1,  1,  1,  0,  0,  0,  1,  7,  1 );

  endtask
  //----------------------------------------------------------------------
  // test_case_3_directed_4bit
  //----------------------------------------------------------------------

  task test_case_3_directed_4bit();
      t.test_case_begin( "test_case_3_directed_4bit" );

      //       in0                  in1                  in2                  in3                  in4                  in5                  in6                  in7                sel out
      check(   p_nbits'(4'b1100),   p_nbits'(4'b0011),   p_nbits'(4'b1010),   p_nbits'(4'b0101),   p_nbits'(4'b0110),   p_nbits'(4'b1001),   p_nbits'(4'b1111),   p_nbits'(4'b0000),   0, p_nbits'(4'b1100) );
      check(   p_nbits'(4'b1100),   p_nbits'(4'b0011),   p_nbits'(4'b1010),   p_nbits'(4'b0101),   p_nbits'(4'b0110),   p_nbits'(4'b1001),   p_nbits'(4'b1111),   p_nbits'(4'b0000),   1, p_nbits'(4'b0011) );
      check(   p_nbits'(4'b1100),   p_nbits'(4'b0011),   p_nbits'(4'b1010),   p_nbits'(4'b0101),   p_nbits'(4'b0110),   p_nbits'(4'b1001),   p_nbits'(4'b1111),   p_nbits'(4'b0000),   2, p_nbits'(4'b1010) );
      check(   p_nbits'(4'b1100),   p_nbits'(4'b0011),   p_nbits'(4'b1010),   p_nbits'(4'b0101),   p_nbits'(4'b0110),   p_nbits'(4'b1001),   p_nbits'(4'b1111),   p_nbits'(4'b0000),   3, p_nbits'(4'b0101) );
      check(   p_nbits'(4'b1100),   p_nbits'(4'b0011),   p_nbits'(4'b1010),   p_nbits'(4'b0101),   p_nbits'(4'b0110),   p_nbits'(4'b1001),   p_nbits'(4'b1111),   p_nbits'(4'b0000),   4, p_nbits'(4'b0110) );
      check(   p_nbits'(4'b1100),   p_nbits'(4'b0011),   p_nbits'(4'b1010),   p_nbits'(4'b0101),   p_nbits'(4'b0110),   p_nbits'(4'b1001),   p_nbits'(4'b1111),   p_nbits'(4'b0000),   5, p_nbits'(4'b1001) );
      check(   p_nbits'(4'b1100),   p_nbits'(4'b0011),   p_nbits'(4'b1010),   p_nbits'(4'b0101),   p_nbits'(4'b0110),   p_nbits'(4'b1001),   p_nbits'(4'b1111),   p_nbits'(4'b0000),   6, p_nbits'(4'b1111) );
      check(   p_nbits'(4'b1100),   p_nbits'(4'b0011),   p_nbits'(4'b1010),   p_nbits'(4'b0101),   p_nbits'(4'b0110),   p_nbits'(4'b1001),   p_nbits'(4'b1111),   p_nbits'(4'b0000),   7, p_nbits'(4'b0000) );

  endtask

  logic [p_nbits-1:0] rand_in0;
  logic [p_nbits-1:0] rand_in1;
  logic [p_nbits-1:0] rand_in2;
  logic [p_nbits-1:0] rand_in3;
  logic [p_nbits-1:0] rand_in4;
  logic [p_nbits-1:0] rand_in5;
  logic [p_nbits-1:0] rand_in6;
  logic [p_nbits-1:0] rand_in7;
  logic         [2:0] rand_sel;
  logic [p_nbits-1:0] rand_out;

  task test_case_4_random();
    t.test_case_begin( "test_case_4_random" );

    for ( int i = 0; i < 50; i = i+1 ) begin

      // Generate random values for inputs and sel

      rand_in0 = p_nbits'($urandom(t.seed));
      rand_in1 = p_nbits'($urandom(t.seed));
      rand_in2 = p_nbits'($urandom(t.seed));
      rand_in3 = p_nbits'($urandom(t.seed));
      rand_in4 = p_nbits'($urandom(t.seed));
      rand_in5 = p_nbits'($urandom(t.seed));
      rand_in6 = p_nbits'($urandom(t.seed));
      rand_in7 = p_nbits'($urandom(t.seed));
      rand_sel = 3'($urandom(t.seed));

      // Determine correct answer

      if ( rand_sel == 0 )
        rand_out = rand_in0;
      else if ( rand_sel == 1 )
        rand_out = rand_in1;
      else if ( rand_sel == 2 )
        rand_out = rand_in2;
      else if ( rand_sel == 3 )
        rand_out = rand_in3;
      else if ( rand_sel == 4 )
        rand_out = rand_in4;
      else if ( rand_sel == 5 )
        rand_out = rand_in5;
      else if ( rand_sel == 6 )
        rand_out = rand_in6;
      else if ( rand_sel == 7 )
        rand_out = rand_in7;

      // Check DUT output matches correct answer

      check( rand_in0, rand_in1, rand_in2, rand_in3, rand_in4, rand_in5, rand_in6, rand_in7, rand_sel, rand_out );

    end

  endtask

  //----------------------------------------------------------------------
  // run_test_suite
  //----------------------------------------------------------------------

  string test_suite_name;

  task run_test_suite( input int test_suite, input int n );
    if (( test_suite <= 0 ) || ( test_suite == p_test_suite )) begin
      $sformat( test_suite_name, "TestSuite: %0d\nMux8(.p_nbits(%0d))", p_test_suite, p_nbits );
      t.test_suite_begin( test_suite_name );

      if ((n <= 0) || (n == 1)) test_case_1_basic();
      if ((n <= 0) || (n == 2)) test_case_2_directed_1bit();
      if ((n <= 0) || (n == 3)) test_case_3_directed_4bit();
      if ((n <= 0) || (n == 4)) test_case_4_random();
    end
  endtask

endmodule

//========================================================================
//Top
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

  TestSuiteMux8
  #(
    .p_test_suite(1),
    .p_nbits(1)
  )
  test_suite_mux8_nbits_1();

  TestSuiteMux8
  #(
    .p_test_suite(2),
    .p_nbits(5)
  )
  test_suite_mux8_nbits_5();

  TestSuiteMux8
  #(
    .p_test_suite(3),
    .p_nbits(32)
  )
  test_suite_mux8_nbits_32();

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin( `__FILE__ );

    test_suite_mux8_nbits_1.run_test_suite ( t.test_suite, t.test_case );
    test_suite_mux8_nbits_5.run_test_suite ( t.test_suite, t.test_case );
    test_suite_mux8_nbits_32.run_test_suite ( t.test_suite, t.test_case );

    t.test_bench_end();
  end

endmodule

