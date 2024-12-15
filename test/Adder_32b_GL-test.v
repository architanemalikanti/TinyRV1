//========================================================================
// Adder_32b_GL-test
//========================================================================

`include "ece2300-test.v"
`include "Adder_32b_GL.v"

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
  logic [31:0] dut_sum;

  Adder_32b_GL dut
  (
    .in0 (dut_in0),
    .in1 (dut_in1),
    .sum (dut_sum)
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
    input logic [31:0] sum
  );
    if ( !t.failed ) begin

      dut_in0 = in0;
      dut_in1 = in1;

      #8;

      if ( t.n != 0 ) begin
        $display( "%3d: %h + %h (%10d + %10d) > %h (%10d)", t.cycles,
                  dut_in0, dut_in1, dut_in0, dut_in1,
                  dut_sum, dut_sum );
      end

      `ECE2300_CHECK_EQ( dut_sum, sum );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );

    //     in0    in1    sum
    check( 32'd0, 32'd0, 32'd0 );
    check( 32'd0, 32'd1, 32'd1 );
    check( 32'd1, 32'd0, 32'd1 );
    check( 32'd1, 32'd1, 32'd2 );

  endtask

  task test_case_2_edge_cases();
    t.test_case_begin( "test_case_2_edge_cases" );

    //     in0                     in1                     sum
    check( 32'd0,                  32'd4294967295,         32'd4294967295   ); // Adding zero to max
    check( 32'd4294967295,         32'd1,                  32'd0            ); // Overflow case (wraps to zero in unsigned 32-bit)
    check( 32'd2147483648,         32'd2147483648,         32'd0            ); // Adding two large numbers (wraps around)
    check( 32'd4294967295,         32'd4294967295,         32'd4294967294   ); // Overflow case: Max value + Max value

endtask

  logic [31:0] random_a;
  logic [31:0] random_b;
  logic [31:0] random_sum;
  task test_case_3_random();
      t.test_case_begin( "test_case_3_random" );
      for ( int i = 0; i < 15; i = i+1 ) begin

        // Generate a 4-bit random value for both a and b

        random_a = 32'($urandom(t.seed));
        random_b = 32'($urandom(t.seed));

        random_sum = random_a + random_b;

        check( random_a, random_b, random_sum[31:0] );
      end
    endtask
  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin( `__FILE__ );

    if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();
    if ((t.n <= 0) || (t.n == 1)) test_case_2_edge_cases();
    if ((t.n <= 0) || (t.n == 1)) test_case_3_random();

    t.test_bench_end();
  end

endmodule

