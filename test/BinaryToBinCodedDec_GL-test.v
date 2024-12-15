//========================================================================
// BinaryToBinCodedDec_GL-test
//========================================================================

`include "ece2300-test.v"
`include "BinaryToBinCodedDec_GL.v"

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

  logic [4:0] dut_in;
  logic [3:0] dut_tens;
  logic [3:0] dut_ones;

  BinaryToBinCodedDec_GL dut
  (
    .in   (dut_in),
    .tens (dut_tens),
    .ones (dut_ones)
  );

  //----------------------------------------------------------------------
  // check
  //----------------------------------------------------------------------
  // All tasks start at #1 after the rising edge of the clock. So we
  // write the inputs #1 after the rising edge, and check the outputs #1
  // before the next rising edge.

  task check
  (
    input logic [4:0] in,
    input logic [3:0] tens,
    input logic [3:0] ones
  );
    if ( !t.failed ) begin

      dut_in = in;

      #8;

      if ( t.n != 0 ) begin
        if ( dut_tens != 0 )
          $display( "%3d: %b (%d) > %b %b (%0d%0d)", t.cycles,
                    dut_in, dut_in, dut_tens, dut_ones, dut_tens, dut_ones );
        else
          $display( "%3d: %b (%d) > %b %b ( %0d)", t.cycles,
                    dut_in, dut_in, dut_tens, dut_ones, dut_ones );
      end

      `ECE2300_CHECK_EQ( dut_tens, tens );
      `ECE2300_CHECK_EQ( dut_ones, ones );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );

    check( 5'b00000, 4'b0000, 4'b0000 );
    check( 5'b00001, 4'b0000, 4'b0001 );
    check( 5'b01111, 4'b0001, 4'b0101 );
    check( 5'b11111, 4'b0011, 4'b0001 );

  endtask

  //----------------------------------------------------------------------
  // test_case_2_exhaustive
  //----------------------------------------------------------------------

  task test_case_2_exhaustive();
    t.test_case_begin( "test_case_2_exhaustive" );
    check( 5'b00000, 4'b0000, 4'b0000 );
    check( 5'b00001, 4'b0000, 4'b0001 );
    check( 5'b00010, 4'b0000, 4'b0010 );
    check( 5'b00011, 4'b0000, 4'b0011 );
    check( 5'b00100, 4'b0000, 4'b0100 );
    check( 5'b00101, 4'b0000, 4'b0101 );
    check( 5'b00110, 4'b0000, 4'b0110 );
    check( 5'b00111, 4'b0000, 4'b0111 );
    check( 5'b01000, 4'b0000, 4'b1000 );
    check( 5'b01001, 4'b0000, 4'b1001 );
    check( 5'b01010, 4'b0001, 4'b0000 );
    check( 5'b01011, 4'b0001, 4'b0001 );
    check( 5'b01100, 4'b0001, 4'b0010 );
    check( 5'b01101, 4'b0001, 4'b0011 );
    check( 5'b01110, 4'b0001, 4'b0100 );
    check( 5'b01111, 4'b0001, 4'b0101 );
    check( 5'b10000, 4'b0001, 4'b0110 );
    check( 5'b10001, 4'b0001, 4'b0111 );
    check( 5'b10010, 4'b0001, 4'b1000 );
    check( 5'b10011, 4'b0001, 4'b1001 );
    check( 5'b10100, 4'b0010, 4'b0000 );
    check( 5'b10101, 4'b0010, 4'b0001 );
    check( 5'b10110, 4'b0010, 4'b0010 );
    check( 5'b10111, 4'b0010, 4'b0011 );
    check( 5'b11000, 4'b0010, 4'b0100 );
    check( 5'b11001, 4'b0010, 4'b0101 );
    check( 5'b11010, 4'b0010, 4'b0110 );
    check( 5'b11011, 4'b0010, 4'b0111 );
    check( 5'b11100, 4'b0010, 4'b1000 );
    check( 5'b11101, 4'b0010, 4'b1001 );
    check( 5'b11110, 4'b0011, 4'b0000 );
    check( 5'b11111, 4'b0011, 4'b0001 );

  endtask

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin( `__FILE__ );

    if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();
    if ((t.n <= 0) || (t.n == 2)) test_case_2_exhaustive();

    t.test_bench_end();
  end

endmodule
