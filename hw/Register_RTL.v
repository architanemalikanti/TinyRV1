//========================================================================
// Register_RTL
//========================================================================

`ifndef REGISTER_RTL_V
`define REGISTER_RTL_V

module Register_RTL
#(
  parameter p_nbits = 1
)(
  input  logic               clk,
  input  logic               rst,
  input  logic               en,
  input  logic [p_nbits-1:0] d,
  output logic [p_nbits-1:0] q
);

    // Implement a parameterized register using always_ff
  always_ff @(posedge clk) begin
    if (rst) begin
      q <= {p_nbits{1'b0}};                     // Reset q to all zeros
    end else if (en) begin
      q <= d;                                   // Update q with d when enabled
    end
    // If `en` is 0 and `rst` is 0, `q` holds its previous value automatically
  end
endmodule

`endif /* REGISTER_RTL_V */

