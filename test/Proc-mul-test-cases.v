//========================================================================
// Proc-mul-test-cases
//========================================================================

//------------------------------------------------------------------------
// test_case_1_basic
//------------------------------------------------------------------------

task test_case_1_basic();
  t.test_case_begin( "test_case_1_basic" );

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 2"  );
  asm( 'h004, "addi x2, x0, 3"  );
  asm( 'h008, "mul  x3, x1, x2" );

  // Check each executed instruction

  check_trace( 'h000, 'h0000_0002 ); // addi x1, x0, 2
  check_trace( 'h004, 'h0000_0003 ); // addi x1, x0, 3
  check_trace( 'h008, 'h0000_0006 ); // mul  x3, x1, x2

endtask

task test_case_2_directed();
  t.test_case_begin("test_case_2_directed");

  // Write assembly program with mul instructions into memory

  asm('h000, "addi x1, x0, 4"   ); // x1 = 4
  asm('h004, "addi x2, x0, 5"   ); // x2 = 5
  asm('h008, "mul  x3, x1, x2"  ); // x3 = x1 * x2 = 20
  asm('h00C, "addi x4, x0, -3"  ); // x4 = -3
  asm('h010, "mul  x5, x3, x4"  ); // x5 = x3 * x4 = -60
  asm('h014, "mul  x6, x4, x4"  ); // x6 = x4 * x4 = 9
  asm('h018, "addi x7, x0, 0"   ); // x7 = 0
  asm('h01C, "mul  x8, x7, x1"  ); // x8 = x7 * x1 = 0

  // Check each executed instruction

  check_trace('h000, 'h0000_0004); // addi x1, x0, 4
  check_trace('h004, 'h0000_0005); // addi x2, x0, 5
  check_trace('h008, 'h0000_0014); // mul  x3, x1, x2 (4 * 5)
  check_trace('h00C, 'hFFFF_FFFD); // addi x4, x0, -3
  check_trace('h010, 'hFFFF_FFC4); // mul  x5, x3, x4 (20 * -3 = -60)
  check_trace('h014, 'h0000_0009); // mul  x6, x4, x4 (-3 * -3 = 9)
  check_trace('h018, 'h0000_0000); // addi x7, x0, 0
  check_trace('h01C, 'h0000_0000); // mul  x8, x7, x1 (0 * 4 = 0)
  
endtask

