//========================================================================
// AccumXcelCtrl
//========================================================================

`ifndef ACCUM_XCEL_CTRL_V
`define ACCUM_XCEL_CTRL_V

<<<<<<< HEAD
//''' LAB ASSIGNMENT '''''''''''''''''''''''''''''''''''''''''''''''''''''
// Include other hardware modules as necessary
//''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
//
=======
`include "Adder_32b_GL.v"
`include "Register_RTL.v"


>>>>>>> bb88187c4740c5b0eee4cf2a430bd6f4f7adf823
module AccumXcelCtrl
(
  (* keep=1 *) input  logic        clk,
  (* keep=1 *) input  logic        rst,

  // I/O Interface

  (* keep=1 *) input  logic        go,
  (* keep=1 *) output logic        result_val,

  // Memory Interface

  (* keep=1 *) output logic        memreq_val,

<<<<<<< HEAD
  //''' LAB ASSIGNMENT '''''''''''''''''''''''''''''''''''''''''''''''''''
  // Add control and status ports as necessary
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
=======
  //Mux select control signals
  output logic mem_mux_sel,
  output logic count_sel,
  output logic res_sel,

  
  input logic dpath_result_val,
  output logic go_signal,
  output logic res_enable
>>>>>>> bb88187c4740c5b0eee4cf2a430bd6f4f7adf823
);

  //''' LAB ASSIGNMENT '''''''''''''''''''''''''''''''''''''''''''''''''''
  // Implement accumulator accelerator control unit
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // The control unit must include just a finite-state machine. It must
  // have three parts: the state register which should be implemented
  // using a Reg_RTL, an always_comb block to implement the combinational
  // state transition logic, and an always_comb block to implement the
  // combinational output logic. There should be no other logic in the
  // control unit. No always_ff blocks (explicitly instantiate Reg_RTL
  // for the state register), no other always_comb blocks, and nothing in
  // an assign statement other than basic connectivity.
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

<<<<<<< HEAD
=======
  localparam STATE_RESET     = 2'b00;
  localparam STATE_IDLE      = 2'b01;
  localparam STATE_ADDING = 2'b11;

  //Go_signal for when go is x
  always_comb begin
    if(go)
      go_signal = 1;
    else if(go == 0)
      go_signal = 0;
    else
      go_signal = 0;
  end


  //Register for FSM state
  logic [1:0] next_state;
  logic [1:0] state;
 
  Register_RTL#(2) state_reg(
    .clk(clk),
    .rst(rst),
    .en(1'b1),
    .d(next_state),
    .q(state)
  );


  //Combinational Transition Logic

  always_comb begin
    next_state = STATE_RESET;

    if(state == STATE_RESET) begin
      if(go)
        next_state = STATE_ADDING;
      else  
        next_state = STATE_RESET;
    end

    else if (state == STATE_ADDING) begin
      if(dpath_result_val)
        next_state = STATE_IDLE;
      else
        next_state = STATE_ADDING;
    end

    else if(state == STATE_IDLE) begin
      if(!rst)
        next_state = STATE_IDLE;
      else
        next_state = STATE_RESET;
    end

  end

  //Combinational Output Logic

  always_comb begin
    mem_mux_sel = 0;
    memreq_val = 0;
    count_sel = 0;
    res_sel = 0;
    result_val = 0;
    res_enable = 0;
    if(state == STATE_ADDING) begin
      mem_mux_sel = 1;
      count_sel = 1;
      memreq_val = 1;
      result_val = 0;
      res_sel = 1;
      res_enable = 1;
    end

    else if(state == STATE_RESET) begin
      mem_mux_sel = 0;
      memreq_val = 0;
      count_sel = 0;
      result_val = 0;
      res_sel = 0;
      res_enable = 1;
    end

    else if(state == STATE_IDLE) begin
      result_val = 1;
      res_enable = 0;
      res_sel = 0;
    end
  end

>>>>>>> bb88187c4740c5b0eee4cf2a430bd6f4f7adf823
endmodule


`endif /* ACCUM_XCEL_CTRL_V */

