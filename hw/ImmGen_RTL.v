//========================================================================
// ImmGen_RTL
//========================================================================
// Generate immediate from a TinyRV1 instruction.
//
//  imm_type == 0 : I-type (ADDI)
//  imm_type == 1 : S-type (SW)
//  imm_type == 2 : J-type (JAL)
//  imm_type == 3 : B-type (BNE)
//

`ifndef IMM_GEN_RTL_V
`define IMM_GEN_RTL_V


module ImmGen_RTL
(
  (* keep=1 *) input  logic [31:0] inst,
  (* keep=1 *) input  logic  [1:0] imm_type,
  (* keep=1 *) output logic [31:0] imm
);

  always_comb begin 
    case (imm_type) 
      2'b00: imm = {{20{inst[31]}}, inst[31:20]};
      2'b01: imm =  {{20{inst[31]}}, inst[31:25], inst[11:7] };
      2'b10: imm =  { {12{inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0 };
      2'b11: imm = { {20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0 };
      default : imm = 32'd0;
    endcase
  end

  logic [6:0] wire_unused;
  assign wire_unused = inst [6:0];

endmodule

`endif /* IMM_GEN_RTL_V */

