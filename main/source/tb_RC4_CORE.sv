// $Id: $
// File name:   tb_RC4_CORE.sv
// Created:     4/22/2017
// Author:      John Student
// Lab Section: 03
// Version:     1.0  Initial Design Entry
// Description: .
`timescale 1ns / 100ps
module tb_RC4_CORE();
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
	reg [31:0] tb_rc4_rdata_i;
	reg tb_sarrGenerated_i;
	reg tb_valReady_i;
	reg [7:0] tb_outputToXor_i;
	reg [19:0] tb_img_width_i;
	reg [19:0] tb_img_hight_i;
	reg [31:0] tb_rc4_wdata_o;
	reg [19:0] tb_rc4_pix_num_o;
	reg [1:0] tb_rc4_mode_o;
	reg tb_rc4_done_o;
	reg tb_genVal_o;
	reg tb_genStateArr_o;

	 RC4_CORE DUT (.clk(tb_clk),.n_rst_i(tb_n_rst_i),.rc4_dfb_i(tb_rc4_dfb_i),.rc4_start_i(tb_rc4_start_i),.rc4_rdata_i(tb_rc4_rdata_i),.sarrGenerated_i(tb_sarrGenerated_i),
			.valReady_i(tb_valReady_i),.outputToXor_i(tb_outputToXor_i),.img_width_i(tb_img_width_i),.img_hight_i(tb_img_hight_i),
			.rc4_wdata_o(tb_rc4_wdata_o),.rc4_pix_num_o(tb_rc4_pix_num_o),.rc4_mode_o(tb_rc4_mode_o),
			.rc4_done_o(tb_rc4_done_o),.genVal_o(tb_genVal_o),.genStateArr_o(tb_genStateArr_o));

initial
begin
	tb_n_rst_i = 0;
	tb_rc4_dfb_i = 0;
	tb_rc4_start_i = 0;
	tb_rc4_rdata_i = 0;
	tb_sarrGenerated_i = 0;
	tb_valReady_i = 0;
	tb_outputToXor_i = 0;;
	tb_img_width_i = 0;
	tb_img_hight_i = 0;
	@(negedge tb_clk);
	tb_n_rst_i = 1;
	tb_img_width_i = 3;
	tb_img_hight_i = 3;
	@(negedge tb_clk);
	tb_rc4_start_i = 1;
	@(negedge tb_clk);
	tb_rc4_start_i = 0;
	//INIT
	@(negedge tb_clk);
	tb_sarrGenerated_i = 1;
	//READ_DATA_1
	@(negedge tb_clk);
	tb_sarrGenerated_i = 0;
	//READ_DATA_2	
	@(negedge tb_clk);
	tb_rc4_rdata_i = "HiPi";
	@(negedge tb_clk);
	tb_rc4_dfb_i = 1;

	//0th byte
	//WAIT_PS_VAL
	@(negedge tb_clk);
	tb_rc4_dfb_i = 0;
	@(negedge tb_clk);
	tb_valReady_i = 1;
	//XOR
	tb_outputToXor_i = 55;
	@(negedge tb_clk);
	tb_valReady_i = 0;
	//ONE_BYTE_DEC
	@(negedge tb_clk);
	//INC
	@(negedge tb_clk);

	//1st byte
	//WAIT_PS_VAL
	@(negedge tb_clk);
	tb_rc4_dfb_i = 0;
	@(negedge tb_clk);
	tb_valReady_i = 1;
	//XOR
	tb_outputToXor_i = 41;
	@(negedge tb_clk);
	tb_valReady_i = 0;
	//ONE_BYTE_DEC
	@(negedge tb_clk);
	//INC
	@(negedge tb_clk);


	//2nd byte
	//WAIT_PS_VAL
	@(negedge tb_clk);
	tb_rc4_dfb_i = 0;
	@(negedge tb_clk);
	tb_valReady_i = 1;
	//XOR
	tb_outputToXor_i = 42;
	@(negedge tb_clk);
	tb_valReady_i = 0;
	//ONE_BYTE_DEC
	@(negedge tb_clk);
	//INC
	@(negedge tb_clk);

	//3rd byte
	//WAIT_PS_VAL
	@(negedge tb_clk);
	tb_rc4_dfb_i = 0;
	@(negedge tb_clk);
	tb_valReady_i = 1;
	//XOR
	tb_outputToXor_i = 55;
	@(negedge tb_clk);
	tb_valReady_i = 0;
	//ONE_BYTE_DEC
	@(negedge tb_clk);
	//INC

	//READY_TO_WRITE
	@(negedge tb_clk);
	@(negedge tb_clk);
	@(negedge tb_clk);
	tb_rc4_dfb_i = 1;
	@(negedge tb_clk);
	tb_rc4_dfb_i = 0;
	//WRITE_2
	@(negedge tb_clk);
	

end
endmodule
