//========================================================================
// accum-xcel-sim +switches=00001
//========================================================================
// Author : Christopher Batten (Cornell)
// Date   : September 7, 2024

`define CYCLE_TIME 10

`include "AccumXcel.v"
`include "AccumXcelMem.v"
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

  logic        xcel_go;
  logic [13:0] xcel_size;
  logic        xcel_result_val;
  logic [31:0] xcel_result;

  logic        memreq_val;
  logic [15:0] memreq_addr;
  logic [31:0] memresp_data;

  AccumXcel xcel
  (
    .clk          (clk),
    .rst          (rst),
    .go           (xcel_go),
    .size         (xcel_size),
    .result_val   (xcel_result_val),
    .result       (xcel_result),
    .memreq_val   (memreq_val),
    .memreq_addr  (memreq_addr),
    .memresp_data (memresp_data)
  );

  AccumXcelMem mem
  (
    .clk          (clk),
    .rst          (rst),
    .memreq_val   (memreq_val),
    .memreq_addr  (memreq_addr),
    .memresp_data (memresp_data)
  );

  // Size Display

  logic [6:0] xcel_size_seg_tens;
  logic [6:0] xcel_size_seg_ones;

  Display_GL xcel_size_display
  (
    .in       (xcel_size[4:0]),
    .seg_tens (xcel_size_seg_tens),
    .seg_ones (xcel_size_seg_ones)
  );

  // Result Display

  logic [6:0] xcel_result_seg_tens;
  logic [6:0] xcel_result_seg_ones;

  Display_GL xcel_result_display
  (
    .in       (xcel_result[4:0]),
    .seg_tens (xcel_result_seg_tens),
    .seg_ones (xcel_result_seg_ones)
  );

  //----------------------------------------------------------------------
  // Instantiate seven-segment display FL models
  //----------------------------------------------------------------------

  SevenSegFL xcel_size_seg_tens_fl
  (
    .in (xcel_size_seg_tens)
  );

  SevenSegFL xcel_size_seg_ones_fl
  (
    .in (xcel_size_seg_ones)
  );

  SevenSegFL xcel_result_seg_tens_fl
  (
    .in (xcel_result_seg_tens)
  );

  SevenSegFL xcel_result_seg_ones_fl
  (
    .in (xcel_result_seg_ones)
  );

  //----------------------------------------------------------------------
  // Perform the simulation
  //----------------------------------------------------------------------

  logic done;
  int cycle_count = 0;
  logic [4:0] in0_switches;
  logic [3:0] buttons;
  string vcd_filename;

  initial begin

    // Process command line arguments

    if ( $value$plusargs( "dump-vcd=%s", vcd_filename ) ) begin
      $dumpfile(vcd_filename);
      $dumpvars();
    end

    if ( !$value$plusargs( "in0-switches=%b", in0_switches ) )
      in0_switches = 0;

    if ( !$value$plusargs( "buttons=%b", buttons ) )
      buttons = 0;

    xcel_size = {9'b0,in0_switches};
    xcel_go   = buttons[0];

    $display( "in0-switches = %b", in0_switches );
    $display( "buttons      = %b", buttons      );

    #1;

    // Reset sequence

    rst = 1;
    #(3*`CYCLE_TIME);
    rst = 0;

    // Simulate 500 cycles

    done = 0;
    for ( int i = 0; i < 500; i++ ) begin
      if ( !done )
        cycle_count = cycle_count + 1;

      if ( xcel_result_val )
        done = 1;

      #`CYCLE_TIME;
    end

    // Display size and result

    $write( "\n" );
    for ( int i = 0; i < 7; i++ ) begin

      $write( "    " );
      xcel_size_seg_tens_fl.write_row( i );
      $write( "  " );
      xcel_size_seg_ones_fl.write_row( i );

      $write( "    " );
      xcel_result_seg_tens_fl.write_row( i );
      $write( "  " );
      xcel_result_seg_ones_fl.write_row( i );

      $write( "\n" );
    end
    $write( "\n" );

    // Finish

    $display( "result_val  = %b",      xcel_result_val );
    $display( "result      = %x (%-0d)", xcel_result, xcel_result );
    $display( "cycle_count = %-0d",      cycle_count );
    $finish;

  end

endmodule
