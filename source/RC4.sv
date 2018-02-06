// $Id: $
// File name:   RC4.sv
// Created:     4/22/2017
// Author:      John Student
// Lab Section: 03
// Version:     1.0  Initial Design Entry
// Description: .


module RC4(
	input wire clk,
	input wire n_rst_i,
	input wire [19:0] img_width_i,
	input wire [19:0] img_hight_i,
	input wire rc4_dfb_i,
	input wire [31:0] rc4_rdata_i,
	input wire rc4_start_i,
	input wire [31:0] rc4_key,
	output reg [1:0] rc4_mode_o,	
	output reg [31:0] rc4_wdata_o,
	output reg [19:0] rc4_pix_num_o,
	output reg rc4_done_o
	);

	wire sarrGenerated;
	wire valReady;
	wire [7:0] outputToXor;
	wire genVal;
	wire genStateArr;

	 RC4_CORE DUT_core (.clk(clk),.n_rst_i(n_rst_i),.rc4_dfb_i(rc4_dfb_i),.rc4_start_i(rc4_start_i),.rc4_rdata_i(rc4_rdata_i),.sarrGenerated_i(sarrGenerated),
			.valReady_i(valReady),.outputToXor_i(outputToXor),.img_width_i(img_width_i),.img_hight_i(img_hight_i),
			.rc4_wdata_o(rc4_wdata_o),.rc4_pix_num_o(rc4_pix_num_o),.rc4_mode_o(rc4_mode_o),
			.rc4_done_o(rc4_done_o),.genVal_o(genVal),.genStateArr_o(genStateArr));

	RC4_gen_pseudo_rand_module DUT_gpr (.clk(clk),.n_rst(n_rst_i),.genStateArr_i(genStateArr),.genVal_i(genVal),
					.rc4_key_i_(rc4_key),.outputToXor_o(outputToXor),.sarrGenerated_o_(sarrGenerated),.valReady_o_(valReady));

endmodule
