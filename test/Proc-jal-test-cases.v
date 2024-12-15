//========================================================================
// Proc-jal-test-cases
//========================================================================

//------------------------------------------------------------------------
// test_case_1_basic
//------------------------------------------------------------------------

task test_case_1_basic();
  t.test_case_begin( "test_case_1_basic" );

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 1" );
  asm( 'h004, "jal  x2, 0x00c" );
  asm( 'h008, "addi x1, x0, 2" );
  asm( 'h00c, "addi x1, x0, 3" );

  // Check each executed instruction

  check_trace( 'h000, 'h0000_0001 ); // addi x1, x0, 1
  check_trace( 'h004, 'h0000_0008 ); // jal  x2, 0x00c
  check_trace( 'h00c, 'h0000_0003 ); // addi x1, x0, 3

endtask

task test_case_2_jump();
  t.test_case_begin( "test_case_2_jump" );
  asm( 'h000, "jal  x2, 0x100" );   // Jump to 0x100, store 0x004 in x2
  asm( 'h004, "addi x1, x0, 9" );   // Should be skipped
  asm( 'h100, "addi x3, x0, 8" );   // Confirm jump lands here

  check_trace( 'h000, 'h0000_0004 ); // addi x1, x0, 1
  check_trace( 'h100, 'h0000_0008 ); // jal  x2, 0x00c
endtask

task test_case_3_directed();
  t.test_case_begin( "test_case_3_directed" );

  asm( 'h000, "addi x1, x0, 1" );      // Set x1 = 1, just an instruction before jal
  asm( 'h004, "jal  x2, 0x00c" );      // Jump to 0x014, store 0x00c in x2
  asm( 'h008, "addi x1, x0, 9" );      // This should be skipped
  asm( 'h00c, "addi x3, x0, 1" );      // Confirm we land here

  check_trace( 'h000, 'h0000_0001 );   // x1 = 1 after "addi x1, x0, 1"
  check_trace( 'h004, 'h0000_0008 );   // jal x2, 0x014 (no need to check register values)
  check_trace( 'h00c, 'h0000_0001 );   // x3 = 4 after "addi x3, x0, 4"

endtask

task test_case_4_multiple();
  t.test_case_begin( "test_case_4_multiple" );
  asm( 'h000, "jal  x2, 0x010" );   // Jump to 0x00c, store 0x004 in x2
  asm( 'h004, "addi x3, x0, 1" );     //Add 0 to x3
  asm( 'h008, "jal  x4, 0x014" );      //Add 0 to x3
  asm( 'h010, "jal  x3, 0x008" );   // Jump to 0x014, store 0x010 in x3
  asm( 'h014, "addi x3, x0, 2" );   // Confirm that we end here

  check_trace( 'h000, 'h0000_0004 ); // addi x1, x0, 1
  check_trace( 'h010, 'h0000_0014 ); // jal  x2, 0x00c
  check_trace( 'h008, 'h00c ); // jal x4, 0x014
  check_trace( 'h014, 'h0000_0002 ); // jal  x2, 0x00c
endtask
