// $Id: $
// File name:   RC4_comb_pseudo_rand.sv
// Created:     4/1/2017
// Author:      John Student
// Lab Section: 03
// Version:     1.0  Initial Design Entry
// Description: .

module RC4_pseudo_rand_comb(
	input wire clk,
	input wire [7:0] locSafe_i,
	//input wire [7:0] counterJ_i,
	input wire [7:0] counterI_i,
	input wire clearCounterJ_i,
	input wire det_j_2_i,
	input wire det_j_i,
	input wire valReady_i,
	input wire gen_final_i,
	input wire end_i,
	input wire swap_i,
	input wire store_temp_i,
	input wire val_init_i,
	input wire [31:0] rc4_key_i,	
	input wire [7:0] temp_i,
	input wire [7:0] rdata_i,
	output reg [7:0] locEnd_o,
	output reg store_loc_o,
	//output reg [7:0] ncounterJ_o,
	output reg [7:0] raddr_o,
	output reg [7:0] wData_o,
	output reg [7:0] waddr_o,
	output reg swap_o,
	output reg read_enable_o,
	output reg write_enable_o
);

wire [7:0]counterJ_i;
reg [7:0] counterJ;
reg [7:0] ncounterJ_o;

always_comb
begin
	locEnd_o = 0;
	store_loc_o = 0;
	//ncounterJ_o = 0;
	raddr_o = 0;
	wData_o = 0;
	waddr_o = 0;
	swap_o = 0;
	read_enable_o = 0;
	write_enable_o = 0;

	if (clearCounterJ_i == 1)
	begin	
		ncounterJ_o = 0;
	end
	else if (det_j_i == 1)
	begin
		raddr_o = counterI_i;
		read_enable_o = 1;
		write_enable_o = 0;
		//ncounterJ_o = (counterJ_i + rdata_i + rc4_key_i[7:0]);
		
		if ( counterI_i % 4 == 0)
		begin
			ncounterJ_o = (counterJ_i + rdata_i + rc4_key_i[31:24]);//7:0
		end
		else if ( counterI_i % 4 == 1)
		begin
			ncounterJ_o = (counterJ_i + rdata_i + rc4_key_i[23:16]);//15:8
		end
		else if ( counterI_i % 4 == 2)
		begin
			ncounterJ_o = (counterJ_i + rdata_i + rc4_key_i[15:8]);//23:16
		end
		else
		begin
			ncounterJ_o = (counterJ_i + rdata_i + rc4_key_i[7:0]);//31:24
		end
		
	end
	else if (det_j_2_i == 1)
	begin
		raddr_o = counterI_i;
		read_enable_o = 1;
		ncounterJ_o = (counterJ_i + rdata_i) % 256;
	end
	else
	begin
		ncounterJ_o = counterJ_i;
	end

	if ( swap_i == 1)
	begin
		raddr_o = counterJ_i;
		waddr_o = counterI_i;
		swap_o = 1;
		read_enable_o = 0;
	end
	else
	begin
		swap_o = 0;
	end

	if (gen_final_i == 1)
	begin
		raddr_o = counterJ_i;
		read_enable_o = 1;
		locEnd_o = (temp_i + rdata_i) % 256;
		store_loc_o = 1;
	end
	if (store_temp_i == 1)
	begin
		read_enable_o = 1;
		raddr_o = counterI_i;
	end
	if (end_i == 1)
	begin
		store_loc_o = 0;
		raddr_o = locSafe_i;
		read_enable_o = 1;
	end
	if (valReady_i == 1)
		read_enable_o = 0;
	if (val_init_i == 1)
	begin
		waddr_o = counterI_i;
		wData_o = counterI_i;
		write_enable_o = 1;
	end
	else
	begin
		write_enable_o = 0;
	end

end



always_ff @(posedge clk)
begin
	counterJ <= ncounterJ_o;
end

assign counterJ_i = counterJ;
endmodule
