// $Id: $
// File name:   RC4_CORE.sv
// Created:     4/22/2017
// Author:      John Student
// Lab Section: 03
// Version:     1.0  Initial Design Entry
// Description: .


module RC4_CORE(
	input wire clk,
	input wire n_rst_i,
	input wire rc4_dfb_i,
	input wire rc4_start_i,
	input wire [31:0] rc4_rdata_i,
	input wire sarrGenerated_i,
	input wire valReady_i,
	input wire [7:0] outputToXor_i,
	input wire [19:0] img_width_i,
	input wire [19:0] img_hight_i,
	output reg [31:0] rc4_wdata_o,
	output reg [19:0] rc4_pix_num_o,
	output reg [1:0] rc4_mode_o,
	output reg rc4_done_o,
	output reg genVal_o,
	output reg genStateArr_o
	);

	wire [19:0] counterPixel;
	wire ready_to_read;
	wire enable_counter_pix;
	wire clearPixels;
	wire ready_to_write;
	wire xor_sig;
	wire ready_data;
	wire [31:0] dataToDecrypt;
	wire enable_write;
	wire [1:0] writeLoc;
	wire [7:0] data;

	RC4_CORE_STATE_MACH DUT_STATE_MACH (.clk(clk),.n_rst_i(n_rst_i),.rc4_dfb_i(rc4_dfb_i),.rc4_start_i(rc4_start_i),.sarrGenerated_i(sarrGenerated_i),.valReady_i(valReady_i)
				,.img_width_i(img_width_i),.img_hight_i(img_hight_i),.counterPixel_i(counterPixel)
				,.ready_to_read_o(ready_to_read),.rc4_mode_o(rc4_mode_o),.rc4_done_o(rc4_done_o)
				,.enable_counter_pix_o(enable_counter_pix),.clearPixels_o(clearPixels),.ready_to_write_o(ready_to_write)
				,.xor_sig_o(xor_sig),.ready_data_o(ready_data),.genStateArr_o(genStateArr_o),.genVal_o(genVal_o));

	
	dataToDecrypt DUT_DATA_TO_DECRYPT (.clk_i(clk),.read_ready_i(ready_data),.rc4_data_i(rc4_rdata_i),.dataToDecrypt_o(dataToDecrypt));
	

	RC4_Core_comb DUT_COMB_LOGIC (.outputToXor_i(outputToXor_i),.couterPixel_i(counterPixel),.ready_to_write_i(ready_to_write),.ready_to_read_i(ready_to_read),
			   .xor_sig_i(xor_sig),.dataToDecrypt_i(dataToDecrypt),.enable_write_o(enable_write),
			   .writeLoc_o(writeLoc),.data_o(data),.rc4_pix_num_o(rc4_pix_num_o));


	RC4_CORE_decrypted_data DUT_DECRYPTED_DATA (.clk(clk),.enable_write_i(enable_write),.writeLoc_i(writeLoc),.data_i(data),.rc4_wdata_o(rc4_wdata_o));

	counterPixel COUNTER_PIXEL (.clk(clk),.n_rst(n_rst_i),.clear(clearPixels),.count_enable(enable_counter_pix),
			   .rollover_val(),.count_out(counterPixel),.rollover_flag());

endmodule
