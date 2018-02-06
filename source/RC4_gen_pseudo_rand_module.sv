// $Id: $
// File name:   RC4_gen_pseudo_rand_mod.sv
// Created:     4/12/2017
// Author:      John Student
// Lab Section: 03
// Version:     1.0  Initial Design Entry
// Description: .

module RC4_gen_pseudo_rand_module(
	input wire clk,
	input wire n_rst,
	input wire genStateArr_i,
	input wire genVal_i,
	input wire [31:0] rc4_key_i_,
	output reg [7:0] outputToXor_o,
	output reg sarrGenerated_o_,
	output reg valReady_o_
);


	wire [7:0] locSafe;
	wire [7:0] counterJ;
	wire [7:0] counterI;
	wire clearCouterJ;
	wire det_j_2;
	wire det_j;
	//reg valReady;
	wire gen_final;
	wire end_;
	wire swap_1;
	wire store_temp;
	wire val_init;
	wire [7:0] temp;
	wire [7:0] rdata;
	wire [7:0] locEnd;
	wire store_loc;
	wire [7:0] ncouterJ;
	wire [7:0] raddr;
	wire [7:0] wData;
	wire [7:0] waddr;
	wire swap;
	wire read_enable;
	wire write_enable;
	wire clear_i;
	wire enable_counterI;


	RC4_pseudo_rand_comb RC4_PSEUDO_RAND_COMB (.clk(clk),.locSafe_i(locSafe),.counterI_i(counterI),.clearCounterJ_i(clearCouterJ),
				  .det_j_2_i(det_j_2),.det_j_i(det_j),.valReady_i(valReady_o_),.gen_final_i(gen_final),.end_i(end_),.swap_i(swap_1),.store_temp_i(store_temp),
				  .val_init_i(val_init),.rc4_key_i(rc4_key_i_),.temp_i(temp),.rdata_i(rdata),.locEnd_o(locEnd),.store_loc_o(store_loc),.raddr_o(raddr),
				  .wData_o(wData),.waddr_o(waddr),.swap_o(swap),.read_enable_o(read_enable),.write_enable_o(write_enable));

	RC4_gen_ps_state RC4_GEN_PS_STATE (.clk(clk),.n_rst_i(n_rst),.genStateArr_i(genStateArr_i),.genVal_i(genVal_i),.counterI_i(counterI),.sarrGenerated_o(sarrGenerated_o_),
				.valReady_o(valReady_o_),.clearCounterJ_o(clearCouterJ),.clear_i_o(clear_i),.enable_counterI_o(enable_counterI),
				.det_j_o(det_j),.swap_o(swap_1),.det_j_2_o(det_j_2),.store_temp_o(store_temp),.end_o(end_),
				.gen_final_o(gen_final),.val_init_o(val_init));

	sarr SARR (.clk(clk),.waddr_i(waddr),.wdata_i(wData),.swap_i(swap),.wenable_i(write_enable),.renable_i(read_enable),.raddr_i(raddr),.rdata_o(rdata));


	//counterJ COUNTERJ (.clk(clk),.ncouterJ_i(ncouterJ),.counterJ_o(counterJ));

	counterI COUNTERI 
	(
  		.clk          (clk),
  		.n_rst        (n_rst),
  		.clear        (clear_i),
  		.count_enable (enable_counterI),
  		.rollover_val (8'b11111111),
  		.count_out    (counterI),
  		.rollover_flag()
  	);


	locSafe LOCSAFE(
		.clk(clk),
		.locEnd_i(locEnd),
		.store_loc_i(store_loc),
		.locSafe_o(locSafe)
	);

	temp TEMP(
		.clk(clk),
		.rdata_i(rdata),
		.store_temp_i(store_temp),
		.temp_o(temp)
	);

	outputToXor OUTPUTTOXOR(
		.clk(clk),
		.rdata_i(rdata),
		.end_i(end_),
		.outputToXor_o(outputToXor_o)
	);
/*
always_comb
begin
	locSafe = 0;
	counterJ = 0;
	counterI = 0;
	clearCouterJ = 0;
	det_j_2 = 0;
	det_j = 0;
	//reg valReady;
	gen_final = 0;
	end_ = 0;
	swap_1 = 0;
	store_temp = 0;
	val_init = 0;
	temp = 0;
	rdata = 0;
	locEnd = 0;
	store_loc = 0;
	ncouterJ = 0;
	raddr = 0;
	wData = 0;
	waddr = 0;
	swap = 0;
	read_enable = 0;
	write_enable = 0;
	clear_i = 0;
	enable_counterI = 0;

end
*/
endmodule
