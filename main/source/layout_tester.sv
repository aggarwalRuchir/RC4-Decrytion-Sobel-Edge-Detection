// $Id: $
// File name:   layout_tester.sv
// Created:     4/25/2017
// Author:      foo
// Lab Section: 99
// Version:     1.0  Initial Design Entry
// Description: wrapper file testing project layout inital setups (same as lab7 design)

module layout_tester
(
	input  wire clk,
	input  wire n_rst, 
	output wire d_plus,
	output wire d_minus,
	input  wire transmit,
	input  wire write_enable,
	input  wire [7:0] write_data,
	output wire fifo_empty,
	output wire fifo_full
);
	
	lab7_usb_transmitter LD
	(
		.clk(clk),
		.n_rst(n_rst),
		.d_plus(d_plus),
		.d_minus(d_minus),
		.transmit(transmit),
		.write_enable(write_enable),
		.write_data(write_data),
		.fifo_empty(fifo_empty),
		.fifo_full(fifo_full)
	);
	
endmodule
