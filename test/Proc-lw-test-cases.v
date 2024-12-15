//========================================================================
// Proc-lw-test-cases
//========================================================================

//------------------------------------------------------------------------
// test_case_1_basic
//------------------------------------------------------------------------

task test_case_1_basic();
  t.test_case_begin( "test_case_1_basic" );

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 0x100" );
  asm( 'h004, "lw   x2, 0(x1)"     );

  // Write data into memory

  data( 'h100, 'hdead_beef );

  // Check each executed instruction

  check_trace( 'h000, 'h0000_0100 ); // addi x1, x0, 0x100
  check_trace( 'h004, 'hdead_beef ); // lw   x2, 0(x1)

endtask

task test_case_2_directed();
  t.test_case_begin("test_case_2_directed");

  // Write assembly program with load word (lw) instructions into memory

  asm('h000, "addi x1, x0, 512" ); // x1 = 512
  asm('h004, "lw   x2, 0(x1)"     ); // x2 = Memory[512]
  asm('h008, "addi x3, x1, 16"  ); // x3 = x1 + 16 = 528
  asm('h00C, "lw   x4, 0(x3)"     ); // x4 = Memory[528]
  asm('h010, "addi x5, x3, -16" ); // x5 = x3 - 16 = 512
  asm('h014, "lw   x6, 4(x5)"     ); // x6 = Memory[516]

  // Write data into memory

  data('h200, 32'hcafebabe);   // Data at 0x200
  data('h210, 32'h12345678);   // Data at 0x210
  data('h204, 32'hbeefcafe);   // Data at 0x204

  // Check each executed instruction

  check_trace('h000, 'h0000_0200); // addi x1, x0, 512
  check_trace('h004, 'hcafebabe);  // lw   x2, 0(x1) -> loads data from 512
  check_trace('h008, 'h0000_0210); // addi x3, x1, 16
  check_trace('h00C, 'h12345678);  // lw   x4, 0(x3) -> loads data from 528
  check_trace('h010, 'h0000_0200); // addi x5, x3, -16
  check_trace('h014, 'hbeefcafe);  // lw   x6, 4(x5) -> loads data from 516

endtask


