//========================================================================
// ProcFL-jr-test
//========================================================================

`include "ece2300-test.v"
`include "ProcFL.v"

module Top();

  //----------------------------------------------------------------------
  // Setup
  //----------------------------------------------------------------------

  // verilator lint_off UNUSED
  logic clk;
  logic reset;
  // verilator lint_on UNUSED

  ece2300_TestUtils t( .* );

  //----------------------------------------------------------------------
  // Instantiate design under test
  //----------------------------------------------------------------------

  // verilator lint_off UNUSED
  logic [31:0] proc_in0;
  logic [31:0] proc_in1;
  logic [31:0] proc_in2;

  logic [31:0] proc_out0;
  logic [31:0] proc_out1;
  logic [31:0] proc_out2;
  // verilator lint_on UNUSED

  logic        proc_trace_val;
  logic [31:0] proc_trace_addr;
  logic [31:0] proc_trace_inst;
  logic [31:0] proc_trace_data;

  ProcFL proc
  (
    .clk        (clk),
    .rst        (reset),

    .in0        (proc_in0),
    .in1        (proc_in1),
    .in2        (proc_in2),

    .out0       (proc_out0),
    .out1       (proc_out1),
    .out2       (proc_out2),

    .trace_val  (proc_trace_val),
    .trace_addr (proc_trace_addr),
    .trace_inst (proc_trace_inst),
    .trace_data (proc_trace_data)
  );

  //----------------------------------------------------------------------
  // check
  //----------------------------------------------------------------------

  TinyRV1 tinyrv1();

  task check_trace
  (
    input logic [31:0] addr,
    input logic [31:0] data
  );
    if ( !t.failed ) begin

      #8;

      while ( !proc_trace_val ) begin
        #10;
      end

      if ( t.n != 0 ) begin
        if ( data === 'x )
          $display( "%3d: %x %-s         ", t.cycles,
                    proc_trace_addr,
                    tinyrv1.disasm(proc_trace_addr,proc_trace_inst) );
        else
          $display( "%3d: %x %-s %x", t.cycles,
                    proc_trace_addr,
                    tinyrv1.disasm(proc_trace_addr,proc_trace_inst),
                    proc_trace_data );
      end

      `ECE2300_CHECK_EQ_HEX( proc_trace_addr, addr );
      `ECE2300_CHECK_EQ_HEX( proc_trace_data, data );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // asm
  //----------------------------------------------------------------------

  task asm
  (
    input [31:0] addr,
    input string str
  );
    proc.M[addr] = tinyrv1.asm( addr, str );
  endtask

  //----------------------------------------------------------------------
  // data
  //----------------------------------------------------------------------

  logic [31:0] data_addr_unused;

  task data
  (
    input [31:0] addr,
    input [31:0] data_
  );
    proc.M[addr] = data_;
    data_addr_unused = addr;
  endtask

  //----------------------------------------------------------------------
  // test cases
  //----------------------------------------------------------------------

  `include "Proc-jr-test-cases.v"

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin( `__FILE__ );

    proc_in0 = 'x;
    proc_in1 = 'x;
    proc_in2 = 'x;

    if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();
    if ((t.n <= 0) || (t.n == 1)) test_case_2_directed();
    if ((t.n <= 0) || (t.n == 1)) test_case_3_directed();

    t.test_bench_end();
  end

endmodule

