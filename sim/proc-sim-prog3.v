// //========================================================================
// // proc-sim-prog3
// //========================================================================

// task proc_sim_prog3();

//   // set out1 to zero

//   asm( 'h000, "csrw out1, x0"      );

//   // wait for go

//   asm( 'h004, "csrr x1, in0"       );
//   asm( 'h008, "csrr x2, in2"       );
//   asm( 'h00c, "addi x3, x0, 1"     );
//   asm( 'h010, "bne  x2, x3, 0x004" );

//   // display size

//   asm( 'h014, "csrw out0, x1" );

//   // fill in the accumulate loop here
//   asm( 'h018, "addi x3, x0, 0"     ); //x3 = sum
//   asm( 'h01c, "addi x4, x0, 0"     ); //x4 = counter
//   asm( 'h020, "addi x5, x0, 0"     ); //x5 = memreq_addr

//   asm( 'h024, "bne x4, x1, 0x030"     ); 

//   // done (result in x3)
//   asm( 'h028, "csrw out1, x3"      ); 
//   asm( 'h02c, "jal  x0, 0x044"     ); 

//   //incrementing sum
//   asm( 'h030, "lw x6, 0(x5)"     ); //x6 = memresp_data
//   asm( 'h034, "add x3, x3, x6"     ); //
//   asm( 'h038, "addi x5, x5, 4"     );
//   asm( 'h03c, "addi x4, x4, 1"     );
//   asm( 'h040, "jal x0, 0x024"     );

//   //while true : pass
//   asm( 'h044, "addi x7, x0, 1"     ); //x7 =1
//   asm( 'h048, "bne x7, x0, 0x048"     );




  

  

//   // Input array

//                      //  size result seven_seg
//   data( 'h080, 36 ); //     1     36  4
//   data( 'h084, 26 ); //     2     62 30
//   data( 'h088, 69 ); //     3    131  3
//   data( 'h08c, 57 ); //     4    188 28
//   data( 'h090, 11 ); //     5    199  7
//   data( 'h094, 68 ); //     6    267 11
//   data( 'h098, 41 ); //     7    308 20
//   data( 'h09c, 90 ); //     8    398 14
//   data( 'h0a0, 32 ); //     9    430 14
//   data( 'h0a4, 76 ); //    10    506 26
//   data( 'h0a8, 44 ); //    11    550  6
//   data( 'h0ac, 19 ); //    12    569 25
//   data( 'h0b0, 17 ); //    13    586 10
//   data( 'h0b4, 59 ); //    14    645  5
//   data( 'h0b8, 99 ); //    15    744  8
//   data( 'h0bc, 49 ); //    16    793 25
//   data( 'h0c0, 65 ); //    17    858 26
//   data( 'h0c4, 12 ); //    18    870  6
//   data( 'h0c8, 55 ); //    19    925 29
//   data( 'h0cc,  0 ); //    20    925 29
//   data( 'h0d0, 51 ); //    21    976 16
//   data( 'h0d4, 42 ); //    22   1018 26
//   data( 'h0d8, 82 ); //    23   1100 12
//   data( 'h0dc, 23 ); //    24   1123  3
//   data( 'h0e0, 21 ); //    25   1144 24
//   data( 'h0e4, 54 ); //    26   1198 14
//   data( 'h0e8, 83 ); //    27   1281  1
//   data( 'h0ec, 31 ); //    28   1312  0
//   data( 'h0f0, 16 ); //    29   1328 16
//   data( 'h0f4, 76 ); //    30   1404 28
//   data( 'h0f8, 21 ); //    31   1425 17
//   data( 'h0fc,  4 ); //    32   1429 21

// endtask


//========================================================================
// proc-sim-prog3
//========================================================================


task proc_sim_prog3();

  // set out1 to zero

  asm( 'h000, "csrw out1, x0"      );

  // wait for go

  asm( 'h004, "csrr x1, in0"       );
  asm( 'h008, "csrr x2, in2"       );
  asm( 'h00c, "addi x3, x0, 1"     );
  asm( 'h010, "bne  x2, x3, 0x004" );

  // display size

  asm( 'h014, "csrw out0, x1" ); //x1 is the size

  // fill in the accumulate loop here

  asm( 'h018, "addi x5, x0, 0");
  asm( 'h01c, "addi x9, x0, 0"); //x9 is the count register that we initially set to 0
  asm( 'h020, "addi x8, x0, 0x80"); //Address Register
  asm( 'h024, "lw x4, 0(x8)"); 

  //asm( 'h024, "bne x9, x1, 0x034");
  asm( 'h028, "addi x9, x9, 1");
  asm( 'h02c, "addi x8, x8, 4");
  asm( 'h030, "add x5, x4, x5");
  asm( 'h034, "bne x9, x1, 0x024");
  //asm( 'h030, "jal x0, 0x020");

  // done (assumes result is in x4)

  asm( 'h038, "csrw out1, x5"      ); // set address appropriately
  asm( 'h03c, "jal x0, 0x03c"     ); // set address appropriately

  // Input array

                     //  size result seven_seg
  data( 'h080, 36 ); //     1     36  4
  data( 'h084, 26 ); //     2     62 30
  data( 'h088, 69 ); //     3    131  3
  data( 'h08c, 57 ); //     4    188 28
  data( 'h090, 11 ); //     5    199  7
  data( 'h094, 68 ); //     6    267 11
  data( 'h098, 41 ); //     7    308 20
  data( 'h09c, 90 ); //     8    398 14
  data( 'h0a0, 32 ); //     9    430 14
  data( 'h0a4, 76 ); //    10    506 26
  data( 'h0a8, 44 ); //    11    550  6
  data( 'h0ac, 19 ); //    12    569 25
  data( 'h0b0, 17 ); //    13    586 10
  data( 'h0b4, 59 ); //    14    645  5
  data( 'h0b8, 99 ); //    15    744  8
  data( 'h0bc, 49 ); //    16    793 25
  data( 'h0c0, 65 ); //    17    858 26
  data( 'h0c4, 12 ); //    18    870  6
  data( 'h0c8, 55 ); //    19    925 29
  data( 'h0cc,  0 ); //    20    925 29
  data( 'h0d0, 51 ); //    21    976 16
  data( 'h0d4, 42 ); //    22   1018 26
  data( 'h0d8, 82 ); //    23   1100 12
  data( 'h0dc, 23 ); //    24   1123  3
  data( 'h0e0, 21 ); //    25   1144 24
  data( 'h0e4, 54 ); //    26   1198 14
  data( 'h0e8, 83 ); //    27   1281  1
  data( 'h0ec, 31 ); //    28   1312  0
  data( 'h0f0, 16 ); //    29   1328 16
  data( 'h0f4, 76 ); //    30   1404 28
  data( 'h0f8, 21 ); //    31   1425 17
  data( 'h0fc,  4 ); //    32   1429 21

endtask

