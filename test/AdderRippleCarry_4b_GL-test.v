//========================================================================
// AdderRippleCarry_4b_GL-test
//========================================================================

`include "ece2300-test.v"
`include "AdderRippleCarry_4b_GL.v"

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

  logic [3:0] dut_in0;
  logic [3:0] dut_in1;
  logic       dut_cin;
  logic       dut_cout;
  logic [3:0] dut_sum;

  AdderRippleCarry_4b_GL dut
  (
    .in0  (dut_in0),
    .in1  (dut_in1),
    .cin  (dut_cin),
    .cout (dut_cout),
    .sum  (dut_sum)
  );

  //----------------------------------------------------------------------
  // check
  //----------------------------------------------------------------------
  // All tasks start at #1 after the rising edge of the clock. So we
  // write the inputs #1 after the rising edge, and check the outputs #1
  // before the next rising edge.

  task check
  (
    input logic [3:0] in0,
    input logic [3:0] in1,
    input logic       cin,
    input logic       cout,
    input logic [3:0] sum
  );
    if ( !t.failed ) begin

      dut_in0 = in0;
      dut_in1 = in1;
      dut_cin = cin;

      #8;

      if ( t.n != 0 ) begin
        $display( "%3d: %b + %b + %b (%2d + %2d + %b) > %b %b (%2d)", t.cycles,
                dut_in0, dut_in1, dut_cin,
                dut_in0, dut_in1, dut_cin,
                dut_cout, dut_sum, dut_sum );
      end

      `ECE2300_CHECK_EQ( dut_cout, cout );
      `ECE2300_CHECK_EQ( dut_sum,  sum  );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );

    //     in0      in1      cin   cout  sum
    check( 4'b0000, 4'b0000, 1'b0, 1'b0, 4'b0000 );
    check( 4'b0001, 4'b0000, 1'b0, 1'b0, 4'b0001 );
    check( 4'b0000, 4'b0001, 1'b0, 1'b0, 4'b0001 );
    check( 4'b0001, 4'b0001, 1'b0, 1'b0, 4'b0010 );

  endtask

  task test_case_2_directed();
    t.test_case_begin( "test_case_2_directed" );
    //     in0      in1      cin   cout  sum
    check( 4'b0000, 4'b0000, 1'b0, 1'b0, 4'b0000 ); //cin is zero and cout is zero
    check( 4'b0000, 4'b0000, 1'b1, 1'b0, 4'b0001 ); //cin is one and cout is zero
    check( 4'b1000, 4'b1000, 1'b0, 1'b1, 4'b0000 ); //cin is zero and cout is one
    check( 4'b1000, 4'b1000, 1'b1, 1'b1, 4'b0001 ); //cin is one and cout is one
    check( 4'b1111, 4'b1111, 1'b1, 1'b1, 4'b1111 ); //every bit is one

    check( 4'b0000, 4'b0000, 1'b0, 1'b0, 4'b0000 );//in0 bit is 0 and in1 bit is 0
    check( 4'b0010, 4'b0000, 1'b0, 1'b0, 4'b0010 );//in0 bit is 1 and in1 bit is 0
    check( 4'b0000, 4'b0100, 1'b0, 1'b0, 4'b0100 );//in0 bit is 0 and in1 bit is 1
    check( 4'b0100, 4'b0100, 1'b0, 1'b0, 4'b1000 );//in0 bit is 1 and in1 bit is 1
    
    check( 4'b0000, 4'b0000, 1'b0, 1'b0, 4'b0000 ); //cin is zero and cout is zero
    check( 4'b0000, 4'b0000, 1'b0, 1'b0, 4'b0000 ); //cin is one and cout is zero
  endtask

  logic [3:0] random_a;
  logic [3:0] random_b;
  logic        random_cin;
  logic       random_cout;
  logic [4:0] random_sum;
  logic [3:0] result_sum;
  
  task test_case_3_random();
    t.test_case_begin( "test_case_random" );
    for ( int i = 0; i < 15; i = i+1 ) begin

      // Generate a 4-bit random value for both a and b

      random_a = 4'($urandom(t.seed));
      random_b = 4'($urandom(t.seed));
      random_cin = 1'($urandom(t.seed));

      random_sum = random_a + random_b + {3'b0,random_cin};
      random_cout = random_sum[4];

      result_sum = random_sum[3:0];
      

      // Apply the random input values and check the output value

      check( random_a, random_b, random_cin, random_cout, result_sum );
    end
  endtask
  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin( `__FILE__ );

    if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();
    if ((t.n <= 0) || (t.n == 1)) test_case_2_directed();
    if ((t.n <= 0) || (t.n == 1)) test_case_3_random();

    t.test_bench_end();
  end

endmodule
