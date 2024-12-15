//========================================================================
// AccumXcel-test
//========================================================================

`include "ece2300-test.v"
`include "AccumXcel.v"
`include "TestMemory.v"
`include "Adder_32b_GL.v"
`include "Register_RTL.v"
`include "Mux2_RTL.v"
`include "EqComparator_32b_RTL.v"

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

  logic        dut_go;
  logic [13:0] dut_size;
  logic        dut_result_val;
  logic [31:0] dut_result;

  logic        memreq_val;
  logic [15:0] memreq_addr;
  logic [31:0] memresp_data;


  AccumXcel xcel
  (
    .clk          (clk),
    .rst          (reset),
    .go           (dut_go),
    .size         (dut_size),
    .result_val   (dut_result_val),
    .result       (dut_result),
    .memreq_val   (memreq_val),
    .memreq_addr  (memreq_addr),
    .memresp_data (memresp_data)
  );

  logic [31:0] imemresp_data_unused;

  TestMemory mem
  (
    .clk             (clk),
    .rst             (reset),

    .imemreq_val     (1'b0),
    .imemreq_addr    ('x),
    .imemresp_data   (imemresp_data_unused),

    .dmemreq_val     (memreq_val),
    .dmemreq_type    (1'b0),
    .dmemreq_addr    ({16'b0,memreq_addr}),
    .dmemreq_wdata   ('x),
    .dmemresp_rdata  (memresp_data)
  );

  //----------------------------------------------------------------------
  // check
  //----------------------------------------------------------------------
  // All tasks start at #1 after the rising edge of the clock. So we
  // write the inputs #1 after the rising edge, and check the outputs #1
  // before the next rising edge.

  task check
  (
    input logic        go,
    input logic [13:0] size,
    input logic        result_val,
    input logic [31:0] result
  );
    if ( !t.failed ) begin

      dut_go   = go;
      dut_size = size;

      #8;

      if ( t.n != 0 ) begin
        $display( "%3d: %b %h (%10d) > %b %h (%10d)", t.cycles,
                  dut_go, dut_size, dut_size,
                  dut_result_val, dut_result, dut_result );
      end

      `ECE2300_CHECK_EQ    ( dut_result_val, result_val );
      `ECE2300_CHECK_EQ_HEX( dut_result,     result     );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // check_transaction
  //----------------------------------------------------------------------
  // Checks a complete transaction: (1) setting the size and go signal;
  // (2) waiting for result_val to go high; and (3) checking the final
  // result value.

  task check_transaction
  (
    input logic [13:0] size,
    input logic [31:0] result
  );
    if ( !t.failed ) begin

      dut_go   = 1;
      dut_size = size;

      #8;

      if ( t.n != 0 ) begin
        $display( "%3d: %b %h (%10d) > %b %h (%10d)", t.cycles,
                  dut_go, dut_size, dut_size,
                  dut_result_val, dut_result, dut_result );
      end

      while ( !dut_result_val ) begin
        #2;

        dut_go   = 0;
        dut_size = 'x;

        #8;

        if ( t.n != 0 ) begin
          $display( "%3d: %b %h (%10d) > %b %h (%10d)", t.cycles,
                    dut_go, dut_size, dut_size,
                    dut_result_val, dut_result, dut_result );
        end

      end

      if ( t.n != 0 ) begin
        $display( "%3d: %b %h (%10d) > %b %h (%10d)", t.cycles,
                  dut_go, dut_size, dut_size,
                  dut_result_val, dut_result, dut_result );
      end

      `ECE2300_CHECK_EQ    ( dut_result_val, 1      );
      `ECE2300_CHECK_EQ_HEX( dut_result,     result );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // init_mem
  //----------------------------------------------------------------------

  task init_mem();
    mem.write( 'h0000, 'h0001 );
    mem.write( 'h0004, 'h0002 );
    mem.write( 'h0008, 'h0003 );
    mem.write( 'h000c, 'h0004 );
    mem.write( 'h0010, 'h0005 );
    mem.write( 'h0014, 'h0006 );
    mem.write( 'h0018, 'h0007 );
    mem.write( 'h001c, 'h0008 );
    mem.write( 'h0020, 'h0009 );
    mem.write( 'h0024, 'h000a );
    mem.write( 'h0028, 'h000b );
    mem.write( 'h002c, 'h000c );
    mem.write( 'h0030, 'h000d );
    mem.write( 'h0034, 'h000e );
    mem.write( 'h0038, 'h000f );
    mem.write( 'h003c, 'h0010 );
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );
    init_mem();

    //     go size val result
    check( 0, 'x,  'x, 'x );
    check( 1, 4,   'x, 'x );
    check( 0, 'x,  'x, 'x );
    check( 0, 'x,  'x, 'x );
    check( 0, 'x,  'x, 'x );
    check( 0, 'x,  'x, 'x );
    check( 0, 'x,  'x, 'x );
    check( 0, 'x,  'x, 'x );

  endtask

  //----------------------------------------------------------------------
  // test_case_2_size1
  //----------------------------------------------------------------------

  task test_case_2_size1();
    t.test_case_begin( "test_case_2_size1" );
    init_mem();
    check_transaction( 1, 1 );
  endtask

  //----------------------------------------------------------------------
  // test_case_3_size2
  //----------------------------------------------------------------------

  task test_case_3_size2();
    t.test_case_begin( "test_case_3_size2" );
    init_mem();
    check_transaction( 2, 3 ); // 1 + 2 = 3
  endtask

  //----------------------------------------------------------------------
  // test_case_4_size3
  //----------------------------------------------------------------------

  task test_case_4_size3();
    t.test_case_begin( "test_case_4_size3" );
    init_mem();
    check_transaction( 3, 6 ); // 1 + 2 + 3 = 6
  endtask

  //----------------------------------------------------------------------
  // test_case_5_size8
  //----------------------------------------------------------------------

  task test_case_5_size8();
    t.test_case_begin( "test_case_5_size8" );
    init_mem();
    check_transaction( 8, 36 ); // 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 = 36
  endtask

  //----------------------------------------------------------------------
  // test_case_6_size15
  //----------------------------------------------------------------------

  task test_case_6_size15();
    t.test_case_begin( "test_case_6_size15" );
    init_mem();
    check_transaction( 15, 120 );
  endtask

  //----------------------------------------------------------------------
  // test_case_7_size16
  //----------------------------------------------------------------------

  task test_case_7_size16();
    t.test_case_begin( "test_case_7_size16" );
    init_mem();
    check_transaction( 16, 136 );
  endtask

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin( `__FILE__ );

    if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();
    if ((t.n <= 0) || (t.n == 2)) test_case_2_size1();
    if ((t.n <= 0) || (t.n == 3)) test_case_3_size2();
    if ((t.n <= 0) || (t.n == 4)) test_case_4_size3();
    if ((t.n <= 0) || (t.n == 5)) test_case_5_size8();
    if ((t.n <= 0) || (t.n == 6)) test_case_6_size15();
    if ((t.n <= 0) || (t.n == 7)) test_case_7_size16();

    t.test_bench_end();
  end

endmodule



// //========================================================================
// // AccumXcel-test
// //========================================================================

// `include "ece2300-test.v"
// `include "AccumXcel.v"
// `include "TestMemory.v"
// `include "Adder_32b_GL.v"
// `include "Register_RTL.v"
// `include "Mux2_RTL.v"

// module Top();

//   //----------------------------------------------------------------------
//   // Setup
//   //----------------------------------------------------------------------

//   // verilator lint_off UNUSED
//   logic clk;
//   logic reset;
//   // verilator lint_on UNUSED

//   ece2300_TestUtils t( .* );

//   //----------------------------------------------------------------------
//   // Instantiate design under test
//   //----------------------------------------------------------------------

//   logic        dut_go;
//   // logic [13:0] dut_size;
//   // logic        dut_result_val;
//   // logic [31:0] dut_result;

//   logic        memreq_val;
//   logic [15:0] memreq_addr;
//   logic [31:0] memresp_data_unused;

//   AccumXcel xcel
//   (
//     .clk          (clk),
//     .rst          (reset),
//     .go           (dut_go),
//     // .size         (dut_size),
//     // .result_val   (dut_result_val),
//     // .result       (dut_result),
//     .memreq_val   (memreq_val),
//     .memreq_addr  (memreq_addr)
//     // .memresp_data (memresp_data_unused)
//   );

//   logic [31:0] imemresp_data_unused;



//   TestMemory mem
//   (
//     .clk             (clk),
//     .rst             (reset),

//     .imemreq_val     (1'b0),
//     .imemreq_addr    ('x),
//     .imemresp_data   (imemresp_data_unused),

//     .dmemreq_val     (memreq_val),
//     .dmemreq_type    (1'b0),
//     .dmemreq_addr    ({16'b0,memreq_addr}),
//     .dmemreq_wdata   ('x),
//     .dmemresp_rdata  (memresp_data_unused)
//   );

//   //----------------------------------------------------------------------
//   // check
//   //----------------------------------------------------------------------
//   // All tasks start at #1 after the rising edge of the clock. So we
//   // write the inputs #1 after the rising edge, and check the outputs #1
//   // before the next rising edge.

//   task check
//   (
//     input logic        go
//     // input logic [13:0] size,
//     // input logic        result_val,
//     // input logic [31:0] result
//   );
//     if ( !t.failed ) begin

//       dut_go   = go;
//       // dut_size = size;

//       #8;

//       if ( t.n != 0 ) begin
//         $display( "%3d: go = %b", t.cycles, dut_go );
//       end

//       // `ECE2300_CHECK_EQ    ( dut_result_val, result_val );
//       // `ECE2300_CHECK_EQ_HEX( dut_result,     result     );

//       #2;

//     end
//   endtask

//   //----------------------------------------------------------------------
//   // check_transaction
//   //----------------------------------------------------------------------
//   // Checks a complete transaction: (1) setting the size and go signal;
//   // (2) waiting for result_val to go high; and (3) checking the final
//   // result value.

//   // task check_transaction
//   // (
//   //   input logic [13:0] size,
//   //   input logic [31:0] result
//   // );
//   //   if ( !t.failed ) begin

//   //     dut_go   = 1;
//   //     dut_size = size;

//   //     #8;

//   //     if ( t.n != 0 ) begin
//   //       $display( "%3d: %b %h (%10d) > %b %h (%10d)", t.cycles,
//   //                 dut_go, dut_size, dut_size,
//   //                 dut_result_val, dut_result, dut_result );
//   //     end

//   //     while ( !dut_result_val ) begin
//   //       #2;

//   //       dut_go   = 0;
//   //       dut_size = 'x;

//   //       #8;

//   //       if ( t.n != 0 ) begin
//   //         $display( "%3d: %b %h (%10d) > %b %h (%10d)", t.cycles,
//   //                   dut_go, dut_size, dut_size,
//   //                   dut_result_val, dut_result, dut_result );
//   //       end

//   //     end

//   //     if ( t.n != 0 ) begin
//   //       $display( "%3d: %b %h (%10d) > %b %h (%10d)", t.cycles,
//   //                 dut_go, dut_size, dut_size,
//   //                 dut_result_val, dut_result, dut_result );
//   //     end

//   //     `ECE2300_CHECK_EQ    ( dut_result_val, 1      );
//   //     `ECE2300_CHECK_EQ_HEX( dut_result,     result );

//   //     #2;

//   //   end
//   // endtask

//   //----------------------------------------------------------------------
//   // init_mem
//   //----------------------------------------------------------------------

//   task init_mem();
//     mem.write( 'h0000, 'h0001 );
//     mem.write( 'h0004, 'h0002 );
//     mem.write( 'h0008, 'h0003 );
//     mem.write( 'h000c, 'h0004 );
//     mem.write( 'h0010, 'h0005 );
//     mem.write( 'h0014, 'h0006 );
//     mem.write( 'h0018, 'h0007 );
//     mem.write( 'h001c, 'h0008 );
//     mem.write( 'h0020, 'h0009 );
//     mem.write( 'h0024, 'h000a );
//     mem.write( 'h0028, 'h000b );
//     mem.write( 'h002c, 'h000c );
//     mem.write( 'h0030, 'h000d );
//     mem.write( 'h0034, 'h000e );
//     mem.write( 'h0038, 'h000f );
//     mem.write( 'h003c, 'h0010 );
//   endtask

//   //----------------------------------------------------------------------
//   // test_case_1_basic
//   //----------------------------------------------------------------------

//   task test_case_1_basic();
//     t.test_case_begin( "test_case_1_basic" );
//     init_mem();

//     //     go size val result
//     check( 0 );
//     check( 1 );
//     check( 0 );
//     check( 0 );
//     check( 0 );
//     check( 0 );
//     check( 0 );
//     check( 0 );


//   endtask

//   //----------------------------------------------------------------------
//   // test_case_2_size1
//   //----------------------------------------------------------------------

//   // task test_case_2_size1();
//   //   t.test_case_begin( "test_case_2_size1" );
//   //   init_mem();
//   //   check_transaction( 1, 1 );
//   // endtask

//   // //----------------------------------------------------------------------
//   // // test_case_3_size2
//   // //----------------------------------------------------------------------

//   // task test_case_3_size2();
//   //   t.test_case_begin( "test_case_3_size2" );
//   //   init_mem();
//   //   check_transaction( 2, 3 ); // 1 + 2 = 3
//   // endtask

//   // //----------------------------------------------------------------------
//   // // test_case_4_size3
//   // //----------------------------------------------------------------------

//   // task test_case_4_size3();
//   //   t.test_case_begin( "test_case_4_size3" );
//   //   init_mem();
//   //   check_transaction( 3, 6 ); // 1 + 2 + 3 = 6
//   // endtask

//   // //----------------------------------------------------------------------
//   // // test_case_5_size8
//   // //----------------------------------------------------------------------

//   // task test_case_5_size8();
//   //   t.test_case_begin( "test_case_5_size8" );
//   //   init_mem();
//   //   check_transaction( 8, 36 ); // 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 = 36
//   // endtask

//   // //----------------------------------------------------------------------
//   // // test_case_6_size15
//   // //----------------------------------------------------------------------

//   // task test_case_6_size15();
//   //   t.test_case_begin( "test_case_6_size15" );
//   //   init_mem();
//   //   check_transaction( 15, 120 );
//   // endtask

//   // //----------------------------------------------------------------------
//   // // test_case_7_size16
//   // //----------------------------------------------------------------------

//   // task test_case_7_size16();
//   //   t.test_case_begin( "test_case_7_size16" );
//   //   init_mem();
//   //   check_transaction( 16, 136 );
//   // endtask

//   //----------------------------------------------------------------------
//   // main
//   //----------------------------------------------------------------------

//   initial begin
//     t.test_bench_begin( `__FILE__ );

//     if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();
//     // if ((t.n <= 0) || (t.n == 2)) test_case_2_size1();
//     // if ((t.n <= 0) || (t.n == 3)) test_case_3_size2();
//     // if ((t.n <= 0) || (t.n == 4)) test_case_4_size3();
//     // if ((t.n <= 0) || (t.n == 5)) test_case_5_size8();
//     // if ((t.n <= 0) || (t.n == 6)) test_case_6_size15();
//     // if ((t.n <= 0) || (t.n == 7)) test_case_7_size16();

//     t.test_bench_end();
//   end

// endmodule
