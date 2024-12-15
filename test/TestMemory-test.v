//========================================================================
// TestMemory-test
//========================================================================

`include "ece2300-test.v"
`include "TestMemory.v"

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

  logic        dut_imemreq_val;
  logic [31:0] dut_imemreq_addr;
  logic [31:0] dut_imemresp_data;

  logic        dut_dmemreq_val;
  logic        dut_dmemreq_type;
  logic [31:0] dut_dmemreq_addr;
  logic [31:0] dut_dmemreq_wdata;
  logic [31:0] dut_dmemresp_rdata;

  TestMemory dut
  (
    .clk            (clk),
    .rst            (reset),

    .imemreq_val    (dut_imemreq_val),
    .imemreq_addr   (dut_imemreq_addr),
    .imemresp_data  (dut_imemresp_data),

    .dmemreq_val    (dut_dmemreq_val),
    .dmemreq_type   (dut_dmemreq_type),
    .dmemreq_addr   (dut_dmemreq_addr),
    .dmemreq_wdata  (dut_dmemreq_wdata),
    .dmemresp_rdata (dut_dmemresp_rdata)
  );

  //----------------------------------------------------------------------
  // check
  //----------------------------------------------------------------------

  task check
  (
    input logic        imemreq_val,
    input logic [31:0] imemreq_addr,
    input logic [31:0] imemresp_data,

    input logic        dmemreq_val,
    input logic        dmemreq_type,
    input logic [31:0] dmemreq_addr,
    input logic [31:0] dmemreq_wdata,
    input logic [31:0] dmemresp_rdata
  );
    if ( !t.failed ) begin

      dut_imemreq_val   = imemreq_val;
      dut_imemreq_addr  = imemreq_addr;

      dut_dmemreq_val   = dmemreq_val;
      dut_dmemreq_type  = dmemreq_type;
      dut_dmemreq_addr  = dmemreq_addr;
      dut_dmemreq_wdata = dmemreq_wdata;

      #8;

      if ( t.n != 0 ) begin
        $write( "%3d: ", t.cycles );

        if ( imemreq_val )
          $write( "%x", imemreq_addr );
        else
          $write( "        " );

        $write( "|" );

        if ( dmemreq_val ) begin
          if ( dmemreq_type == 0 )
            $write( "rd:%x:        ", dmemreq_addr );
          else
            $write( "wr:%x:%x", dmemreq_addr, dmemreq_wdata );
        end
        else
          $write( "                    " );

        $write( " > " );

        if ( imemreq_val )
          $write( "%x", imemresp_data );
        else
          $write( "        " );

        $write( "|" );

        if ( dmemreq_val ) begin
          if ( dmemreq_type == 0 )
            $write( "%x", dmemresp_rdata );
        end
        else
          $write( "        " );

        $write( "\n" );
      end

      `ECE2300_CHECK_EQ_HEX( dut_imemresp_data,  imemresp_data  );
      `ECE2300_CHECK_EQ_HEX( dut_dmemresp_rdata, dmemresp_rdata );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );

    //     -------------- imem ------------ ---------------------- dmem ---------------------
    //     v  addr           data           v  t  addr           wdata          rdata
    check( 0, 32'h0000_0000, 'x,            0, 0, 32'h0000_0000, 32'h0000_0000, 'x            );
    check( 0, 32'h0000_0000, 'x,            1, 1, 32'h0000_0000, 32'h0000_0001, 'x            );
    check( 0, 32'h0000_0000, 'x,            1, 0, 32'h0000_0000, 32'h0000_0000, 32'h0000_0001 );

  endtask

  //----------------------------------------------------------------------
  // test_case_2_dmem
  //----------------------------------------------------------------------

  task test_case_2_dmem();
    t.test_case_begin( "test_case_2_dmem" );

    //     -------------- imem ------------ ---------------------- dmem ---------------------
    //     v  addr           data           v  t  addr           wdata          rdata
    check( 0, 32'h0000_0000, 'x,            0, 0, 32'h0000_0000, 32'h0000_0000, 'x            );

    check( 0, 32'h0000_0000, 'x,            1, 1, 32'h0000_0000, 32'h0000_0001, 'x            );
    check( 0, 32'h0000_0000, 'x,            1, 1, 32'h0000_0000, 32'h0000_0013, 'x            );
    check( 0, 32'h0000_0000, 'x,            1, 1, 32'h0000_0000, 32'h0000_0042, 'x            );

    check( 0, 32'h0000_0000, 'x,            0, 0, 32'h0000_0000, 32'h0000_0000, 'x            );

    check( 0, 32'h0000_0000, 'x,            1, 0, 32'h0000_0000, 32'h0000_0000, 32'h0000_0042 );
    check( 0, 32'h0000_0000, 'x,            1, 1, 32'h0000_0000, 32'h0000_0013, 'x            );
    check( 0, 32'h0000_0000, 'x,            1, 0, 32'h0000_0000, 32'h0000_0000, 32'h0000_0013 );
    check( 0, 32'h0000_0000, 'x,            1, 1, 32'h0000_0000, 32'h0000_0042, 'x            );
    check( 0, 32'h0000_0000, 'x,            1, 0, 32'h0000_0000, 32'h0000_0000, 32'h0000_0042 );

    check( 0, 32'h0000_0000, 'x,            0, 0, 32'h0000_0000, 32'h0000_0000, 'x            );

    check( 0, 32'h0000_0000, 'x,            1, 1, 32'h0000_0004, 32'h0000_0001, 'x            );
    check( 0, 32'h0000_0000, 'x,            1, 1, 32'h0000_0008, 32'h0000_0013, 'x            );
    check( 0, 32'h0000_0000, 'x,            1, 1, 32'h0000_000c, 32'h0000_0042, 'x            );

    check( 0, 32'h0000_0000, 'x,            0, 0, 32'h0000_0000, 32'h0000_0000, 'x            );

    check( 0, 32'h0000_0000, 'x,            1, 0, 32'h0000_0004, 32'h0000_0000, 32'h0000_0001 );
    check( 0, 32'h0000_0000, 'x,            1, 0, 32'h0000_0008, 32'h0000_0000, 32'h0000_0013 );
    check( 0, 32'h0000_0000, 'x,            1, 0, 32'h0000_000c, 32'h0000_0000, 32'h0000_0042 );

  endtask

  //----------------------------------------------------------------------
  // test_case_3_dmem_imem
  //----------------------------------------------------------------------

  task test_case_3_dmem_imem();
    t.test_case_begin( "test_case_3_dmem_imem" );

    //     -------------- imem ------------ ---------------------- dmem ---------------------
    //     v  addr           data           v  t  addr           wdata          rdata
    check( 0, 32'h0000_0000, 'x,            0, 0, 32'h0000_0000, 32'h0000_0000, 'x            );

    check( 0, 32'h0000_0000, 'x,            1, 1, 32'h0000_0000, 32'h0000_0001, 'x            );
    check( 0, 32'h0000_0000, 'x,            1, 1, 32'h0000_0000, 32'h0000_0013, 'x            );
    check( 0, 32'h0000_0000, 'x,            1, 1, 32'h0000_0000, 32'h0000_0042, 'x            );

    check( 0, 32'h0000_0000, 'x,            0, 0, 32'h0000_0000, 32'h0000_0000, 'x            );

    check( 1, 32'h0000_0000, 32'h0000_0042, 0, 0, 32'h0000_0042, 32'h0000_0000, 'x            );
    check( 0, 32'h0000_0000, 'x,            1, 1, 32'h0000_0000, 32'h0000_0013, 'x            );
    check( 1, 32'h0000_0000, 32'h0000_0013, 0, 0, 32'h0000_0013, 32'h0000_0000, 'x            );
    check( 0, 32'h0000_0000, 'x,            1, 1, 32'h0000_0000, 32'h0000_0042, 'x            );
    check( 1, 32'h0000_0000, 32'h0000_0042, 0, 0, 32'h0000_0042, 32'h0000_0000, 'x            );

    check( 0, 32'h0000_0000, 'x,            0, 0, 32'h0000_0000, 32'h0000_0000, 'x            );

    check( 0, 32'h0000_0000, 'x,            1, 1, 32'h0000_0004, 32'h0000_0001, 'x            );
    check( 0, 32'h0000_0000, 'x,            1, 1, 32'h0000_0008, 32'h0000_0013, 'x            );
    check( 0, 32'h0000_0000, 'x,            1, 1, 32'h0000_000c, 32'h0000_0042, 'x            );

    check( 0, 32'h0000_0000, 'x,            0, 0, 32'h0000_0000, 32'h0000_0000, 'x            );

    check( 1, 32'h0000_0004, 32'h0000_0001, 0, 0, 32'h0000_0000, 32'h0000_0000, 'x            );
    check( 1, 32'h0000_0008, 32'h0000_0013, 0, 0, 32'h0000_0000, 32'h0000_0000, 'x            );
    check( 1, 32'h0000_000c, 32'h0000_0042, 0, 0, 32'h0000_0000, 32'h0000_0000, 'x            );

  endtask

  //----------------------------------------------------------------------
  // test_case_4_simultaneous
  //----------------------------------------------------------------------

  task test_case_4_simultaneous();
    t.test_case_begin( "test_case_4_simultaneous" );

    //     -------------- imem ------------ ---------------------- dmem ---------------------
    //     v  addr           data           v  t  addr           wdata          rdata
    check( 0, 32'h0000_0000, 'x,            0, 0, 32'h0000_0000, 32'h0000_0000, 'x            );

    check( 0, 32'h0000_0000, 'x,            1, 1, 32'h0000_0000, 32'h0000_0001, 'x            );
    check( 1, 32'h0000_0000, 32'h0000_0001, 1, 1, 32'h0000_0000, 32'h0000_0013, 'x            );
    check( 1, 32'h0000_0000, 32'h0000_0013, 1, 1, 32'h0000_0000, 32'h0000_0042, 'x            );

    check( 0, 32'h0000_0000, 'x,            0, 0, 32'h0000_0000, 32'h0000_0000, 'x            );

  endtask

  //----------------------------------------------------------------------
  // test_case_5_asm
  //----------------------------------------------------------------------

  task test_case_5_asm();
    t.test_case_begin( "test_case_5_asm" );

    dut.asm( 32'h0000, "add  x1, x2, x3" );
    dut.asm( 32'h0004, "addi x1, x2, 1" );
    dut.asm( 32'h0008, "mul  x1, x2, x3" );
    dut.asm( 32'h000c, "lw   x1, 4(x2)" );
    dut.asm( 32'h0010, "sw   x1, 4(x2)" );

    `ECE2300_CHECK_EQ_HEX( dut.read( 32'h0000 ), 32'h003100b3 );
    `ECE2300_CHECK_EQ_HEX( dut.read( 32'h0004 ), 32'h00110093 );
    `ECE2300_CHECK_EQ_HEX( dut.read( 32'h0008 ), 32'h023100b3 );
    `ECE2300_CHECK_EQ_HEX( dut.read( 32'h000c ), 32'h00412083 );
    `ECE2300_CHECK_EQ_HEX( dut.read( 32'h0010 ), 32'h00112223 );

    //     -------------- imem ------------ ---------------------- dmem ---------------------
    //     v  addr           data           v  t  addr           wdata          rdata
    check( 1, 32'h0000_0000, 32'h0031_00b3, 0, 0, 32'h0000_0000, 32'h0000_0000, 'x            );
    check( 1, 32'h0000_0004, 32'h0011_0093, 0, 0, 32'h0000_0000, 32'h0000_0000, 'x            );
    check( 1, 32'h0000_0008, 32'h0231_00b3, 0, 0, 32'h0000_0000, 32'h0000_0000, 'x            );
    check( 1, 32'h0000_000c, 32'h0041_2083, 0, 0, 32'h0000_0000, 32'h0000_0000, 'x            );
    check( 1, 32'h0000_0010, 32'h0011_2223, 0, 0, 32'h0000_0000, 32'h0000_0000, 'x            );

  endtask

  //----------------------------------------------------------------------
  // test_case_6_random
  //----------------------------------------------------------------------

  logic        rand_imemreq_val;
  logic [31:0] rand_imemreq_addr;
  logic [31:0] rand_imemresp_data;
  logic        rand_dmemreq_val;
  logic        rand_dmemreq_type;
  logic [31:0] rand_dmemreq_addr;
  logic [31:0] rand_dmemreq_wdata;
  logic [31:0] rand_dmemresp_rdata;
  logic [31:0] rand_mem [32];

  task test_case_6_random();
    t.test_case_begin( "test_case_6_random" );

    // initialize memories with random data

    for ( int i = 0; i < 32; i = i+1 ) begin
      rand_mem[i] = 32'($urandom(t.seed));
      dut.write( 32'(i), rand_mem[i] );
    end

    // random test loop

    for ( int i = 0; i < 50; i = i+1 ) begin

      // Generate random values for all inputs

      rand_imemreq_val   = 1'($urandom(t.seed));
      rand_imemreq_addr  = { 27'b0, 5'($urandom(t.seed)) };
      rand_dmemreq_val   = 1'($urandom(t.seed));
      rand_dmemreq_type  = 1'($urandom(t.seed));
      rand_dmemreq_addr  = { 27'b0, 5'($urandom(t.seed)) };
      rand_dmemreq_wdata = 32'($urandom(t.seed));

      // Determine correct answer

      if ( rand_imemreq_val )
        rand_imemresp_data = rand_mem[rand_imemreq_addr];
      else
        rand_imemresp_data = 'x;

      if ( rand_dmemreq_val && (rand_dmemreq_type == 0) )
        rand_dmemresp_rdata = rand_mem[rand_dmemreq_addr];
      else
        rand_dmemresp_rdata = 'x;

      // Check DUT output matches correct answer

      check( rand_imemreq_val, rand_imemreq_addr, rand_imemresp_data,
             rand_dmemreq_val, rand_dmemreq_type, rand_dmemreq_addr,
             rand_dmemreq_wdata, rand_dmemresp_rdata );

      // Update reference memory

      if ( rand_dmemreq_val && (rand_dmemreq_type == 1) )
        rand_mem[rand_dmemreq_addr] = rand_dmemreq_wdata;

    end

  endtask

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin( `__FILE__ );

    if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();
    if ((t.n <= 0) || (t.n == 2)) test_case_2_dmem();
    if ((t.n <= 0) || (t.n == 3)) test_case_3_dmem_imem();
    if ((t.n <= 0) || (t.n == 4)) test_case_4_simultaneous();
    if ((t.n <= 0) || (t.n == 5)) test_case_5_asm();
    if ((t.n <= 0) || (t.n == 6)) test_case_6_random();

    t.test_bench_end();
  end

endmodule
