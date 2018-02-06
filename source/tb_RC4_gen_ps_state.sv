// $Id: $
// File name:   tb_RC4_gen_ps_state.sv
// Created:     4/12/2017
// Author:      John Student
// Lab Section: 03
// Version:     1.0  Initial Design Entry
// Description: .
`timescale 1ns / 100ps
module tb_RC4_gen_ps_state();
	localparam CLK_PERIOD = 20;
	reg tb_clk;
	always
	begin
		tb_clk = 1'b0;
		#(CLK_PERIOD/2);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2);
	end


	reg tb_n_reset_i;
	reg tb_genStateArr_i;
	reg tb_genVal_i;
	reg [7:0] tb_counterI_i;
	reg tb_sarrGenerated_o;
	reg tb_valReady_o;
	reg tb_clearCounterJ_o;
	reg tb_clear_i_o;
	reg tb_enable_counterI_o;
	reg tb_det_j_o;
	reg tb_swap_o;
	reg tb_det_j_2_o;
	reg tb_store_temp_o;
	//reg tb_store_loc_o;
	reg tb_end_o;
	reg tb_gen_final_o;
	reg tb_val_init_o;
	
	RC4_gen_ps_state DUT (.clk(tb_clk),.n_rst_i(tb_n_reset_i),.genStateArr_i(tb_genStateArr_i),.genVal_i(tb_genVal_i),.counterI_i(tb_counterI_i),.sarrGenerated_o(tb_sarrGenerated_o)
				,.valReady_o(tb_valReady_o),.clearCounterJ_o(tb_clearCounterJ_o),.clear_i_o(tb_clear_i_o),.enable_counterI_o(tb_enable_counterI_o),
				.det_j_o(tb_det_j_o),.swap_o(tb_swap_o),.det_j_2_o(tb_det_j_2_o),.store_temp_o(tb_store_temp_o),.end_o(tb_end_o),
				.gen_final_o(tb_gen_final_o),.val_init_o(tb_val_init_o));

initial
begin
	//Setting everyhting to 0.
	//@(negedge tb_clk);
	//WAIT
	tb_n_reset_i = 0;
	tb_genStateArr_i = 0;
	tb_genVal_i = 0;
	tb_counterI_i = 0;
	@(negedge tb_clk);
	//WAIT
	tb_n_reset_i = 1;
	tb_genStateArr_i = 1;
	tb_genVal_i = 0;
	tb_counterI_i = 0;
	@(negedge tb_clk);
	//VAL
	tb_n_reset_i = 1;
	tb_genStateArr_i = 0;
	tb_genVal_i = 0;
	tb_counterI_i = 0;
	@(negedge tb_clk);
	//CHECK_PERF
	tb_n_reset_i = 1;
	tb_genStateArr_i = 0;
	tb_genVal_i = 0;
	tb_counterI_i = 1;
	@(negedge tb_clk);
	//VAL
	tb_n_reset_i = 1;
	tb_genStateArr_i = 0;
	tb_genVal_i = 0;
	tb_counterI_i = 1;
	@(negedge tb_clk);
	//CHECK_PERF
	tb_n_reset_i = 1;
	tb_genStateArr_i = 0;
	tb_genVal_i = 0;
	tb_counterI_i = 255;
	@(negedge tb_clk);
	//RESET
	tb_counterI_i = 0;
	@(negedge tb_clk);
	//DET_J
	@(negedge tb_clk);
	//SWAP
	@(negedge tb_clk);
	//INTERMIDIAT_STATE
	@(negedge tb_clk);
	//CHECK_COUT
	tb_counterI_i = 255;
	@(negedge tb_clk);
	//RESET
	@(negedge tb_clk);
	//DET_J
	@(negedge tb_clk);
	//SWAP
	@(negedge tb_clk);
	//INTERMIDIAT_STATE
	@(negedge tb_clk);
	//CHECK_COUT
	@(negedge tb_clk);
	//DONE
	@(negedge tb_clk);
	//WAIT_2
	$info("Generation of one value");
	tb_genVal_i = 1;
	@(negedge tb_clk);
	tb_genVal_i = 0;
	//INCR_I
	@(negedge tb_clk);
	//DET_J_2
	@(negedge tb_clk);
	//SWAP_2
	@(negedge tb_clk);
	//GET_VAL
	@(negedge tb_clk);
	//CALCULATE_OUTPUT
	@(negedge tb_clk);
	//STOREE_LOC
	@(negedge tb_clk);
	//WAIT_FINAL



end
endmodule