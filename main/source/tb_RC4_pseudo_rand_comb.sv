// $Id: $
// File name:   tb_RC4_comb_pseudo_rand.sv
// Created:     4/8/2017
// Author:      John Student
// Lab Section: 03
// Version:     1.0  Initial Design Entry
// Description: .
`timescale 1ns / 100ps
module tb_RC4_pseudo_rand_comb();
	localparam CLK_PERIOD = 20;
	reg tb_clk;
	always
	begin
		tb_clk = 1'b0;
		#(CLK_PERIOD/2);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2);
	end
	reg [7:0] tb_locSafe_i;
	reg [7:0] tb_counterJ_i;
	reg [7:0] tb_counterI_i;
	reg tb_clearCounterJ_i;
	reg tb_det_j_2_i;
	reg tb_det_j_i;
	reg tb_valReady_i;
	reg tb_gen_final_i;
	reg tb_end_i;
	reg tb_swap_i;
	reg tb_store_temp_i;
	reg tb_val_init_i;
	reg [31:0] tb_rc4_key_i;	
	reg [7:0] tb_temp_i;
	reg [7:0] tb_rdata_i;
	reg [7:0] tb_locEnd_o;
	reg tb_store_loc_o;
	reg [7:0] tb_ncounterJ_o;
	reg [7:0] tb_raddr_o;
	reg [7:0] tb_wData_o;
	reg [7:0] tb_waddr_o;
	reg tb_swap_o;
	reg tb_read_enable_o;
	reg tb_write_enable_o;
	
	RC4_pseudo_rand_comb DUT (.locSafe_i(tb_locSafe_i),.counterJ_i(tb_counterJ_i),.counterI_i(tb_counterI_i),.clearCounterJ_i(tb_clearCounterJ_i),
				  .det_j_2_i(tb_det_j_2_i),.det_j_i(tb_det_j_i),.valReady_i(tb_valReady_i),.gen_final_i(tb_gen_final_i),.end_i(tb_end_i),.swap_i(tb_swap_i),.store_temp_i(tb_store_temp_i),
				  .val_init_i(tb_val_init_i),.rc4_key_i(tb_rc4_key_i),.temp_i(tb_temp_i),.rdata_i(tb_rdata_i),.locEnd_o(tb_locEnd_o),.store_loc_o(tb_store_loc_o),.ncounterJ_o(tb_ncounterJ_o),.raddr_o(tb_raddr_o),
				  .wData_o(tb_wData_o),.waddr_o(tb_waddr_o),.swap_o(tb_swap_o),.read_enable_o(tb_read_enable_o),.write_enable_o(tb_write_enable_o));

initial
begin
	//Setting everyhting to 0.
	//@(negedge tb_clk);
	tb_locSafe_i = 0;
	tb_counterJ_i  = 0;
	tb_counterI_i = 0;
	tb_clearCounterJ_i = 0;
	tb_det_j_2_i = 0;
	tb_det_j_i = 0;
	tb_valReady_i = 0;
	tb_gen_final_i = 0;
	tb_end_i = 0;
	tb_swap_i = 0;
	tb_store_temp_i = 0;
	tb_val_init_i = 0;
	tb_rc4_key_i = 0;	
	tb_temp_i = 0;
	tb_rdata_i = 0;
	tb_rc4_key_i = "DR.J";

	@(negedge tb_clk);
	//WAIT STATE FOR FSM
	tb_clearCounterJ_i = 1;
	@(negedge tb_clk);
	//VAL STATE INITILIZING STATE ARRAY CURRENT VALUE 1
	tb_clearCounterJ_i = 0;
	tb_val_init_i = 1;
	tb_counterI_i = 1;
	@(negedge tb_clk);
	tb_val_init_i = 0;
	@(negedge tb_clk);
	//VAL STATE INITILIZING STATE ARRAY CURRENT VALUE 2
	tb_clearCounterJ_i = 0;
	tb_val_init_i = 1;
	tb_counterI_i = 2;
	@(negedge tb_clk);
	tb_val_init_i = 0;
	@(negedge tb_clk);
	//RESET STATE
	tb_clearCounterJ_i = 1;
	$info("Finished testing the initialization of 255 state arr");
	@(negedge tb_clk);
	//SIMULATION OF DET_J AS IF I AM READIGN VAL FROM SARR
	tb_clearCounterJ_i = 0;
	tb_counterJ_i = 2;
	tb_counterI_i = 3;
	tb_rdata_i = 10;
	tb_det_j_i = 1;
	@(negedge tb_clk);
	//SWAPPING SUMULATION
	tb_counterJ_i = 10;
	tb_swap_i = 1;
	tb_det_j_i = 0;
	@(negedge tb_clk);
	tb_clearCounterJ_i = 0;
	tb_swap_i = 0;
	tb_counterI_i = 4;
	tb_rdata_i = 15;
	tb_det_j_i = 1;
	@(negedge tb_clk);
	tb_counterJ_i = 10;
	tb_swap_i = 1;
	tb_det_j_i = 0;
	$info("Finished testing the initialization ofter going second time through the 255 array");
	@(negedge tb_clk);
	tb_counterJ_i = 40;
	tb_rdata_i = 244;
	tb_det_j_2_i = 1;
	@(negedge tb_clk);
	//SWAP
	tb_det_j_2_i = 0;
	tb_counterI_i = 23;
	tb_counterJ_i =22;
	tb_swap_i = 1;
	@(negedge tb_clk);
	//STORING TEMP VALUE
	tb_swap_i = 0;
	tb_store_temp_i = 1;
	tb_counterI_i = 69;
	if(tb_read_enable_o == 1)
	begin
		$info("correct assertion of read");
	end	
	if(tb_raddr_o == 69)
	begin	
		$info("correct address");
	end

	@(negedge tb_clk);
	//STORING TEMP VALUE
	//tb_swap_i = 0;
	tb_store_temp_i = 0;
	tb_gen_final_i = 1;
	tb_temp_i = 23;
	tb_counterJ_i = 231;

end
endmodule
