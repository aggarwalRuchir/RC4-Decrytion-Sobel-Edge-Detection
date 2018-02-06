// $Id: $
// File name:   tb_RC4_Core_comb.sv
// Created:     4/21/2017
// Author:      John Student
// Lab Section: 03
// Version:     1.0  Initial Design Entry
// Description: .
`timescale 1ns / 100ps
module tb_RC4_Core_comb();
	localparam CLK_PERIOD = 20;
	reg tb_clk;
	always
	begin
		tb_clk = 1'b0;
		#(CLK_PERIOD/2);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2);
	end

	reg [7:0] tb_outputToXor_i;
	reg [19:0] tb_couterPixel_i;
	reg tb_ready_to_write_i;
	reg tb_xor_sig_i;
	reg tb_one_byte_dec_i;//useless
	reg [31:0] tb_dataToDecrypt_i;
	reg tb_enable_write_o;
	reg [1:0] tb_writeLoc_o;
	reg [7:0] tb_data_o;
	reg [19:0] tb_rc4_pix_num_o;


	RC4_Core_comb DUT (.outputToXor_i(tb_outputToXor_i),.couterPixel_i(tb_couterPixel_i),.ready_to_write_i(tb_ready_to_write_i),
			   .xor_sig_i(tb_xor_sig_i),.one_byte_dec_i(tb_one_byte_dec_i),.dataToDecrypt_i(tb_dataToDecrypt_i),.enable_write_o(tb_enable_write_o),
			   .writeLoc_o(tb_writeLoc_o),.data_o(tb_data_o),.rc4_pix_num_o(tb_rc4_pix_num_o));
	initial
	begin
	tb_outputToXor_i = 0;//
	tb_couterPixel_i = 0;
	tb_ready_to_write_i = 0;
	tb_xor_sig_i = 0;//
	tb_one_byte_dec_i = 0;
	tb_dataToDecrypt_i = 0;//
	tb_enable_write_o = 0;
	tb_writeLoc_o = 0;
	tb_data_o = 0;
	tb_rc4_pix_num_o = 0;
	@(negedge tb_clk);
	tb_dataToDecrypt_i = "HiPi";
	tb_outputToXor_i = 55;
	tb_xor_sig_i = 1;
	tb_couterPixel_i = 0;
	@(negedge tb_clk);
	tb_dataToDecrypt_i = "HiPi";
	tb_outputToXor_i = 556;
	tb_xor_sig_i = 0;
	tb_couterPixel_i = 0;
	//2nd
	@(negedge tb_clk);
	tb_dataToDecrypt_i = "HiPi";
	tb_outputToXor_i = 41;
	tb_xor_sig_i = 1;
	tb_couterPixel_i = 1;
	@(negedge tb_clk);
	tb_dataToDecrypt_i = "HiPi";
	tb_outputToXor_i = 556;
	tb_xor_sig_i = 0;
	tb_couterPixel_i = 0;
	//3rd
	@(negedge tb_clk);
	tb_dataToDecrypt_i = "HiPi";
	tb_outputToXor_i = 42;
	tb_xor_sig_i = 1;
	tb_couterPixel_i = 2;
	@(negedge tb_clk);
	tb_dataToDecrypt_i = "HiPi";
	tb_outputToXor_i = 32;
	tb_xor_sig_i = 0;
	tb_couterPixel_i = 0;
	//4tg
	@(negedge tb_clk);
	tb_dataToDecrypt_i = "HiPi";
	tb_outputToXor_i = 55;
	tb_xor_sig_i = 1;
	tb_couterPixel_i = 3;
	@(negedge tb_clk);
	tb_dataToDecrypt_i = "HiPi";
	tb_outputToXor_i = 556;
	tb_xor_sig_i = 0;
	tb_couterPixel_i = 2;
	

	end
endmodule
