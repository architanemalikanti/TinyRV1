//========================================================================
// Proc-bne-test-cases
//========================================================================

//------------------------------------------------------------------------
// test_case_1_basic
//------------------------------------------------------------------------

task test_case_1_basic();
  t.test_case_begin( "test_case_1_basic" );

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 1" );
  asm( 'h004, "bne  x1, x0, 0x00c" );
  asm( 'h008, "addi x1, x0, 2" );
  asm( 'h00c, "addi x1, x0, 3" );

  // Check each executed instruction

  check_trace( 'h000, 'h0000_0001 ); // addi x1, x0, 1
  check_trace( 'h004, 'x          ); // bne  x1, x0, 0x00c
  check_trace( 'h00c, 'h0000_0003 ); // addi x1, x0, 3

endtask

task test_case_2_no_branch();
  t.test_case_begin( "test_case_2_no_branch" );

  asm( 'h000, "addi x1, x0, 1" );
  asm( 'h004, "addi x2, x0, 1" );
  asm( 'h008, "bne  x1, x2, 0x010" );  // Should not branch since x1 == x2
  asm( 'h00c, "addi x3, x0, 2" );      // Execution should continue here
  asm( 'h010, "addi x1, x0, 5" );      // Verify we skip this address
  

  check_trace( 'h000, 'h0000_0001 ); // addi x1, x0, 1
  check_trace( 'h004, 'h0000_0001 ); // addi x2, x0, 1
  check_trace( 'h008, 'x          ); // bne  x1, x0, 0x012 cause it fails
  check_trace( 'h00c, 'h0000_0002 ); // addi x3, x0, 3

endtask

task test_case_3_multiple();
  t.test_case_begin( "test_case_3_multiple" );

  asm( 'h000, "addi x1, x0, 1" );
  asm( 'h004, "addi x2, x0, 2" );
  asm( 'h008, "bne  x1, x0, 0x010" );  // Should branch
  asm( 'h00c, "addi x1, x0, 1" );
  asm( 'h010, "bne  x1, x2, 0x018" );  // Should branch again
  asm( 'h014, "addi x3, x0, 2" );      // Execution should continue here
  asm( 'h018, "mul x4, x1, x2" );      // Confirm final branch lands here

  check_trace( 'h000, 'h0000_0001 ); // addi x1, x0, 1
  check_trace( 'h004, 'h0000_0002 ); // addi x2, x0, 1
  check_trace( 'h008, 'x          ); // bne  x1, x0, 0x00c
  check_trace( 'h010, 'x );
  check_trace( 'h018, 'h0000_0002 );

endtask
