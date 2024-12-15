//========================================================================
// Multiplier_32x32b_RTL-test
//========================================================================

`include "ece2300-test.v"
`include "Multiplier_32x32b_RTL.v"

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
  logic [31:0] dut_prod;

  Multiplier_32x32b_RTL dut
  (
    .in0  (dut_in0),
    .in1  (dut_in1),
    .prod (dut_prod)
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
    input logic [31:0] prod
  );
    if ( !t.failed ) begin

      dut_in0 = in0;
      dut_in1 = in1;

      #8;

      if ( t.n != 0 ) begin
        $display( "%3d: %h * %h (%10d * %10d) > %h (%10d)", t.cycles,
                  dut_in0, dut_in1, dut_in0, dut_in1,
                  dut_prod, dut_prod );
      end

      `ECE2300_CHECK_EQ( dut_prod, prod );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );

    //     in0    in1    prod
    check( 32'd0, 32'd0, 32'd0 ); // 0 * 0 = 0
    check( 32'd1, 32'd0, 32'd0 ); // 1 * 0 = 0
    check( 32'd1, 32'd1, 32'd1 ); // 1 * 1 = 1
    check( 32'd1, 32'd2, 32'd2 ); // 1 * 2 = 2
    check( 32'd1, 32'd3, 32'd3 ); // 1 * 3 = 3

  endtask

  task test_case_2_directed();
    t.test_case_begin( "test_case_2_directed" );

    // Directed test cases for multiplication
    //     in0       in1       prod
    check( 32'd2,    32'd3,    32'd6 );        // 2 * 3 = 6
    check( 32'd5,    32'd5,    32'd25 );       // 5 * 5 = 25
    check( 32'd10,   32'd20,   32'd200 );      // 10 * 20 = 200
    check( 32'd100,  32'd100,  32'd10000 );    // 100 * 100 = 10000
    check( 32'd255,  32'd255,  32'd65025 );    // 255 * 255 = 65025
    check( 32'd1000, 32'd0,    32'd0 );        // 1000 * 0 = 0
    check( 32'd123,  32'd456,  32'd56088 );    // 123 * 456 = 56088
    check( 32'd1024, 32'd1024, 32'd1048576 );  // 1024 * 1024 = 1048576

  endtask
  
  logic [31:0] random_in0; 
  logic [31:0] random_in1;
  int seed = 12345;
  task test_case_3_random();
    t.test_case_begin("test_case_3_random");

     // Set a seed for repeatability

    for (int i = 0; i < 10; i = i + 1) begin
      random_in0 = 32'($urandom(t.seed)); // Generate a random 32-bit value for in0
      random_in1 = 32'($urandom(seed)); // Generate a random 32-bit value for in1

      // Expected output based on multiplication
      check(random_in0, random_in1, random_in0 * random_in1); // Test multiplication
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


