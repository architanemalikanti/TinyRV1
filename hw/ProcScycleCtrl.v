//========================================================================
// ProcScycleCtrl
//========================================================================

`ifndef PROC_SCYCLE_CTRL_V
`define PROC_SCYCLE_CTRL_V

`include "tinyrv1.v"

module ProcScycleCtrl
(
  (* keep=1 *) input  logic        rst,

  // Control Signals (Control Unit -> Datapath)

  (* keep=1 *) output logic  [1:0] c2d_pc_sel,
  (* keep=1 *) output logic  [1:0] c2d_imm_type,
  (* keep=1 *) output logic        c2d_op2_sel,
  (* keep=1 *) output logic        c2d_alu_func,
  (* keep=1 *) output logic  [2:0] c2d_wb_sel,
  (* keep=1 *) output logic        c2d_rf_wen,
  (* keep=1 *) output logic        c2d_imemreq_val,
  (* keep=1 *) output logic        c2d_dmemreq_val,
  (* keep=1 *) output logic        c2d_dmemreq_type,
  (* keep=1 *) output logic        c2d_out0_en,
  (* keep=1 *) output logic        c2d_out1_en,
  (* keep=1 *) output logic        c2d_out2_en,

  // Status Signals (Datapath -> Control Unit)

  (* keep=1 *) input  logic [31:0] d2c_inst, //instruction
  (* keep=1 *) input  logic        d2c_eq
);

  //''' LAB ASSIGNMENT '''''''''''''''''''''''''''''''''''''''''''''''''''
  // Implement the control unit for the single-cycle processor
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // We have provided you with the control unit for the ADDI instruction
  // below. You will need to modify this control unit to support the rest
  // of the TinyRV1 instruction set.

  // Unused signals

  logic d2c_eq_unused;
  assign d2c_eq_unused = d2c_eq;

  //assign c2d_out0_en = '0;
  //assign c2d_out1_en = '0;
  //assign c2d_out2_en = '0;

  // Localparams for different control signals

  // verilator lint_off UNUSED
  localparam imm_i = 2'd0;
  localparam imm_s = 2'd1;
  localparam imm_j = 2'd2;
  localparam imm_b = 2'd3;
  localparam imm_x = 2'bx;

  localparam add   = 1'd0;
  localparam mul   = 1'd1;
  localparam eq = 1'd1;
  // verilator lint_on UNUSED

  // Task for setting control signals
  task automatic cs
  (
    input logic [1:0] pc_sel,
    input logic [1:0] imm_type,
    input logic       op2_sel,
    input logic       alu_func,
    input logic [2:0] wb_sel,
    input logic       rf_wen,
    input logic       imemreq_val,
    input logic       dmemreq_val,
    input logic       dmemreq_type
  );
    c2d_pc_sel       = pc_sel;
    c2d_imm_type     = imm_type;
    c2d_op2_sel      = op2_sel;
    c2d_alu_func     = alu_func;
    c2d_wb_sel       = wb_sel;
    c2d_rf_wen       = rf_wen;
    c2d_imemreq_val  = imemreq_val;
    c2d_dmemreq_val  = dmemreq_val;
    c2d_dmemreq_type = dmemreq_type;
  endtask


  //PC_sel for BNE
  //PC_sel for BNE
  logic [1:0] pcb;
  assign pcb = (d2c_eq) ? 2'b00 : 2'b01; //decide between jalbr_targ and pc_plus4, incorrect syntax. 
  //if it's zero, then sign extended immediate. if not then incrememnt PC by 4. 

  // work around for constant selects are not allowed in always_comb
  logic [11:0] csr_bits;
  assign csr_bits = d2c_inst[`TINYRV1_INST_CSR];

  // Control signal table
  always_comb begin
    c2d_out0_en = 1'b0;
                c2d_out1_en = 1'b0;
                c2d_out2_en = 1'b0;
    if ( rst )
      cs( '0, '0, '0, '0, '0, '0, '0, '0, '0 );
    else begin
      casez ( d2c_inst )
                          //    pc     imm    op2   alu      wb  rf     imem    dmem   dmem
                          //    sel    type   sel   func     sel wen    val     val    type
        `TINYRV1_INST_ADDI: cs( 2'b00, imm_i, 1'b1, add, 3'b001, 1'b1,  1'b1,   1'b0,  'x   );
        `TINYRV1_INST_ADD : cs( 2'b00, imm_i, 1'b0, add, 3'b001, 1'b1,  1'b1,   1'b0,  'x   );
        `TINYRV1_INST_MUL : cs( 2'b00, imm_x, 'x,   'x, 3'b000, 1'b1,  1'b1,   1'b0,  'x   ); 
        `TINYRV1_INST_LW  : cs( 2'b00, imm_i, 1'b1, add, 3'b011, 1'b1,  1'b1,   1'b1,  1'b0   );
        `TINYRV1_INST_SW  : cs( 2'b00, imm_s, 1'b1, add, 3'bxxx, 1'b0,  1'b1,   1'b1,   1'b1   ); 
        `TINYRV1_INST_JAL : cs( 2'b01, imm_j,   'x, 'x, 3'b010, 1'b1,  1'b1,   1'b0,  'x   ); //ALUFUNC
        `TINYRV1_INST_JR  : cs( 2'b10, imm_x,   'x, 'x, 3'bxxx, 1'b0,  1'b1,   1'b0,  'x   ); //ALUFUNC
        `TINYRV1_INST_BNE : cs(  pcb , imm_b, 1'b0, eq, 3'bxxx, 1'b0,  1'b1,   1'b0,  'x   ); 
        `TINYRV1_INST_CSRW : 
          begin
            case ( csr_bits )
            // case ( d2c_inst[31:20] )
            `TINYRV1_CSR_OUT0 : begin
                cs( 2'b00, 'x, 'x, 'x, 3'b111, 1'b0, 1'b1, 1'b0, 'x );
                c2d_out0_en = 1'b1;
                c2d_out1_en = 1'b0;
                c2d_out2_en = 1'b0;
            end
            `TINYRV1_CSR_OUT1 : begin
                cs( 2'b00, 'x, 'x, 'x, 3'b111, 1'b0, 1'b1, 1'b0, 'x );
                c2d_out0_en = 1'b0;
                c2d_out1_en = 1'b1;
                c2d_out2_en = 1'b0;
            end
            `TINYRV1_CSR_OUT2 : begin
                cs( 2'b00, 'x, 'x, 'x, 3'b111, 1'b0, 1'b1, 1'b0, 'x );
                c2d_out0_en = 1'b0;
                c2d_out1_en = 1'b0;
                c2d_out2_en = 1'b1;
            end
            default : begin
                cs( 2'b00, 'x, 'x, 'x, 3'b111, 1'b0, 1'b1, 1'b0, 'x );
                c2d_out0_en = 1'b0;
                c2d_out1_en = 1'b0;
                c2d_out2_en = 1'b0;
            end
          endcase
      end
      `TINYRV1_INST_CSRR: 
        begin
          case ( csr_bits )
                            //    pc     imm    op2  alu   wb    rf     imem    dmem   dmem
                            //    sel    type   sel  func  sel   wen    val     val    type    
            `TINYRV1_CSR_IN0: cs(  2'b00 , 'x, 'x, 'x,    4 , 1'b1,  1'b1,   1'b0,  'x   );
            `TINYRV1_CSR_IN1: cs(  2'b00 , 'x, 'x, 'x,    5 , 1'b1,  1'b1,   1'b0,  'x   );
            `TINYRV1_CSR_IN2: cs(  2'b00 , 'x, 'x, 'x,    6 , 1'b1,  1'b1,   1'b0,  'x   );
            default:            cs( 'x, 'x,    'x, 'x,  'x, 'x, 1,   'x,  'x   );
          endcase
        end
      default:            cs( 'x, 'x,    'x, 'x,  'x, 'x, 1,   'x,  'x   );

    endcase
    end
  end

endmodule

`endif /* PROC_SCYCLE_CTRL_V */

