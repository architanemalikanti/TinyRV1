//========================================================================
// Proc-sw-test-cases
//========================================================================

//------------------------------------------------------------------------
// test_case_1_basic
//------------------------------------------------------------------------

task test_case_1_basic();
  t.test_case_begin( "test_case_1_basic" );

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 0x100" );
  asm( 'h004, "addi x2, x0, 0x42"  );
  asm( 'h008, "sw   x2, 0(x1)"     );
  asm( 'h00c, "lw   x3, 0(x1)"     );

  // Check each executed instruction

  check_trace( 'h000, 'h0000_0100 ); // addi x1, x0, 0x100
  check_trace( 'h004, 'h0000_0042 ); // addi x1, x0, 0x42
  check_trace( 'h008, 'x          ); // sw   x2, 0(x1)
  check_trace( 'h00c, 'h0000_0042 ); // lw   x3, 0(x1)

endtask

task test_case_2_directed();
  t.test_case_begin("test_case_2_directed");

  // Write assembly program with store word (sw) and load word (lw) instructions

  asm('h000, "addi x1, x0, 512"   ); // x1 = 512, base address
  asm('h004, "addi x2, x0, 85"    ); // x2 = 85, data to store
  asm('h008, "sw   x2, 0(x1)"     ); // Store x2 at address 512
  asm('h00C, "lw   x3, 0(x1)"     ); // Load word from 512 to x3
  
  asm('h010, "addi x4, x0, 171"   ); // x4 = 171, another data to store
  asm('h014, "addi x5, x1, 4"     ); // x5 = x1 + 4 = 516, new address
  asm('h018, "sw   x4, 0(x5)"     ); // Store x4 at address 516
  asm('h01C, "lw   x6, 0(x5)"     ); // Load word from 516 to x6
  
  // Check each executed instruction

  check_trace('h000, 'd512      ); // addi x1, x0, 512
  check_trace('h004, 'd85       ); // addi x2, x0, 85
  check_trace('h008, 'x         ); // sw   x2, 0(x1) - store to memory
  check_trace('h00C, 'd85       ); // lw   x3, 0(x1) - should load 85
  
  check_trace('h010, 'd171      ); // addi x4, x0, 171
  check_trace('h014, 'd516      ); // addi x5, x1, 4 (512 + 4)
  check_trace('h018, 'x         ); // sw   x4, 0(x5) - store to memory
  check_trace('h01C, 'd171      ); // lw   x6, 0(x5) - should load 171
endtask
