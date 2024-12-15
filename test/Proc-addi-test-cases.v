//========================================================================
// Proc-addi-test-cases
//========================================================================

//------------------------------------------------------------------------
// test_case_1_basic
//------------------------------------------------------------------------

task test_case_1_basic();
  t.test_case_begin( "test_case_1_basic" );

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 2"   );
  asm( 'h004, "addi x2, x1, 2"   );

  // Check each executed instruction

  check_trace( 'h000, 'h0000_0002 ); // addi x1, x0, 2
  check_trace( 'h004, 'h0000_0004 ); // addi x2, x1, 2

endtask

task test_case_2_directed();
  t.test_case_begin( "test_case_2_directed" );

  // Write additional addi instructions into memory
  asm( 'h000, "addi x3, x0, 5"   ); // x3 = 0 + 5 = 5
  asm( 'h004, "addi x4, x3, 10"  ); // x4 = x3 + 10 = 15
  asm( 'h008, "addi x5, x4, -3"  ); // x5 = x4 - 3 = 12
  asm( 'h00C, "addi x6, x5, 4"   ); // x6 = x5 + 4 = 16

  // Check each executed instruction
  check_trace( 'h000, 'h0000_0005 ); // addi x3, x0, 5
  check_trace( 'h004, 'h0000_000F ); // addi x4, x3, 10
  check_trace( 'h008, 'h0000_000C ); // addi x5, x4, -3
  check_trace( 'h00C, 'h0000_0010 ); // addi x6, x5, 4

endtask

