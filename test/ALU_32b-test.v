//========================================================================
// ALU_32b-test
//========================================================================

`include "ece2300-test.v"
`include "ALU_32b.v"

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
  logic        dut_op;
  logic [31:0] dut_out;

  ALU_32b dut
  (
    .in0 (dut_in0),
    .in1 (dut_in1),
    .op  (dut_op),
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
    input logic [31:0] in0,
    input logic [31:0] in1,
    input logic        op,
    input logic [31:0] out
  );
    if ( !t.failed ) begin

      dut_in0 = in0;
      dut_in1 = in1;
      dut_op  = op;

      #8;

      if ( t.n != 0 ) begin
        if ( op == 0 ) begin
          $display( "%3d: %h +  %h (%10d +  %10d) > %h (%10d)", t.cycles,
                    dut_in0, dut_in1, dut_in0, dut_in1,
                    dut_out, dut_out );
        end
        else begin
          $display( "%3d: %h == %h (%10d == %10d) > %h (%10d)", t.cycles,
                    dut_in0, dut_in1, dut_in0, dut_in1,
                    dut_out, dut_out );
        end
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

    //     in0    in1    op out
    check( 32'd0, 32'd0, 0, 32'd0 );
    check( 32'd0, 32'd1, 0, 32'd1 );
    check( 32'd1, 32'd0, 0, 32'd1 );
    check( 32'd1, 32'd1, 0, 32'd2 );

    check( 32'd0, 32'd0, 1, 32'd1 );
    check( 32'd0, 32'd1, 1, 32'd0 );
    check( 32'd1, 32'd0, 1, 32'd0 );
    check( 32'd1, 32'd1, 1, 32'd1 );

  endtask

  task directedTestCase1();
    t.test_case_begin( "directedTestCase1" );

    //     in0    in1    op out
    // Test with minimal values and simple additions
    check( 32'd0, 32'd0, 0, 32'd0 ); // Zero inputs
    check( 32'd0, 32'd1, 0, 32'd1 ); // One input zero, one minimal positive
    check( 32'd1, 32'd0, 0, 32'd1 ); // One input minimal positive, one zero
    check( 32'd1, 32'd1, 0, 32'd2 ); // Minimal positive values


  endtask

  task directedTestCase2();
    t.test_case_begin( "directedTestCase2" );

    //     in0    in1    op out
    // Test with maximum positive values and overflow
    check( 32'h7FFFFFFF, 32'd1, 0, 32'h80000000 ); // Largest positive + 1, causes overflow
    check( 32'hFFFFFFFF, 32'd1, 0, 32'd0 );       // All 1s + 1, results in overflow to zero
    check( 32'h7FFFFFFF, 32'h7FFFFFFF, 0, 32'hFFFFFFFE ); // Largest positive + largest positive
  

  endtask

  task directedTestCase3();
  t.test_case_begin( "directedTestCase3" );
  
  // Test with negative boundaries and overflow handling
  check( 32'h80000000, 32'd1, 0, 32'h80000001 ); // Smallest negative + 1
  check( 32'h80000000, 32'h80000000, 0, 32'h00000000 ); // Smallest negative + smallest negative
  check( 32'hFFFFFFFF, 32'hFFFFFFFF, 0, 32'hFFFFFFFE ); // Overflow with all 1s
  

  endtask

  task directedTestCase4();
    t.test_case_begin( "directedTestCase3" );
  
  // Test with negative boundaries and overflow handling

  //     in0            in1           op out
    check( 32'h80000000, 32'h80000000, 1, 1 ); 
    check( 32'hFFFFFFFF, 32'hFFFFFFFF, 1, 1 ); 
    check( 32'h80000000, 32'hFFFFFFFF, 1, 0); 
    check( 32'd0, 32'd0, 1, 1 );
    check( 32'd0, 32'd1, 1, 0 );
    check( 32'd1, 32'd0, 1, 0 );
    check( 32'd1, 32'd1, 1, 1 );
  

  endtask

  logic [31:0] random_a;
  logic [31:0] random_b;
  logic op;
  task test_case_5_random();
     t.test_case_begin( "test_case_5_random" );
     for ( int i = 0; i < 100; i = i+1 ) begin

       // Generate a 32-bit random value for both a and b
       random_a = 32'($urandom(t.seed));
       random_b = 32'($urandom(t.seed));
       op = 1'($urandom(t.seed));
      
      // Apply the random input values and check the output value
      if(op == 1'b1)
        check(random_a, random_b, op,{31'b0, random_a==random_b});
      else
        check(random_a, random_b, op, random_a+random_b);
    end
   endtask

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin( `__FILE__ );

    if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();
    if ((t.n <= 0) || (t.n == 2)) directedTestCase1();
    if ((t.n <= 0) || (t.n == 3)) directedTestCase2();
    if ((t.n <= 0) || (t.n == 4)) directedTestCase3();
    if ((t.n <= 0) || (t.n == 5)) directedTestCase4();
    if ((t.n <= 0) || (t.n == 6)) test_case_5_random();


    t.test_bench_end();
  end

endmodule

