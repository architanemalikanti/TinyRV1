//========================================================================
// Proc-csr-test-cases
//========================================================================

//------------------------------------------------------------------------
// test_case_1_basic
//------------------------------------------------------------------------

task test_case_1_basic();
  t.test_case_begin( "test_case_1_basic" );

  // Set input ports

  proc_in0 = 32'hdeadbeef;
  proc_in1 = 'x;
  proc_in2 = 'x;

  // Write assembly program into memory

  asm( 'h000, "csrr x1, in0"  );
  asm( 'h004, "csrw out0, x1" );

  // Check each executed instruction

  check_trace( 'h000, 'hdeadbeef ); // csrr x1, in0
  check_trace( 'h004, 'x         ); // csrw out0, x1

  // Check output ports

  `ECE2300_CHECK_EQ_HEX( proc_out0, 'hdeadbeef );

endtask

//------------------------------------------------------------------------
// test_case_2_all_inout
//------------------------------------------------------------------------

task test_case_2_all_inout();
  t.test_case_begin( "test_case_2_all_inout" );

  // Set input ports

  proc_in0 = 32'hdeadbeef;
  proc_in1 = 32'hcafecafe;
  proc_in2 = 32'habcdabcd;

  // Write assembly program into memory

  asm( 'h000, "csrr x1, in0"  );
  asm( 'h004, "csrr x2, in1"  );
  asm( 'h008, "csrr x3, in2"  );
  asm( 'h00c, "csrw out0, x1" );
  asm( 'h010, "csrw out1, x2" );
  asm( 'h014, "csrw out2, x3" );

  // Check each executed instruction

  check_trace( 'h000, 'hdeadbeef ); // csrr x1, in0
  check_trace( 'h004, 'hcafecafe ); // csrr x2, in1
  check_trace( 'h008, 'habcdabcd ); // csrr x3, in2
  check_trace( 'h00c, 'x         ); // csrw out0, x1
  check_trace( 'h010, 'x         ); // csrw out1, x2
  check_trace( 'h014, 'x         ); // csrw out2, x3

  // Check output ports

  `ECE2300_CHECK_EQ_HEX( proc_out0, 'hdeadbeef );
  `ECE2300_CHECK_EQ_HEX( proc_out1, 'hcafecafe );
  `ECE2300_CHECK_EQ_HEX( proc_out2, 'habcdabcd );

endtask

//------------------------------------------------------------------------
// test_case_3_mix_inout
//------------------------------------------------------------------------

task test_case_3_mix_inout();
  t.test_case_begin( "test_case_3_mix_inout" );

  // Set input ports

  proc_in0 = 32'hdeadbeef;
  proc_in1 = 32'hcafecafe;
  proc_in2 = 32'habcdabcd;

  // Write assembly program into memory

  asm( 'h000, "csrr x1, in0"  );
  asm( 'h004, "csrr x2, in1"  );
  asm( 'h008, "csrr x3, in2"  );
  asm( 'h00c, "csrw out0, x3" );
  asm( 'h010, "csrw out1, x1" );
  asm( 'h014, "csrw out2, x2" );

  // Check each executed instruction

  check_trace( 'h000, 'hdeadbeef ); // csrr x1, in0
  check_trace( 'h004, 'hcafecafe ); // csrr x2, in1
  check_trace( 'h008, 'habcdabcd ); // csrr x3, in2
  check_trace( 'h00c, 'x         ); // csrw out0, x3
  check_trace( 'h010, 'x         ); // csrw out1, x1
  check_trace( 'h014, 'x         ); // csrw out2, x2

  // Check output ports

  `ECE2300_CHECK_EQ_HEX( proc_out0, 'habcdabcd );
  `ECE2300_CHECK_EQ_HEX( proc_out1, 'hdeadbeef );
  `ECE2300_CHECK_EQ_HEX( proc_out2, 'hcafecafe );

endtask

//------------------------------------------------------------------------
// test_case_4_operation
//------------------------------------------------------------------------

task test_case_4_operation();
  t.test_case_begin( "test_case_4_operation" );

  // Set input ports

  proc_in0 = 32'h10101010;
  proc_in1 = 32'h20202020;
  proc_in2 = 'x;

  // Write assembly program into memory

  asm( 'h000, "csrr x1, in0"    );
  asm( 'h004, "csrr x2, in1"    );
  asm( 'h008, "add  x3, x1, x2" );
  asm( 'h00c, "csrw out0, x3"   );

  // Check each executed instruction

  check_trace( 'h000, 'h10101010 ); // csrr x1, in0
  check_trace( 'h004, 'h20202020 ); // csrr x2, in1
  check_trace( 'h008, 'h30303030 ); // add  x3, x1, x2
  check_trace( 'h00c, 'x         ); // csrw out0, x3

  // Check output ports

  `ECE2300_CHECK_EQ_HEX( proc_out0, 'h30303030 );

endtask

//------------------------------------------------------------------------
// test_case_5_overwrite
//------------------------------------------------------------------------

task test_case_5_overwrite();
  t.test_case_begin( "test_case_5_overwrite" );

  // Set input ports

  proc_in0 = 32'h03030303;
  proc_in1 = 32'h04040404;
  proc_in2 = 'x;

  // Write assembly program into memory

  asm( 'h000, "csrr x1, in0"  );
  asm( 'h004, "csrw out0, x1" );
  asm( 'h008, "csrr x1, in1"  );
  asm( 'h00c, "csrw out0, x1" );

  // Check first two executed instructions

  check_trace( 'h000, 'h03030303 ); // csrr x1, in0
  check_trace( 'h004, 'x         ); // csrw out0, x1

  // Check current output port value

  `ECE2300_CHECK_EQ_HEX( proc_out0, 'h03030303 );

  // Check next two executed instructions

  check_trace( 'h008, 'h04040404 ); // csrr x1, in1
  check_trace( 'h00c, 'x         ); // csrw out0, x1

  // Check current output port value

  `ECE2300_CHECK_EQ_HEX( proc_out0, 'h04040404 );

endtask

// //------------------------------------------------------------------------
// // test_case_3_mix_inout
// //------------------------------------------------------------------------

// task test_case_3_mix_inout();
//   t.test_case_begin( "test_case_3_mix_inout" );

//   // Set input ports

//   proc_in0 = 32'hdeadbeef;
//   proc_in1 = 32'hcafecafe;
//   proc_in2 = 32'habcdabcd;

//   // Write assembly program into memory

//   asm( 'h000, "csrr x1, in0"  );
//   asm( 'h004, "csrr x2, in1"  );
//   asm( 'h008, "csrr x3, in2"  );
//   asm( 'h00c, "csrw out0, x3" );
//   asm( 'h010, "csrw out1, x1" );
//   asm( 'h014, "csrw out2, x2" );

//   // Check each executed instruction

//   check_trace( 'h000, 'hdeadbeef ); // csrr x1, in0
//   check_trace( 'h004, 'hcafecafe ); // csrr x2, in1
//   check_trace( 'h008, 'habcdabcd ); // csrr x3, in2
//   check_trace( 'h00c, 'x         ); // csrw out0, x3
//   check_trace( 'h010, 'x         ); // csrw out1, x1
//   check_trace( 'h014, 'x         ); // csrw out2, x2

//   // Check output ports

//   `ECE2300_CHECK_EQ_HEX( proc_out0, 'habcdabcd );
//   `ECE2300_CHECK_EQ_HEX( proc_out1, 'hdeadbeef );
//   `ECE2300_CHECK_EQ_HEX( proc_out2, 'hcafecafe );

// endtask

// //------------------------------------------------------------------------
// // test_case_4_operation
// //------------------------------------------------------------------------

// task test_case_4_operation();
//   t.test_case_begin( "test_case_4_operation" );

//   // Set input ports

//   proc_in0 = 32'h10101010;
//   proc_in1 = 32'h20202020;
//   proc_in2 = 'x;

//   // Write assembly program into memory

//   asm( 'h000, "csrr x1, in0"    );
//   asm( 'h004, "csrr x2, in1"    );
//   asm( 'h008, "add  x3, x1, x2" );
//   asm( 'h00c, "csrw out0, x3"   );

//   // Check each executed instruction

//   check_trace( 'h000, 'h10101010 ); // csrr x1, in0
//   check_trace( 'h004, 'h20202020 ); // csrr x2, in1
//   check_trace( 'h008, 'h30303030 ); // add  x3, x1, x2
//   check_trace( 'h00c, 'x         ); // csrw out0, x3

//   // Check output ports

//   `ECE2300_CHECK_EQ_HEX( proc_out0, 'h30303030 );

// endtask

// //------------------------------------------------------------------------
// // test_case_5_overwrite
// //------------------------------------------------------------------------

// task test_case_5_overwrite();
//   t.test_case_begin( "test_case_5_overwrite" );

//   // Set input ports

//   proc_in0 = 32'h03030303;
//   proc_in1 = 32'h04040404;
//   proc_in2 = 'x;

//   // Write assembly program into memory

//   asm( 'h000, "csrr x1, in0"  );
//   asm( 'h004, "csrw out0, x1" );
//   asm( 'h008, "csrr x1, in1"  );
//   asm( 'h00c, "csrw out0, x1" );

//   // Check first two executed instructions

//   check_trace( 'h000, 'h03030303 ); // csrr x1, in0
//   check_trace( 'h004, 'x         ); // csrw out0, x1

//   // Check current output port value

//   `ECE2300_CHECK_EQ_HEX( proc_out0, 'h03030303 );

//   // Check next two executed instructions

//   check_trace( 'h008, 'h04040404 ); // csrr x1, in1
//   check_trace( 'h00c, 'x         ); // csrw out0, x1

//   // Check current output port value

//   `ECE2300_CHECK_EQ_HEX( proc_out0, 'h04040404 );

// endtask

// //------------------------------------------------------------------------
// // test_case_3_mix_inout
// //------------------------------------------------------------------------

// task test_case_3_mix_inout();
//   t.test_case_begin( "test_case_3_mix_inout" );

//   // Set input ports

//   proc_in0 = 32'hdeadbeef;
//   proc_in1 = 32'hcafecafe;
//   proc_in2 = 32'habcdabcd;

//   // Write assembly program into memory

//   asm( 'h000, "csrr x1, in0"  );
//   asm( 'h004, "csrr x2, in1"  );
//   asm( 'h008, "csrr x3, in2"  );
//   asm( 'h00c, "csrw out0, x3" );
//   asm( 'h010, "csrw out1, x1" );
//   asm( 'h014, "csrw out2, x2" );

//   // Check each executed instruction

//   check_trace( 'h000, 'hdeadbeef ); // csrr x1, in0
//   check_trace( 'h004, 'hcafecafe ); // csrr x2, in1
//   check_trace( 'h008, 'habcdabcd ); // csrr x3, in2
//   check_trace( 'h00c, 'x         ); // csrw out0, x3
//   check_trace( 'h010, 'x         ); // csrw out1, x1
//   check_trace( 'h014, 'x         ); // csrw out2, x2

//   // Check output ports

//   `ECE2300_CHECK_EQ_HEX( proc_out0, 'habcdabcd );
//   `ECE2300_CHECK_EQ_HEX( proc_out1, 'hdeadbeef );
//   `ECE2300_CHECK_EQ_HEX( proc_out2, 'hcafecafe );

// endtask

// //------------------------------------------------------------------------
// // test_case_4_operation
// //------------------------------------------------------------------------

// task test_case_4_operation();
//   t.test_case_begin( "test_case_4_operation" );

//   // Set input ports

//   proc_in0 = 32'h10101010;
//   proc_in1 = 32'h20202020;
//   proc_in2 = 'x;

//   // Write assembly program into memory

//   asm( 'h000, "csrr x1, in0"    );
//   asm( 'h004, "csrr x2, in1"    );
//   asm( 'h008, "add  x3, x1, x2" );
//   asm( 'h00c, "csrw out0, x3"   );

//   // Check each executed instruction

//   check_trace( 'h000, 'h10101010 ); // csrr x1, in0
//   check_trace( 'h004, 'h20202020 ); // csrr x2, in1
//   check_trace( 'h008, 'h30303030 ); // add  x3, x1, x2
//   check_trace( 'h00c, 'x         ); // csrw out0, x3

//   // Check output ports

//   `ECE2300_CHECK_EQ_HEX( proc_out0, 'h30303030 );

// endtask

// //------------------------------------------------------------------------
// // test_case_5_overwrite
// //------------------------------------------------------------------------

// task test_case_5_overwrite();
//   t.test_case_begin( "test_case_5_overwrite" );

//   // Set input ports

//   proc_in0 = 32'h03030303;
//   proc_in1 = 32'h04040404;
//   proc_in2 = 'x;

//   // Write assembly program into memory

//   asm( 'h000, "csrr x1, in0"  );
//   asm( 'h004, "csrw out0, x1" );
//   asm( 'h008, "csrr x1, in1"  );
//   asm( 'h00c, "csrw out0, x1" );

//   // Check first two executed instructions

//   check_trace( 'h000, 'h03030303 ); // csrr x1, in0
//   check_trace( 'h004, 'x         ); // csrw out0, x1

//   // Check current output port value

//   `ECE2300_CHECK_EQ_HEX( proc_out0, 'h03030303 );

//   // Check next two executed instructions

//   check_trace( 'h008, 'h04040404 ); // csrr x1, in1
//   check_trace( 'h00c, 'x         ); // csrw out0, x1

//   // Check current output port value

//   `ECE2300_CHECK_EQ_HEX( proc_out0, 'h04040404 );

// endtask
