//========================================================================
// AccumXcel
//========================================================================

`ifndef ACCUM_XCEL_V
`define ACCUM_XCEL_V

`include "AccumXcelDpath.v"
`include "AccumXcelCtrl.v"

module AccumXcel
(
  (* keep=1 *) input  logic        clk,
  (* keep=1 *) input  logic        rst,

  (* keep=1 *) input  logic        go,
  (* keep=1 *) input  logic [13:0] size,

  (* keep=1 *) output logic        result_val,
  (* keep=1 *) output logic [31:0] result,

  (* keep=1 *) output logic        memreq_val,
  (* keep=1 *) output logic [15:0] memreq_addr,
  (* keep=1 *) input  logic [31:0] memresp_data
);

  // Instantiate/Connect Datapath and Control Unit

  logic dpath_result_val_wire;
  logic mem_mux_select;
  logic count_select;
  logic go_sig;
  logic res_select;
  logic res_enable_wire;
  
  AccumXcelCtrl ctrl
  (
    .clk(clk),
    .rst(rst),
    .go(go),
    .result_val(result_val),
    .memreq_val(memreq_val),
    .mem_mux_sel(mem_mux_select),
    .count_sel(count_select),
    .dpath_result_val(dpath_result_val_wire),
    .go_signal(go_sig)
    // .res_memory_enable(res_memory_enable_wire),
    // .res_adder_enable(res_adder_enable_wire),
    // .counter_enable(counter_enable_wire),
    // .dpath_result_val(dpath_result_val_wire),
    // .state(state_wire),

  );


  AccumXcelDpath dpath
  (
    .clk(clk),
    .rst(rst),
    .size(size),
    .result(result),
    .memreq_addr(memreq_addr),
    .memresp_data(memresp_data),
    .mem_mux_sel(mem_mux_select),
    .count_sel(count_select),
    .dpath_result_val(dpath_result_val_wire),
    .go_signal(go_sig)
    // .res_adder_enable(res_adder_enable_wire),
    // .res_mem_enable(res_memory_enable_wire),
    // .dpath_result_val(dpath_result_val_wire),
    // .counter(size),
    // .counter_enable(counter_enable_wire)
  );

endmodule

`endif /* ACCUM_XCEL_V */

//