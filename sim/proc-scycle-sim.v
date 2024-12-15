//========================================================================
// proc-scycle-sim +prog-num=0 +in0-switches=00000 +in1-switches=00000
//========================================================================
// Author : Christopher Batten (Cornell)
// Date   : September 7, 2024

`define CYCLE_TIME 10

`include "ProcScycle.v"
`include "ProcMem.v"
`include "TestMemory.v"
`include "Display_GL.v"

//========================================================================
// SevenSegFL
//========================================================================
// Functional level model of a seven segment display.

module SevenSegFL
(
  input [6:0] in
);

  task write_row( int row_idx );

    if ( row_idx == 0 ) begin
      if ( ~in[0] )
        $write( " === " );
      else
        $write( "     " );
    end

    else if (( row_idx == 1 ) || ( row_idx == 2 )) begin

      if ( ~in[5] )
        $write( "|" );
      else
        $write( " " );

      $write( "   " );

      if ( ~in[1] )
        $write( "|" );
      else
        $write( " " );
    end

    else if ( row_idx == 3 ) begin
      if ( ~in[6] )
        $write( " === " );
      else
        $write( "     " );
    end

    else if (( row_idx == 4 ) || ( row_idx == 5 )) begin

      if ( ~in[4] )
        $write( "|" );
      else
        $write( " " );

      $write( "   " );

      if ( ~in[2] )
        $write( "|" );
      else
        $write( " " );
    end

    else if ( row_idx == 6 ) begin
      if ( ~in[3] )
        $write( " === " );
      else
        $write( "     " );
    end

  endtask

endmodule

//========================================================================
// Top
//========================================================================

module Top();

  //----------------------------------------------------------------------
  // Clock/Reset
  //----------------------------------------------------------------------

  // verilator lint_off BLKSEQ
  logic clk;
  initial clk = 1'b1;
  always #5 clk = ~clk;
  // verilator lint_on BLKSEQ

  logic rst;

  //----------------------------------------------------------------------
  // Instantiate modules
  //----------------------------------------------------------------------

  // Processor

  logic        imemreq_val;
  logic [31:0] imemreq_addr;
  logic [31:0] imemresp_data;

  logic        dmemreq_val;
  logic        dmemreq_type;
  logic [31:0] dmemreq_addr;
  logic [31:0] dmemreq_wdata;
  logic [31:0] dmemresp_rdata;

  // verilator lint_off UNUSED
  logic [31:0] proc_in0;
  logic [31:0] proc_in1;
  logic [31:0] proc_in2;

  logic [31:0] proc_out0;
  logic [31:0] proc_out1;
  logic [31:0] proc_out2;
  // verilator lint_on UNUSED

  logic        proc_trace_val_unused;
  logic [31:0] proc_trace_addr_unused;
  logic [31:0] proc_trace_data_unused;

  ProcScycle proc
  (
    .clk             (clk),
    .rst             (rst),

    .imemreq_val     (imemreq_val),
    .imemreq_addr    (imemreq_addr),
    .imemresp_data   (imemresp_data),

    .dmemreq_val     (dmemreq_val),
    .dmemreq_type    (dmemreq_type),
    .dmemreq_addr    (dmemreq_addr),
    .dmemreq_wdata   (dmemreq_wdata),
    .dmemresp_rdata  (dmemresp_rdata),

    .in0             (proc_in0),
    .in1             (proc_in1),
    .in2             (proc_in2),

    .out0            (proc_out0),
    .out1            (proc_out1),
    .out2            (proc_out2),

    .trace_val       (proc_trace_val_unused),
    .trace_addr      (proc_trace_addr_unused),
    .trace_data      (proc_trace_data_unused)
  );

  // Processor Memory (with the real program)

  logic        pmem_imemreq_val;
  logic [31:0] pmem_imemreq_addr;
  logic [31:0] pmem_imemresp_data;

  logic        pmem_dmemreq_val;
  logic        pmem_dmemreq_type;
  logic [31:0] pmem_dmemreq_addr;
  logic [31:0] pmem_dmemreq_wdata;
  logic [31:0] pmem_dmemresp_rdata;

  ProcMem pmem
  (
    .clk             (clk),
    .rst             (rst),

    .imemreq_val     (pmem_imemreq_val),
    .imemreq_addr    (pmem_imemreq_addr),
    .imemresp_data   (pmem_imemresp_data),

    .dmemreq_val     (pmem_dmemreq_val),
    .dmemreq_type    (pmem_dmemreq_type),
    .dmemreq_addr    (pmem_dmemreq_addr),
    .dmemreq_wdata   (pmem_dmemreq_wdata),
    .dmemresp_rdata  (pmem_dmemresp_rdata)
  );

  // Test Memory

  logic        tmem_imemreq_val;
  logic [31:0] tmem_imemreq_addr;
  logic [31:0] tmem_imemresp_data;

  logic        tmem_dmemreq_val;
  logic        tmem_dmemreq_type;
  logic [31:0] tmem_dmemreq_addr;
  logic [31:0] tmem_dmemreq_wdata;
  logic [31:0] tmem_dmemresp_rdata;

  TestMemory tmem
  (
    .clk             (clk),
    .rst             (rst),

    .imemreq_val     (tmem_imemreq_val),
    .imemreq_addr    (tmem_imemreq_addr),
    .imemresp_data   (tmem_imemresp_data),

    .dmemreq_val     (tmem_dmemreq_val),
    .dmemreq_type    (tmem_dmemreq_type),
    .dmemreq_addr    (tmem_dmemreq_addr),
    .dmemreq_wdata   (tmem_dmemreq_wdata),
    .dmemresp_rdata  (tmem_dmemresp_rdata)
  );

  // Muxing/demuxing for two memories

  logic use_pmem;

  assign pmem_imemreq_val   = ( use_pmem ) ? imemreq_val   : '0;
  assign pmem_imemreq_addr  = ( use_pmem ) ? imemreq_addr  : '0;
  assign pmem_dmemreq_val   = ( use_pmem ) ? dmemreq_val   : '0;
  assign pmem_dmemreq_type  = ( use_pmem ) ? dmemreq_type  : '0;
  assign pmem_dmemreq_addr  = ( use_pmem ) ? dmemreq_addr  : '0;
  assign pmem_dmemreq_wdata = ( use_pmem ) ? dmemreq_wdata : '0;

  assign tmem_imemreq_val   = ( use_pmem ) ? '0 : imemreq_val;
  assign tmem_imemreq_addr  = ( use_pmem ) ? '0 : imemreq_addr;
  assign tmem_dmemreq_val   = ( use_pmem ) ? '0 : dmemreq_val;
  assign tmem_dmemreq_type  = ( use_pmem ) ? '0 : dmemreq_type;
  assign tmem_dmemreq_addr  = ( use_pmem ) ? '0 : dmemreq_addr;
  assign tmem_dmemreq_wdata = ( use_pmem ) ? '0 : dmemreq_wdata;

  assign imemresp_data      = ( use_pmem ) ? pmem_imemresp_data  : tmem_imemresp_data;
  assign dmemresp_rdata     = ( use_pmem ) ? pmem_dmemresp_rdata : tmem_dmemresp_rdata;

  // Out Displays

  logic [6:0] proc_out0_seg_tens;
  logic [6:0] proc_out0_seg_ones;

  Display_GL proc_out0_display
  (
    .in       (proc_out0[4:0]),
    .seg_tens (proc_out0_seg_tens),
    .seg_ones (proc_out0_seg_ones)
  );

  logic [6:0] proc_out1_seg_tens;
  logic [6:0] proc_out1_seg_ones;

  Display_GL proc_out1_display
  (
    .in       (proc_out1[4:0]),
    .seg_tens (proc_out1_seg_tens),
    .seg_ones (proc_out1_seg_ones)
  );

  logic [6:0] proc_out2_seg_tens;
  logic [6:0] proc_out2_seg_ones;

  Display_GL proc_out2_display
  (
    .in       (proc_out2[4:0]),
    .seg_tens (proc_out2_seg_tens),
    .seg_ones (proc_out2_seg_ones)
  );

  //----------------------------------------------------------------------
  // Instantiate seven-segment display FL models
  //----------------------------------------------------------------------

  SevenSegFL proc_out0_seg_tens_fl
  (
    .in (proc_out0_seg_tens)
  );

  SevenSegFL proc_out0_seg_ones_fl
  (
    .in (proc_out0_seg_ones)
  );

  SevenSegFL proc_out1_seg_tens_fl
  (
    .in (proc_out1_seg_tens)
  );

  SevenSegFL proc_out1_seg_ones_fl
  (
    .in (proc_out1_seg_ones)
  );

  SevenSegFL proc_out2_seg_tens_fl
  (
    .in (proc_out2_seg_tens)
  );

  SevenSegFL proc_out2_seg_ones_fl
  (
    .in (proc_out2_seg_ones)
  );

  //----------------------------------------------------------------------
  // asm
  //----------------------------------------------------------------------

  logic dump_bin;

  task asm
  (
    input [31:0] addr,
    input string str
  );
    tmem.asm( addr, str );
    if ( dump_bin ) begin
      $display( "      mem[%4d] <= 32'h%x; // %x %s",
                addr/4, tmem.read(addr), addr, str );
    end
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
    tmem.write( addr, data_ );
    data_addr_unused = addr;
    if ( dump_bin ) begin
      $display( "      mem[%4d] <= 32'h%x; // %x data",
                addr/4, data_, addr );
    end
  endtask

  //----------------------------------------------------------------------
  // programs
  //----------------------------------------------------------------------

  `include "proc-sim-prog1.v"
  `include "proc-sim-prog2.v"
  `include "proc-sim-prog3.v"

  //----------------------------------------------------------------------
  // Perform the simulation
  //----------------------------------------------------------------------

  logic [4:0] in0_switches;
  logic [4:0] in1_switches;
  logic [3:0] buttons;

  int cycle_count = 0;
  int prog_num;
  string vcd_filename;

  initial begin

    // Process command line arguments

    dump_bin = 0;
    if ( $test$plusargs( "dump-bin" ) )
      dump_bin = 1;

    if ( $value$plusargs( "dump-vcd=%s", vcd_filename ) ) begin
      $dumpfile(vcd_filename);
      $dumpvars();
    end

    if ( !$value$plusargs( "prog-num=%d", prog_num ) )
      prog_num = 0;

    if ( !$value$plusargs( "in0-switches=%b", in0_switches ) )
      in0_switches = 0;

    if ( !$value$plusargs( "in1-switches=%b", in1_switches ) )
      in1_switches = 0;

    if ( !$value$plusargs( "buttons=%b", buttons ) )
      buttons = 0;

    // Program number

    $display( "prog_num = %d", prog_num );

    if ( dump_bin )
      $display("");

    use_pmem = 0;
    if ( prog_num == 0 )
      use_pmem = 1;
    else if ( prog_num == 1 )
      proc_sim_prog1();
    else if ( prog_num == 2 )
      proc_sim_prog2();
    else if ( prog_num == 3 )
      proc_sim_prog3();

    if ( dump_bin )
      $display("");

    // Input switches and buttons

    $display( "in0-switches = %b", in0_switches );
    $display( "in1-switches = %b", in1_switches );
    $display( "buttons      = %b", buttons      );

    proc_in0 = {27'b0,in0_switches};
    proc_in1 = {27'b0,in1_switches};
    proc_in2 = {28'b0,buttons};

    #1;

    // Reset sequence

    rst = 1;
    #(3*`CYCLE_TIME);
    rst = 0;

    // Simulate 500 cycles

    for ( int i = 0; i < 500; i++ ) begin
      if ( proc_out1 == 0 )
        cycle_count = cycle_count + 1;

      #`CYCLE_TIME;
    end

    // Display size and result

    $write( "\n" );
    for ( int i = 0; i < 7; i++ ) begin

      $write( "    " );
      proc_out0_seg_tens_fl.write_row( i );
      $write( "  " );
      proc_out0_seg_ones_fl.write_row( i );

      $write( "    " );
      proc_out1_seg_tens_fl.write_row( i );
      $write( "  " );
      proc_out1_seg_ones_fl.write_row( i );

      $write( "    " );
      proc_out2_seg_tens_fl.write_row( i );
      $write( "  " );
      proc_out2_seg_ones_fl.write_row( i );

      $write( "\n" );
    end
    $write( "\n" );

    // Finish

    $display( "out0 = %x (%d)", proc_out0, proc_out0 );
    $display( "out1 = %x (%d)", proc_out1, proc_out1 );
    $display( "out2 = %x (%d)", proc_out2, proc_out2 );
    $display( "cycle_count = %-0d", cycle_count );
    $finish;

  end

endmodule
