//========================================================================
// ProcFL
//========================================================================
// TinyRV1 functional-level model.

`ifndef PROC_FL_V
`define PROC_FL_V

`include "tinyrv1.v"

module ProcFL
(
  input  logic        clk,
  input  logic        rst,

  input  logic [31:0] in0,
  input  logic [31:0] in1,
  input  logic [31:0] in2,

  output logic [31:0] out0,
  output logic [31:0] out1,
  output logic [31:0] out2,

  output logic        trace_val,
  output logic [31:0] trace_addr,
  output logic [31:0] trace_inst,
  output logic [31:0] trace_data
);

  //----------------------------------------------------------------------
  // Architectural State
  //----------------------------------------------------------------------

  logic [31:0] M [2**14];
  logic [31:0] R [32];
  logic [31:0] pc;

  //----------------------------------------------------------------------
  // Other Signals
  //----------------------------------------------------------------------

  logic [31:0] pc_next;
  logic [31:0] ir;

  logic [`TINYRV1_INST_RS1_NBITS-1:0]   rs1;
  logic [`TINYRV1_INST_RS2_NBITS-1:0]   rs2;
  logic [`TINYRV1_INST_RD_NBITS-1:0]    rd;
  logic [`TINYRV1_INST_CSR_NBITS-1:0]   csr;

  //----------------------------------------------------------------------
  // Immediates
  //----------------------------------------------------------------------

  logic [31:0] inst_unused;

  function [31:0] imm_i
  (
    input [`TINYRV1_INST_NBITS-1:0] inst
  );
    inst_unused = inst;
    return { {21{inst[31]}}, inst[30:25], inst[24:21], inst[20] };
  endfunction

  function [31:0] imm_s
  (
    input [`TINYRV1_INST_NBITS-1:0] inst
  );
    inst_unused = inst;
    return { {21{inst[31]}}, inst[30:25], inst[11:8], inst[7] };
  endfunction

  function [31:0] imm_b
  (
    input [`TINYRV1_INST_NBITS-1:0] inst
  );
    inst_unused = inst;
    return { {20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0 };
  endfunction

  function [31:0] imm_j
  (
    input [`TINYRV1_INST_NBITS-1:0] inst
  );
    inst_unused = inst;
    return { {12{inst[31]}}, inst[19:12], inst[20], inst[30:25], inst[24:21], 1'b0 };
  endfunction

  //----------------------------------------------------------------------
  // Main Always Block
  //----------------------------------------------------------------------

  // verilator lint_off SIDEEFFECT
  // verilator lint_off BLKSEQ
  always @( posedge clk ) begin

    if ( rst ) begin
      pc         <= 32'h0000_0000;
      out0       <= '0;
      out1       <= '0;
      out2       <= '0;
      trace_val  <= 1'b0;
      trace_addr <= 'x;
      trace_inst <= 'x;
      trace_data <= 'x;
    end
    else begin

      // Fetch instruction

      ir = M[pc];

      // Unpack instruction

      rd  = ir[`TINYRV1_INST_RD];
      rs1 = ir[`TINYRV1_INST_RS1];
      rs2 = ir[`TINYRV1_INST_RS2];
      csr = ir[`TINYRV1_INST_CSR];

      // Make sure any reads to R0 gets a zero

      R[ 5'd0 ] = 32'b0;

      // Default is to increment PC by 4

      pc_next = pc + 4;

      // Semantics for each instruction

      trace_data <= 'x;

      casez ( ir )

        `TINYRV1_INST_CSRR :
          begin
            case ( csr )
              `TINYRV1_CSR_IN0 : begin R[rd] = in0; trace_data <= R[rd]; end
              `TINYRV1_CSR_IN1 : begin R[rd] = in1; trace_data <= R[rd]; end
              `TINYRV1_CSR_IN2 : begin R[rd] = in2; trace_data <= R[rd]; end
              default :

                begin
                  $display( " ERROR: Illegal CSR (%x)\n", csr );
                  $finish;
                end
            endcase
          end

        `TINYRV1_INST_CSRW :
          begin
            case ( csr )
              `TINYRV1_CSR_OUT0 : out0 <= R[rs1];
              `TINYRV1_CSR_OUT1 : out1 <= R[rs1];
              `TINYRV1_CSR_OUT2 : out2 <= R[rs1];
              default :
                begin
                  $display( " ERROR: Illegal CSR (%x)\n", csr );
                  $finish;
                end
            endcase
          end

        `TINYRV1_INST_ADD:
          begin
            R[rd] = R[rs1] + R[rs2];
            trace_data <= R[rd];
          end

        `TINYRV1_INST_ADDI:
          begin
            R[rd] = R[rs1] + imm_i(ir);
            trace_data <= R[rd];
          end

        `TINYRV1_INST_MUL:
          begin
            R[rd] = R[rs1] * R[rs2];
            trace_data <= R[rd];
          end

        `TINYRV1_INST_LW:
          begin
            R[rd] = M[ R[rs1] + imm_i(ir) ];
            trace_data <= R[rd];
          end

        `TINYRV1_INST_SW:
          begin
            M[ R[rs1] + imm_s(ir) ] = R[rs2];
          end

        `TINYRV1_INST_JAL:
          begin
            R[rd] = pc + 4;
            pc_next = pc + imm_j(ir);
            trace_data <= R[rd];
          end

        `TINYRV1_INST_JR:
          begin
            pc_next = R[rs1];
          end

        `TINYRV1_INST_BNE:
          begin
            if ( R[rs1] != R[rs2] )
              pc_next = pc + imm_b(ir);
          end

      endcase

      // Update trace output

      trace_val  <= 1'b1;
      trace_addr <= pc;
      trace_inst <= ir;

      // Update pc

      pc <= pc_next;

    end

  end
  // verilator lint_on BLKSEQ
  // verilator lint_on SIDEEFFECT

endmodule

`endif /* PROC_FL_V */

