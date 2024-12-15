//========================================================================
// RegfileZ1r1w_32x32b_RTL-test
//========================================================================

`include "ece2300-test.v"
`include "RegfileZ1r1w_32x32b_RTL.v"

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

  logic        dut_wen;
  logic  [4:0] dut_waddr;
  logic [31:0] dut_wdata;
  logic  [4:0] dut_raddr;
  logic [31:0] dut_rdata;

  RegfileZ1r1w_32x32b_RTL dut
  (
    .clk   (clk),
    .wen   (dut_wen),
    .waddr (dut_waddr),
    .wdata (dut_wdata),
    .raddr (dut_raddr),
    .rdata (dut_rdata)
  );

  //----------------------------------------------------------------------
  // check
  //----------------------------------------------------------------------
  // All tasks start at #1 after the rising edge of the clock. So we
  // write the inputs #1 after the rising edge, and check the outputs #1
  // before the next rising edge.

  task check
  (
    input logic        wen,
    input logic  [4:0] waddr,
    input logic [31:0] wdata,
    input logic  [4:0] raddr,
    input logic [31:0] rdata
  );
    if ( !t.failed ) begin

      dut_wen   = wen;
      dut_waddr = waddr;
      dut_wdata = wdata;
      dut_raddr = raddr;

      #8;

      if ( t.n != 0 ) begin
        $display( "%3d: %b %2d %h | %2d > %h", t.cycles,
                  dut_wen, dut_waddr, dut_wdata, dut_raddr, dut_rdata );
      end

      `ECE2300_CHECK_EQ( dut_rdata, rdata );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );

    //    wen waddr wdata  raddr rdata
    check( 1, 1,    32'h0, 1,    32'hx );
    check( 1, 1,    32'h1, 1,    32'h0 );
    check( 0, 1,    32'h0, 1,    32'h1 );

  endtask

  task test_case_2_directed();
    t.test_case_begin( "test_case_2_directed" );

    //    wen waddr wdata  raddr rdata
    check( 1, 0,    32'ha, 0,    32'hx );
    check( 1, 1,    32'hb, 0,    32'b0 );
    check( 1, 2,    32'hc, 0,    32'b0 );
    check( 1, 3,    32'hd, 0,    32'b0 );

    //    wen waddr wdata  raddr rdata
    check( 1, 0,    32'hb, 1,    32'hb );
    check( 1, 1,    32'hc, 2,    32'hc );
    check( 1, 2,    32'hd, 3,    32'hd );
    check( 1, 3,    32'ha, 0,    32'b0 );

    //    wen waddr wdata  raddr rdata
    check( 1, 0,    32'ha, 0,    32'b0 );
    check( 1, 1,    32'ha, 1,    32'hc );
    check( 1, 2,    32'ha, 1,    32'ha ); 
    check( 1, 3,    32'hb, 3,    32'ha );

  endtask

  logic [4:0] rand_waddr;
  logic [31:0] rand_wdata;
  logic [4:0] rand_raddr;
  logic [31:0] rand_rdata;
  logic [31:0] rand_mem [32];

  task test_case_3_random();
  t.test_case_begin("randomTests");

  for (int i = 1; i < 32; i++) begin
    rand_wdata = 32'($urandom(t.seed));
    rand_mem[i] = rand_wdata;
    check(1, i[4:0], rand_wdata, i[4:0], 32'hx);
  end

  rand_mem[0] = 32'h0;

  //random test loop

  for( int i = 0; i < 100; i++) begin
    rand_waddr = 5'($urandom(t.seed));
    rand_wdata = 32'($urandom(t.seed));
    rand_raddr = 5'($urandom(t.seed));

    rand_rdata = rand_mem[rand_raddr];
    //    wen waddr wdata  raddr rdata
    check( 1, rand_waddr,    rand_wdata, rand_raddr,    rand_rdata );

    rand_mem[rand_waddr] = rand_wdata;

    rand_mem[0] = 32'h0;

  end

endtask

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin( `__FILE__ );

    if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();
    if ((t.n <= 0) || (t.n == 2)) test_case_2_directed();
    if ((t.n <= 0) || (t.n == 3)) test_case_3_random();

    t.test_bench_end();
  end

endmodule

