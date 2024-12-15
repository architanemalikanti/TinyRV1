//========================================================================
// ProcScycle
//========================================================================

`ifndef PROC_SCYCLE_V
`define PROC_SCYCLE_V

`include "ProcScycleDpath.v"
`include "ProcScycleCtrl.v"

module ProcScycle
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
  (* keep=1 *) output logic [31:0] trace_data
);

  // Control Signals (Control Unit -> Datapath)

  logic  [1:0] c2d_pc_sel;
  logic  [1:0] c2d_imm_type;
  logic        c2d_op2_sel;
  logic        c2d_alu_func;
  logic  [2:0] c2d_wb_sel;
  logic        c2d_rf_wen;
  logic        c2d_imemreq_val;
  logic        c2d_dmemreq_val;
  logic        c2d_dmemreq_type;
  logic        c2d_out0_en;
  logic        c2d_out1_en;
  logic        c2d_out2_en;

  // Status Signals (Datapath -> Control Unit)

  logic [31:0] d2c_inst;
  logic        d2c_eq;

  // Insantiate/Connect Datapath and Control Unit

  ProcScycleDpath dpath
  (
    .*
  );

  ProcScycleCtrl ctrl
  (
    .*
  );

endmodule




`endif /* PROC_SCYCLE_V */

