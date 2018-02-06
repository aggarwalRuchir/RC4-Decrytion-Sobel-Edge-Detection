// $Id: $
// File name:   RC4_gen_ps_state.sv
// Created:     4/11/2017
// Author:      John Student
// Lab Section: 03
// Version:     1.0  Initial Design Entry
// Description: .

module RC4_gen_ps_state(
	input wire clk,
	input wire n_rst_i,
	input wire genStateArr_i,
	input wire genVal_i,
	input wire [7:0] counterI_i,
	output reg sarrGenerated_o,
	output reg valReady_o,
	output reg clearCounterJ_o,
	output reg clear_i_o,
	output reg enable_counterI_o,
	output reg det_j_o,
	output reg swap_o,
	output reg det_j_2_o,
	output reg store_temp_o,
	output reg end_o,
	output reg gen_final_o,
	output reg val_init_o
);

typedef enum reg [4:0] 
{
	WAIT,
	VAL,
	CHECK_PERF,
	RESET,
	DET_J,
	SWAP,
	INTERMIDIAT_STATE,
	CHECK_COUT,
	DONE,
	WAIT_2,
	INCR_I,
	DET_J_2,
	SWAP_2,
	GEN_VAL,
	CALCULATE_OUTPUT,
	STORE_LOC,
	WAIT_FINAL
} state_type;

state_type cur_state;
state_type nxt_state;

always_ff  @ (posedge clk, negedge n_rst_i)
begin
	if(n_rst_i == 0)
	begin
		cur_state <= WAIT;
		//nxt_state <= IDLE;
	end
	else
		cur_state <= nxt_state;
end

always_comb
begin
	nxt_state = cur_state;

        sarrGenerated_o = 1'b0;
        valReady_o = 1'b0;
        clearCounterJ_o = 2'b00;
        clear_i_o = 1'b0;
	enable_counterI_o = 1'b0;
	det_j_o = 1'b0;
	swap_o = 1'b0;
	det_j_2_o = 1'b0;
	store_temp_o = 1'b0;
	end_o = 1'b0;
	gen_final_o = 1'b0;
	val_init_o = 1'b0;

	case (cur_state)
	WAIT:
	begin
		if(genStateArr_i)
		begin
			nxt_state = VAL;
		end
		else
		begin
			nxt_state = WAIT;
		end
        	clearCounterJ_o = 1'b1;
        	clear_i_o = 1'b1;
	end

	VAL:
	begin
		nxt_state = CHECK_PERF;
        	clearCounterJ_o = 1'b0;
        	clear_i_o = 1'b0;
		val_init_o = 1'b1;
		enable_counterI_o = 1'b0;
	end

	CHECK_PERF:
	begin
		if(counterI_i != 255)
		begin
			nxt_state = VAL;
		end
		else
		begin
			nxt_state = RESET;
		end
        	enable_counterI_o = 1'b1;
        	clear_i_o = 1'b0;
	end

	RESET:
	begin
		nxt_state = DET_J;
        	clearCounterJ_o = 1'b1;
        	clear_i_o = 1'b1;
	end

	DET_J:
	begin
		nxt_state = SWAP;
        	clearCounterJ_o = 1'b0;
        	clear_i_o = 1'b0;
		det_j_o = 1'b1;
	end


	SWAP:
	begin
		nxt_state = INTERMIDIAT_STATE;
        	swap_o = 1'b1;
		det_j_o = 1'b0;
	end
	
	INTERMIDIAT_STATE:
	begin
		nxt_state = CHECK_COUT;
        	swap_o = 1'b0;
		enable_counterI_o = 1'b0;
	end

	CHECK_COUT:
	begin
		if(counterI_i != 255)
		begin
			nxt_state = DET_J;
		end
		else
		begin
			nxt_state = DONE;
		end
        	enable_counterI_o = 1'b1;
	end


	DONE:
	begin
		nxt_state = WAIT_2;
        	sarrGenerated_o = 1'b1;
		clear_i_o = 1'b1;
		clearCounterJ_o = 1'b1;
	end

	WAIT_2:
	begin
		if(genVal_i == 1)
		begin
			nxt_state = INCR_I;
		end
		else
		begin
			nxt_state = WAIT_2;
		end
        	sarrGenerated_o = 1'b0;
		clear_i_o = 1'b0;
		clearCounterJ_o = 1'b0;
	end

	INCR_I:
	begin
		nxt_state = DET_J_2;
        	enable_counterI_o = 1'b1;
		valReady_o = 1'b0;
		gen_final_o = 1'b0;
	end

	DET_J_2:
	begin
		nxt_state = SWAP_2;
        	det_j_2_o = 1'b1;
		enable_counterI_o = 1'b0;
	end

	SWAP_2:
	begin
		nxt_state = GEN_VAL;
        	swap_o = 1'b1;
		det_j_2_o = 1'b0;
	end

	GEN_VAL:
	begin
		nxt_state = CALCULATE_OUTPUT;
        	store_temp_o = 1'b1;
		swap_o = 1'b0;
	end


	CALCULATE_OUTPUT:
	begin
		nxt_state = STORE_LOC;
        	gen_final_o = 1'b1;
		store_temp_o = 1'b0;
	end


	STORE_LOC:
	begin
		nxt_state = WAIT_FINAL;
        	end_o = 1'b1;
		gen_final_o = 1'b0;
	end


	WAIT_FINAL:
	begin
		if(genVal_i == 1)
		begin
			nxt_state = INCR_I;
		end
		else
		begin
			nxt_state = WAIT_FINAL;
		end
        	valReady_o = 1'b1;
		end_o = 1'b0;
	end

	endcase

end
endmodule
