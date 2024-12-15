//========================================================================
// proc-sim-prog2
//========================================================================

task proc_sim_prog2();

//x1 = in0, x2 = in1, x3 = buttons, x4 = result, x5 = 2

  asm( 'h000, "csrr x1, in0"   );
  asm( 'h004, "csrr x2, in1"   );
  asm( 'h008, "csrr x3, in2"    );

  asm( 'h00c, "csrw out0, x1"   );
  asm( 'h010, "csrw out1, x2"    );


  asm( 'h014, "addi x5, x0, 2"   );

  asm( 'h018, "bne  x3, x0, 0x024"   );
  //Addition
  asm( 'h01c, "add x4, x1, x2"   );
  asm( 'h020, "jal x0, 0x03c"   );

  //Subtraction 
  asm( 'h024, "bne  x3, x5, 0x038 "   );
  asm( 'h028, "addi x7, x0, -1"   );
  asm( 'h02c, "mul x6, x2, x7"   );
  asm( 'h030, "add x4, x1, x6"   );
  asm( 'h034, "jal x0, 0x03c "   );

  //Multiplication
  asm( 'h038, "mul x4, x1, x2"   );


  
  asm( 'h03c, "csrw out2, x4"   );
endtask
