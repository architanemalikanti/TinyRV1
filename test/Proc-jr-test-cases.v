//========================================================================
// Proc-jr-test-cases
//========================================================================

//------------------------------------------------------------------------
// test_case_1_basic
//------------------------------------------------------------------------

task test_case_1_basic();
  t.test_case_begin( "test_case_1_basic" );

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 0x00c" );
  asm( 'h004, "jr   x1" );
  asm( 'h008, "addi x1, x0, 2" );
  asm( 'h00c, "addi x1, x0, 3" );

  // Check each executed instruction

  check_trace( 'h000, 'h0000_000c ); // addi x1, x0, 0x00c
  check_trace( 'h004, 'x          ); // jr   x1
  check_trace( 'h00c, 'h0000_0003 ); // addi x1, x0, 3

endtask

task test_case_2_directed();
  t.test_case_begin( "test_case_2_directed" );

  asm( 'h000, "addi x1, x0, 0x010" );  // Set x1 = 0x010
  asm( 'h004, "jr   x1" );              // Jump to address stored in x1 (0x010)
  asm( 'h008, "addi x1, x0, 2" );      // This should be skipped
  asm( 'h010, "addi x3, x0, 4" );      // Confirm we land here at 0x010

  check_trace( 'h000, 'h0000_0010 ); // addi x1, x0, 0x00c
  check_trace( 'h004, 'x          ); // jr   x1
  check_trace( 'h010, 'h0000_0004 ); // addi x1, x0, 3
endtask

task test_case_3_directed();
  t.test_case_begin( "test_case_3_directed" );

  asm( 'h000, "addi x1, x0, 0x008" );  // Set x1 = 0x008
  asm( 'h004, "mul x2, x1, x0" );      // Confirm final branch lands here
  asm( 'h008, "jr   x2" );              // Jump back to 0x008
  asm( 'h00c, "addi x3, x0, 4" );      // Confirm jump lands back at 0x008

  check_trace( 'h000, 'h0000_0008 ); // addi x1, x0, 0x00c
  check_trace( 'h004, 'h0000_0000 );
  check_trace( 'h008, 'x          ); // jr   x1
  check_trace( 'h000, 'h0000_0008 ); // addi x1, x0, 3
endtask

