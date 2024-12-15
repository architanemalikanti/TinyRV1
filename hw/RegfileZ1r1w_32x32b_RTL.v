//========================================================================
// RegfileZ1r1w_32x32b_RTL
//========================================================================
// Register file with 32 32-bit entries, one read port, and one write
// port. Reading register zero should always return zero. If waddr ==
// raddr then rdata should be the old data.

`ifndef REGFILE_Z_1R1W_32X32B_RTL
`define REGFILE_Z_1R1W_32X32B_RTL

module RegfileZ1r1w_32x32b_RTL
(
  (* keep=1 *) input  logic        clk,

  (* keep=1 *) input  logic        wen,
  (* keep=1 *) input  logic  [4:0] waddr,
  (* keep=1 *) input  logic [31:0] wdata,

  (* keep=1 *) input  logic  [4:0] raddr,
  (* keep=1 *) output logic [31:0] rdata
);
  // Write ports are sequential and should be implemented in a single
  // always_ff block, while read ports are combinational and should be
  // implemented in a separate always_comb block.

    // Register array (32 registers of 32 bits)
  logic [31:0] regfile [31:0];

  // Write port - sequential logic
  always_ff @(posedge clk) begin
    if (wen && (waddr != 5'b00000)) begin
      regfile[waddr] <= wdata;
    end
  end

  // Read port - combinational logic
  always_comb begin
    if (raddr == 5'b00000) begin
      rdata = 32'b0; // Register zero always returns zero
    end
    else begin
      rdata = regfile[raddr]; // Normal read operation
    end
  end

endmodule

`endif /* REGFILE_Z_1R1W_32x32b_RTL */

