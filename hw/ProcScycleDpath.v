//========================================================================
// ProcScycleDpath
//========================================================================

`ifndef PROC_SCYCLE_DPATH_V
`define PROC_SCYCLE_DPATH_V

`include "tinyrv1.v"
`include "Register_RTL.v"
`include "Adder_32b_GL.v"
`include "RegfileZ2r1w_32x32b_RTL.v"
`include "ALU_32b.v"
`include "ImmGen_RTL.v"
`include "Mux2_RTL.v"
`include "Mux4_RTL.v"
`include "Mux8_RTL.v"
`include "Multiplier_32x32b_RTL.v"

module ProcScycleDpath
(
  (* keep=1 *) input  logic        clk,
  (* keep=1 *) input  logic        rst,

  // Memory Interface

  (* keep=1 *) output logic        imemreq_val,
  (* keep=1 *) output logic [31:0] imemreq_addr,
  (* keep=1 *) input  logic [31:0] imemresp_data,

  (* keep=1 *) output logic        dmemreq_val,
  (* keep=1 *) output logic        dmemreq_type,
  (* keep=1 *) output logic [31:0] dmemreq_addr,
  (* keep=1 *) output logic [31:0] dmemreq_wdata,
  (* keep=1 *) input  logic [31:0] dmemresp_rdata,

  // I/O Interface

  (* keep=1 *) input  logic [31:0] in0,
  (* keep=1 *) input  logic [31:0] in1,
  (* keep=1 *) input  logic [31:0] in2,

  (* keep=1 *) output logic [31:0] out0,
  (* keep=1 *) output logic [31:0] out1,
  (* keep=1 *) output logic [31:0] out2,

  // Trace Interface

  (* keep=1 *) output logic        trace_val,
  (* keep=1 *) output logic [31:0] trace_addr,
  (* keep=1 *) output logic [31:0] trace_data,

  // Control Signals (Control Unit -> Datapath)

  (* keep=1 *) input  logic  [1:0] c2d_pc_sel,
  (* keep=1 *) input  logic  [1:0] c2d_imm_type,
  (* keep=1 *) input  logic        c2d_op2_sel,
  (* keep=1 *) input  logic        c2d_alu_func,
  (* keep=1 *) input  logic  [2:0] c2d_wb_sel,
  (* keep=1 *) input  logic        c2d_rf_wen,
  (* keep=1 *) input  logic        c2d_imemreq_val,
  (* keep=1 *) input  logic        c2d_dmemreq_val,
  (* keep=1 *) input  logic        c2d_dmemreq_type,
  (* keep=1 *) input  logic        c2d_out0_en,
  (* keep=1 *) input  logic        c2d_out1_en,
  (* keep=1 *) input  logic        c2d_out2_en,

  // Status Signals (Datapath -> Control Unit)

  (* keep=1 *) output logic [31:0] d2c_inst,
  (* keep=1 *) output logic        d2c_eq
);

  // We have provided you with the datapath for the ADDI instruction
  // below. You will need to modify this datapath to support the rest of
  // the TinyRV1 instruction set.

 
  logic [31:0] multiplier_mux_out;


  // out0 CSR Register
  Register_RTL#(32) outZeroReg
  (
    .clk (clk),
    .rst (rst),
    .en  (c2d_out0_en),
    .d   (multiplier_mux_out),
    .q   (out0)
  );

  // out1 CSR Register
  Register_RTL#(32) outOneReg
  (
    .clk (clk),
    .rst (rst),
    .en  (c2d_out1_en),
    .d   (multiplier_mux_out),
    .q   (out1)
  );

  // out2 CSR Register
  Register_RTL#(32) outTwoReg
  (
    .clk (clk),
    .rst (rst),
    .en  (c2d_out2_en),
    .d   (multiplier_mux_out),
    .q   (out2)
  );



  logic [31:0] in1_unused, in2_unused;
  assign in2_unused = in1;
  assign in1_unused = in2;

  logic c2d_out0_en_unused, c2d_out1_en_unused, c2d_out2_en_unused;
  assign c2d_out0_en_unused = c2d_out0_en;
  assign c2d_out1_en_unused = c2d_out1_en;
  assign c2d_out2_en_unused = c2d_out2_en;

  // Immediate Generation

  logic [31:0] immgen_imm;

  logic [31:0] inst;
  assign inst = imemresp_data;
  assign d2c_inst = inst;


  ImmGen_RTL immgen
  (
    .inst     (inst),
    .imm_type (c2d_imm_type),
    .imm      (immgen_imm)
   );


  // Fetch Logic

  logic [`TINYRV1_INST_RS1_NBITS-1:0] rs1;
  assign rs1 = inst[`TINYRV1_INST_RS1];
  
  logic [31:0] pc, pc_next;
  logic [31:0] pc_mux_out;

 // PC Register
  Register_RTL#(32) pc_reg
  (
    .clk (clk),
    .rst (rst),
    .en  (1'b1),
    .d   (pc_mux_out),
    .q   (pc)
  );

  assign imemreq_addr = pc;
  assign imemreq_val  = c2d_imemreq_val;

  Adder_32b_GL pc_adder
  (
    .in0 (pc),
    .in1 (32'd4),
    .sum (pc_next)
  );

  logic [31:0] jalbr_targ;

  Adder_32b_GL imm_adder
  (
    .in0(pc),
    .in1(immgen_imm),
    .sum(jalbr_targ)
  );

  logic [`TINYRV1_INST_RD_NBITS-1:0]  rd;

  logic [`TINYRV1_INST_RS2_NBITS-1:0] rs2;
  assign rs2 = inst[`TINYRV1_INST_RS2];
  assign rd  = inst[`TINYRV1_INST_RD];

  // Register File

  logic [31:0] rf_wdata;
  logic [31:0] rf_rdata0;
  logic [31:0] rf_rdata1;

  RegfileZ2r1w_32x32b_RTL rf
  (
    .clk    (clk),

    .wen    (c2d_rf_wen),
    .waddr  (rd),
    .wdata  (rf_wdata),

    .raddr0 (rs1),
    .rdata0 (rf_rdata0),

    .raddr1 (rs2),
    .rdata1 (rf_rdata1)
  );

  //Mux for PC

  Mux4_RTL 
  #(
    .p_nbits(32) 
  ) pc_mux (
    .in0(pc_next),
    .in1(jalbr_targ),
    .in2(rf_rdata0),
    .in3(32'd0),
    .sel(c2d_pc_sel),
    .out(pc_mux_out)
  );
  
  // Mux for ALU
  logic [31:0] alu_mux_out;

  Mux2_RTL 
  #(
    .p_nbits(32) 
  ) alu_mux (
    .in0(rf_rdata1),
    .in1(immgen_imm),
    .sel(c2d_op2_sel),
    .out(alu_mux_out)
  );

  // ALU

  logic [31:0] alu_out;

  ALU_32b alu
  (
    .in0 (rf_rdata0),
    .in1 (alu_mux_out),
    .op  (c2d_alu_func),
    .out (alu_out)
  );

  assign d2c_eq = alu_out[0];


  // Multiplier

  logic [31:0] multiplier_out;

  Multiplier_32x32b_RTL multiplier
  (
    .in0(rf_rdata0),
    .in1(rf_rdata1),
    .prod(multiplier_out)
  );

  // Load word and store

  assign dmemreq_wdata = rf_rdata1;
  assign dmemreq_addr  = alu_out;
  assign dmemreq_val = c2d_dmemreq_val;
  assign dmemreq_type = c2d_dmemreq_type;

  // Final Mux


  

  Mux8_RTL 
  #(
    .p_nbits(32) 
  ) multiplier_mux (
    .in0(multiplier_out),
    .in1(alu_out),
    .in2(pc_next),
    .in3(dmemresp_rdata),
    .in4(in0),
    .in5(in1),
    .in6(in2),
    .in7(rf_rdata0),
    .sel(c2d_wb_sel),
    .out(multiplier_mux_out)
  );

  assign rf_wdata = multiplier_mux_out;

  // Trace Output

  assign trace_val  = imemreq_val;
  assign trace_addr = pc;
  assign trace_data = rf_wdata;

  // logic [11:0] csr_addr;
  // assign csr_addr = inst[31:20]; // Extract the CSR address from the instruction


  




endmodule

`endif /* PROC_SCYCLE_DPATH_V */

