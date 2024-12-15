//========================================================================
// Proc-add-test-cases
//========================================================================

//------------------------------------------------------------------------
// test_case_1_basic
//------------------------------------------------------------------------

task test_case_1_basic();
  t.test_case_begin( "test_case_1_basic" );

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 2"  );
  asm( 'h004, "addi x2, x0, 3"  );
  asm( 'h008, "add  x3, x1, x2" );

  // Check each executed instruction

  check_trace( 'h000, 'h0000_0002 ); // addi x1, x0, 2
  check_trace( 'h004, 'h0000_0003 ); // addi x1, x0, 3
  check_trace( 'h008, 'h0000_0005 ); // add  x3, x1, x2

endtask

task test_case_2_directed();
  t.test_case_begin("test_case_2_directed");

  // Write assembly program with add instructions into memory

  asm('h000, "addi x1, x0, 5"   ); // x1 = 5
  asm('h004, "addi x2, x0, 10"  ); // x2 = 10
  asm('h008, "add  x3, x1, x2"  ); // x3 = x1 + x2 = 15
  asm('h00C, "add  x4, x3, x1"  ); // x4 = x3 + x1 = 20
  asm('h010, "add  x5, x4, x2"  ); // x5 = x4 + x2 = 30
  asm('h014, "add  x6, x5, x5"  ); // x6 = x5 + x5 = 60

  // Check each executed instruction

  check_trace('h000, 'h0000_0005); // addi x1, x0, 5
  check_trace('h004, 'h0000_000A); // addi x2, x0, 10
  check_trace('h008, 'h0000_000F); // add  x3, x1, x2 (5 + 10)
  check_trace('h00C, 'h0000_0014); // add  x4, x3, x1 (15 + 5)
  check_trace('h010, 'h0000_001E); // add  x5, x4, x2 (20 + 10)
  check_trace('h014, 'h0000_003C); // add  x6, x5, x5 (30 + 30)
  
endtask

