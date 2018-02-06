// $Id: $
// File name:   tb_RC4_CORE_STATE_MACH.sv
// Created:     4/22/2017
// Author:      John Student
// Lab Section: 03
// Version:     1.0  Initial Design Entry
// Description: .
`timescale 1ns / 100ps
module tb_RC4_CORE_STATE_MACH();
	localparam CLK_PERIOD = 35;
	reg tb_clk;
	always
	begin
		tb_clk = 1'b0;
		#(CLK_PERIOD/2);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2);
	end


	reg tb_n_rst_i;
	reg tb_rc4_dfb_i;
	reg tb_rc4_start_i;
	reg tb_sarrGenerated_i;
	reg tb_valReady_i;
	reg [19:0] tb_img_width_i;
	reg [19:0] tb_img_hight_i;
	reg [19:0] tb_counterPixel_i;
	reg tb_ready_to_read_o;
	reg [1:0] tb_rc4_mode_o;
	reg tb_rc4_done_o;
	reg tb_enable_counter_pix_o;
	reg tb_clearPixels_o;
	reg tb_ready_to_write_o;
	reg tb_xor_sig_o;
	reg tb_ready_data_o;
	reg tb_genStateArr_o;
	reg tb_genVal_o;

	RC4_CORE_STATE_MACH DUT (.clk(tb_clk),.n_rst_i(tb_n_rst_i),.rc4_dfb_i(tb_rc4_dfb_i),.rc4_start_i(tb_rc4_start_i),.sarrGenerated_i(tb_sarrGenerated_i),.valReady_i(tb_valReady_i)
				,.img_width_i(tb_img_width_i),.img_hight_i(tb_img_hight_i),.counterPixel_i(tb_counterPixel_i)
				,.ready_to_read_o(tb_ready_to_read_o),.rc4_mode_o(tb_rc4_mode_o),.rc4_done_o(tb_rc4_done_o)
				,.enable_counter_pix_o(tb_enable_counter_pix_o),.clearPixels_o(tb_clearPixels_o),.ready_to_write_o(tb_ready_to_write_o)
				,.xor_sig_o(tb_xor_sig_o),.ready_data_o(tb_ready_data_o),.genStateArr_o(tb_genStateArr_o),.genVal_o(tb_genVal_o));

	initial	
	begin
	@(negedge tb_clk);
	tb_n_rst_i = 0;
	tb_rc4_dfb_i = 0;
	tb_rc4_start_i = 0;
	tb_sarrGenerated_i = 0;
	tb_valReady_i = 0;
	tb_img_width_i = 3;
	tb_img_hight_i = 3;
	tb_counterPixel_i = 0;
	tb_ready_to_read_o = 0;
	//INIT
	@(negedge tb_clk);
	tb_n_rst_i = 1;
	tb_rc4_start_i = 1;
	@(negedge tb_clk);
	tb_rc4_start_i = 0;
	@(negedge tb_clk);
	tb_sarrGenerated_i = 1;
	//READ DATA 1
	@(negedge tb_clk);
	tb_sarrGenerated_i = 0;
	//READ DATA 2
	@(negedge tb_clk);
	tb_rc4_dfb_i = 1;
	@(negedge tb_clk);

	//0TH BYTE
	//WAIT_PS_VAL
	@(negedge tb_clk);
	tb_rc4_dfb_i = 0;
	tb_valReady_i = 1;
	@(negedge tb_clk);
	tb_valReady_i = 0;
	//XOR
	@(negedge tb_clk);
	//ONE_BYTE_DEC
	@(negedge tb_clk);
	//INC
	tb_counterPixel_i = tb_counterPixel_i + 1;
	@(negedge tb_clk);
	//NOT FINISHED
	@(negedge tb_clk);

	//1ST BYTE
	//WAIT_PS_VAL
	@(negedge tb_clk);
	tb_rc4_dfb_i = 0;
	tb_valReady_i = 1;
	@(negedge tb_clk);
	tb_valReady_i = 0;
	//XOR
	@(negedge tb_clk);
	//ONE_BYTE_DEC
	@(negedge tb_clk);
	//INC
	tb_counterPixel_i = tb_counterPixel_i + 1;
	@(negedge tb_clk);
	//NOT FINISHED
	@(negedge tb_clk);
	
	//2ND BYTE
	//WAIT_PS_VAL
	@(negedge tb_clk);
	tb_rc4_dfb_i = 0;
	tb_valReady_i = 1;
	@(negedge tb_clk);
	tb_valReady_i = 0;
	//XOR
	@(negedge tb_clk);
	//ONE_BYTE_DEC
	@(negedge tb_clk);
	//INC
	tb_counterPixel_i = tb_counterPixel_i + 1;
	@(negedge tb_clk);
	//NOT FINISHED
	@(negedge tb_clk);
	
	//3RD BYTE
	//WAIT_PS_VAL
	@(negedge tb_clk);
	tb_rc4_dfb_i = 0;
	tb_valReady_i = 1;
	@(negedge tb_clk);
	tb_valReady_i = 0;
	//XOR
	@(negedge tb_clk);
	//ONE_BYTE_DEC
	@(negedge tb_clk);
	//INC
	tb_counterPixel_i = tb_counterPixel_i + 1;
	@(negedge tb_clk);
	//NOT FINISHED
	@(negedge tb_clk);


	//4TH BYTE
	//WAIT_PS_VAL
	@(negedge tb_clk);
	@(negedge tb_clk);
	tb_rc4_dfb_i = 1;
	@(negedge tb_clk);
	tb_rc4_dfb_i = 0;
	tb_counterPixel_i = 8;
	@(negedge tb_clk);
	@(negedge tb_clk);
	@(negedge tb_clk);
	end

endmodule
