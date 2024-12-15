//========================================================================
// BinaryToSevenSeg_GL-test
//========================================================================

`include "ece2300-test.v"
`include "BinaryToSevenSeg_GL.v"

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

  logic [3:0] dut_in;
  logic [6:0] dut_seg;

  BinaryToSevenSeg_GL dut
  (
    .in  (dut_in),
    .seg (dut_seg)
  );

  //----------------------------------------------------------------------
  // check
  //----------------------------------------------------------------------
  // All tasks start at #1 after the rising edge of the clock. So we
  // write the inputs #1 after the rising edge, and check the outputs #1
  // before the next rising edge.

  task check
  (
    input logic [3:0] in,
    input logic [6:0] seg
  );
    if ( !t.failed ) begin

      dut_in = in;

      #8;

      if ( t.n != 0 ) begin
        $display( "%3d: %b (%d) > %b", t.cycles,
                  dut_in, dut_in, dut_seg );
      end

      `ECE2300_CHECK_EQ( dut_seg, seg );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );

    check( 4'b0000, 7'b100_0000 );
    check( 4'b0001, 7'b111_1001 );
    check( 4'b0111, 7'b111_1000 );
    check( 4'b1111, 7'b000_0000 );

  endtask

  //----------------------------------------------------------------------
  // test_case_2_exhaustive
  //----------------------------------------------------------------------

  task test_case_2_exhaustive();
    t.test_case_begin( "test_case_2_exhaustive" );

    check( 4'b0000, 7'b100_0000 ); //0
    check( 4'b0001, 7'b111_1001 ); //1
    check( 4'b0010, 7'b010_0100 ); //2
    check( 4'b0011, 7'b011_0000 ); //3
    check( 4'b0100, 7'b001_1001 ); //4
    check( 4'b0101, 7'b001_0010 ); //5
    check( 4'b0110, 7'b000_0010 ); //6
    check( 4'b0111, 7'b111_1000 ); //7
    check( 4'b1000, 7'b000_0000 ); //8
    check( 4'b1001, 7'b001_1000 ); //9

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
