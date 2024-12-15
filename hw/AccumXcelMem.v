//========================================================================
// AccumXcelMem.v
//========================================================================

`ifndef ACCUM_XCEL_MEM_V
`define ACCUM_XCEL_MEM_V

module AccumXcelMem
(
  (* keep=1 *) input  logic        clk,
  (* keep=1 *) input  logic        rst,

  (* keep=1 *) input  logic        memreq_val,
  (* keep=1 *) input  logic [15:0] memreq_addr,
  (* keep=1 *) output logic [31:0] memresp_data
);

  logic [31:0] mem [2**14];

  always_ff @(posedge clk) begin
    if ( rst ) begin
                           // addr  size result seven_seg
      mem[14'h0000] <= 36; // 0000     1     36  4
      mem[14'h0001] <= 26; // 0004     2     62 30
      mem[14'h0002] <= 69; // 0008     3    131  3
      mem[14'h0003] <= 57; // 000c     4    188 28
      mem[14'h0004] <= 11; // 0010     5    199  7
      mem[14'h0005] <= 68; // 0014     6    267 11
      mem[14'h0006] <= 41; // 0018     7    308 20
      mem[14'h0007] <= 90; // 001c     8    398 14
      mem[14'h0008] <= 32; // 0020     9    430 14
      mem[14'h0009] <= 76; // 0024    10    506 26
      mem[14'h000a] <= 44; // 0028    11    550  6
      mem[14'h000b] <= 19; // 002c    12    569 25
      mem[14'h000c] <= 17; // 0030    13    586 10
      mem[14'h000d] <= 59; // 0034    14    645  5
      mem[14'h000e] <= 99; // 0038    15    744  8
      mem[14'h000f] <= 49; // 003c    16    793 25
      mem[14'h0010] <= 65; // 0040    17    858 26
      mem[14'h0011] <= 12; // 0044    18    870  6
      mem[14'h0012] <= 55; // 0048    19    925 29
      mem[14'h0013] <=  0; // 004c    20    925 29
      mem[14'h0014] <= 51; // 0050    21    976 16
      mem[14'h0015] <= 42; // 0054    22   1018 26
      mem[14'h0016] <= 82; // 0058    23   1100 12
      mem[14'h0017] <= 23; // 005c    24   1123  3
      mem[14'h0018] <= 21; // 0060    25   1144 24
      mem[14'h0019] <= 54; // 0064    26   1198 14
      mem[14'h001a] <= 83; // 0068    27   1281  1
      mem[14'h001b] <= 31; // 006c    28   1312  0
      mem[14'h001c] <= 16; // 0070    29   1328 16
      mem[14'h001d] <= 76; // 0074    30   1404 28
      mem[14'h001e] <= 21; // 0078    31   1425 17
      mem[14'h001f] <=  4; // 007c    32   1429 21

    end
  end

  logic [1:0] memreq_addr_unused;
  assign memreq_addr_unused = memreq_addr[1:0];

  always_comb begin
    if ( memreq_val )
      memresp_data = mem[memreq_addr[15:2]];
    else
      memresp_data = 32'bx;
  end

endmodule

`endif /* ACCUM_XCEL_MEM_V */

