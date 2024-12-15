//========================================================================
// RegfileZ2r1w_32x32b_RTL
//========================================================================
// Register file with 32 32-bit entries, two read ports, and one write
// port. Reading register zero should always return zero. If waddr ==
// raddr then rdata should be the old data.

`ifndef REGFILE_Z_2R1W_32X32B_RTL
`define REGFILE_Z_2R1W_32X32B_RTL

module RegfileZ2r1w_32x32b_RTL
(
  (* keep=1 *) input  logic        clk,

  (* keep=1 *) input  logic        wen,
  (* keep=1 *) input  logic  [4:0] waddr,
  (* keep=1 *) input  logic [31:0] wdata,

  (* keep=1 *) input  logic  [4:0] raddr0,
  (* keep=1 *) output logic [31:0] rdata0,

  (* keep=1 *) input  logic  [4:0] raddr1,
  (* keep=1 *) output logic [31:0] rdata1
);
  // Write ports are sequential and should be implemented in a single
  // always_ff block, while read ports are combinational and should be
  // implemented in a separate always_comb block.

   // Register array (32 registers of 32 bits)
  logic [31:0] regfile [31:0];

  // Write port - sequential logic
  always_ff @(posedge clk) begin
    if (wen == 1'b1) begin
      regfile[waddr] <= wdata;
    end
  end


   // Read port 0 - combinational logic
  always_comb begin
    if (raddr0 == 5'b00000) begin
      rdata0 = 32'b0; // Register zero always returns zero
    end
    else if (wen && (waddr == raddr0)) begin
      rdata0 = regfile[raddr0]; // Return old data if waddr == raddr0
    end
    else begin
      rdata0 = regfile[raddr0]; // Normal read operation
    end
  end

   // Read port 1 - combinational logic
  always_comb begin
    if (raddr1 == 5'b00000) begin
      rdata1 = 32'b0; // Register zero always returns zero
    end
    else if (wen && (waddr == raddr1)) begin
      rdata1 = regfile[raddr1]; // Return old data if waddr == raddr1
    end
    else begin
      rdata1 = regfile[raddr1]; // Normal read operation
    end
  end


endmodule

`endif /* REGFILE_Z_2R1W_32x32b_RTL */

