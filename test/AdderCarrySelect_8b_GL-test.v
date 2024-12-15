//========================================================================
// AdderCarrySelect_4b_GL-test
//========================================================================

`include "ece2300-test.v"
`include "AdderCarrySelect_8b_GL.v"

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

  logic [7:0] dut_in0;
  logic [7:0] dut_in1;
  logic       dut_cin;
  logic       dut_cout;
  logic [7:0] dut_sum;

  AdderCarrySelect_8b_GL dut
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
    input logic [7:0] in0,
    input logic [7:0] in1,
    input logic       cin,
    input logic       cout,
    input logic [7:0] sum
  );
    if ( !t.failed ) begin

      dut_in0 = in0;
      dut_in1 = in1;
      dut_cin = cin;

      #8;

      if ( t.n != 0 ) begin
        $display( "%3d: %b + %b + %b (%3d + %3d + %b) > %b %b (%3d)", t.cycles,
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

    //     in0           in1           cin   cout  sum
    check( 8'b0000_0000, 8'b0000_0000, 1'b0, 1'b0, 8'b0000_0000  );
    check( 8'b0000_0001, 8'b0000_0001, 1'b0, 1'b0, 8'b0000_0010 );
    check( 8'b0000_0001, 8'b0000_0001, 1'b1, 1'b0, 8'b0000_0011 );
    check( 8'b1111_1111, 8'b0000_0001, 1'b0, 1'b1, 8'b0000_0000 );
    check( 8'b1111_1111, 8'b1111_1111, 1'b1, 1'b1, 8'b1111_1111 );

  endtask

  task test_case_2_directed();
    t.test_case_begin( "test_case_2_directed" );
    //     in0           in1           cin   cout  sum
    check( 8'b0000_0000, 8'b0000_0000, 1'b0, 1'b0, 8'b0000_0000 ); //cin is zero and cout is zero
    check( 8'b0000_0000, 8'b0000_0000, 1'b1, 1'b0, 8'b0000_0001 ); //cin is one and cout is zero
    check( 8'b1000_0000, 8'b1000_0000, 1'b0, 1'b1, 8'b0000_0000 ); //cin is zero and cout is one
    check( 8'b1000_0000, 8'b1000_0000, 1'b1, 1'b1, 8'b0000_0001 ); //cin is one and cout is one
    check( 8'b1111_1111, 8'b1111_1111, 1'b1, 1'b1, 8'b1111_1111 ); //every bit is one

    check( 8'b1010_1010, 8'b0101_0101, 1'b0, 1'b0, 8'b1111_1111 );//sum is all one's, cin and cout are 1
    check( 8'b0101_0101, 8'b1010_1010, 1'b1, 1'b1, 8'b0000_0000 );//sum is all zeros, cin and cout are 1
    check( 8'b1010_1010, 8'b1101_0101, 1'b0, 1'b1, 8'b0111_1111 );//cin is 0 and cout is 1
    check( 8'b0101_0100, 8'b1010_1010, 1'b1, 1'b0, 8'b1111_1111 );//sum is all zeros, cin is 1 and cout is 0
  endtask

  logic [7:0] random_a;
  logic [7:0] random_b;
  logic       random_cin;
  logic       random_cout;
  logic [8:0] random_sum;
  logic [7:0] result_sum;
  
  task test_case_3_random();
    t.test_case_begin( "test_case_3_random" );
    for ( int i = 0; i < 15; i = i+1 ) begin

      // Generate a 4-bit random value for both a and b

      random_a = 8'($urandom(t.seed));
      random_b = 8'($urandom(t.seed));
      random_cin = 1'($urandom(t.seed));

      random_sum = random_a + random_b + {7'b0,random_cin};
      random_cout = random_sum[8];

      result_sum = random_sum[7:0];
      

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

