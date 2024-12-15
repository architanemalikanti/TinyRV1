//========================================================================
// AccumXcelDpath
//========================================================================

`ifndef ACCUM_XCEL_DPATH_V
`define ACCUM_XCEL_DPATH_V
<<<<<<< HEAD
//
//''' LAB ASSIGNMENT '''''''''''''''''''''''''''''''''''''''''''''''''''''
// Include other hardware modules as necessary
//''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
=======

`include "Adder_32b_GL.v"
`include "Register_RTL.v"
`include "Mux2_RTL.v"
`include "EqComparator_32b_RTL.v"

>>>>>>> bb88187c4740c5b0eee4cf2a430bd6f4f7adf823

module AccumXcelDpath
(
  (* keep=1 *) input  logic        clk,
  (* keep=1 *) input  logic        rst,
  // I/O Interface
  (* keep=1 *) input  logic [13:0] size,
  (* keep=1 *) output logic [31:0] result,

  // Memory Interface

  (* keep=1 *) output logic [15:0] memreq_addr,
  (* keep=1 *) input  logic [31:0] memresp_data,
  
  //Mux select control signals
  input mem_mux_sel,
  input count_sel,
  input res_sel,

  output logic dpath_result_val,
  input logic go_signal,
  input logic res_enable
);

  // The datapath must be completely structural RTL. You should only
  // instantiate and connect RTL modules that you have implemented and
  // tested separately. The only exception is if you need to use an adder
  // you should use the Adder_32b_GL module. This means you cannot
  // directly use any logic in this module; no always blocks and nothing
  // in an assign statement other than basic connectivity.
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

<<<<<<< HEAD
=======
//Logic for finding memreq_addr
logic [31:0] memreq_address;
logic [15:0] mem_mux_out;
Mux2_RTL#(16) mem_mux(
  .in0(16'd0),
  .in1(memreq_address[15:0]),
  .sel(mem_mux_sel),
  .out(mem_mux_out)
);

logic [15:0] mem_reg_out;
Register_RTL#(16) memory_register(
  .clk(clk),
  .rst(rst),
  .en(1'b1),
  .d(mem_mux_out),
  .q(mem_reg_out)
);

Adder_32b_GL mem_adder (
  .in0({16'b0, mem_reg_out}),
  .in1(32'd4),
  .sum(memreq_address)
);

logic [15:0] memreq_addr_unused;
assign memreq_addr = mem_reg_out;
assign memreq_addr_unused = memreq_address[31:16];

//Logic to get the size only when go is high
logic [13:0] size_real;
Register_RTL#(14) size_real_register(
  .clk(clk),
  .rst(rst),
  .en(go_signal),
  .d(size),
  .q(size_real)
);


//Logic for checking size many iterations
logic [31:0] size_counter;
logic [31:0] size_counter_mux_out;
Mux2_RTL#(32) size_counter_mux(
  .in0(32'd0),
  .in1(size_counter),
  .sel(count_sel),
  .out(size_counter_mux_out)
);

logic [31:0] size_counter_reg_out;
Register_RTL#(32) size_counter_register(
  .clk(clk),
  .rst(rst),
  .en(1'b1),
  .d(size_counter_mux_out),
  .q(size_counter_reg_out)
);

Adder_32b_GL size_counter_adder (
  .in0(size_counter_reg_out),
  .in1(32'd1),
  .sum(size_counter)
);

EqComparator_32b_RTL size_checker(
  .in0(size_counter_mux_out),
  .in1({18'b0, size_real} ),
  .eq(dpath_result_val)
);

logic [31:0] memresp_data_unused;

//Logic for result
logic [31:0] res_next;
logic [31:0] res_next_mux_out;
Mux2_RTL#(32) res_mux(
  .in0(32'd0),
  .in1(res_next),
  .sel(res_sel),
  .out(res_next_mux_out)
);

logic [31:0] result_acc;
Register_RTL#(32) res_register(
  .clk(clk),
  .rst(rst),
  .en(res_enable), 
  .d(res_next_mux_out),
  .q(result_acc)
);

assign result = result_acc;
Adder_32b_GL res_adder (
  .in0(result_acc),
  .in1(memresp_data),
  .sum(res_next)
);

>>>>>>> bb88187c4740c5b0eee4cf2a430bd6f4f7adf823
endmodule

`endif /* ACCUM_XCEL_DPATH_V */

