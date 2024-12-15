//========================================================================
// Mux2_4b_GL-test
//========================================================================

`include "ece2300-test.v"
`include "Mux2_4b_GL.v"

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
  logic       dut_sel;
  logic [3:0] dut_out;

  Mux2_4b_GL dut
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
    input logic [3:0] in0,
    input logic [3:0] in1,
    input logic       sel,
    input logic [3:0] out
  );
    if ( !t.failed ) begin

      dut_in0 = in0;
      dut_in1 = in1;
      dut_sel = sel;

      #8;

      if ( t.n != 0 ) begin
        $display( "%3d: %b %b %b > %b", t.cycles,
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

    //     in0      in1      sel   out
    check( 4'b0000, 4'b0000, 1'b0, 4'b0000 );
    check( 4'b0000, 4'b0000, 1'b1, 4'b0000 );

  endtask
  
  task test_case_2_directed();
    t.test_case_begin( "test_case_2_directed" );
    //     in0      in1      sel   out

    check( 4'b1011, 4'b0101, 1'b0, 4'b1011 ); //select is 0, in0 and in1 are different
    check( 4'b1111, 4'b1001, 1'b1, 4'b1001 ); //select is 1, in0 and in1 are different
    check( 4'b1110, 4'b1110, 1'b1, 4'b1110 ); //select is 1, in0 and in1 are the same
    check( 4'b0011, 4'b1010, 1'b0, 4'b0011 ); //select is 0, in0 and in1 are different
  endtask


  logic [3:0] random_a;
  logic [3:0] random_b;
  logic       random_sel;
  logic [3:0] result_sel;
  task test_case_3_random();
    t.test_case_begin( "test_case_3_random" );
    for ( int i = 0; i < 15; i = i+1 ) begin

      // Generate a 4-bit random value for both a and b

      random_a = 4'($urandom(t.seed));
      random_b = 4'($urandom(t.seed));
      random_sel = 1'($urandom(t.seed));

      if (random_sel == 1'b0) begin
      result_sel = random_a;
      end

      if (random_sel == 1'b1) begin
      result_sel = random_b;
      end
      

      // Apply the random input values and check the output value

      check( random_a, random_b, random_sel, result_sel );
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
