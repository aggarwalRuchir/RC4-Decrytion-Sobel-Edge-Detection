// $Id: $
// File name:   RC4_CORE_STATE_MACH.sv
// Created:     4/21/2017
// Author:      John Student
// Lab Section: 03
// Version:     1.0  Initial Design Entry
// Description: .
module RC4_CORE_STATE_MACH(
	input wire clk,
	input wire n_rst_i,
	input wire rc4_dfb_i,
	input wire rc4_start_i,
	input wire sarrGenerated_i,
	input wire valReady_i,
	input wire [19:0] img_width_i,
	input wire [19:0] img_hight_i,
	input wire [19:0] counterPixel_i,
	output reg [1:0] rc4_mode_o,
	output reg rc4_done_o,
	output reg enable_counter_pix_o,
	output reg clearPixels_o,
	output reg ready_to_write_o,
	output reg xor_sig_o,
	output reg ready_data_o,
	output reg genStateArr_o,
	output reg genVal_o,
	output reg ready_to_read_o
);

typedef enum reg [3:0] 
{
	WAIT,
	INIT,
	READ_DATA_1,
	READ_DATA_2,
	READ_DATA_3,
	WAIT_PS_VAL,
	XOR,
	ONE_BYTE_DEC,
	INC,
	NOT_FINISHED,
	READY_TO_WRITE,
	WRITE_2,
	DONE
} state_type;

state_type cur_state;
state_type nxt_state;

always_ff  @ (posedge clk, negedge n_rst_i)
begin
	if(n_rst_i == 0)
	begin
		cur_state <= WAIT;
	end
	else
		cur_state <= nxt_state;
end

always_comb
begin
	nxt_state = cur_state;
	ready_to_read_o = 0;

	//rc4_pix_num_o = 0;
	rc4_mode_o = 0;
	rc4_done_o = 0;
	enable_counter_pix_o = 0;
	clearPixels_o = 0;
	ready_to_write_o = 0;
	xor_sig_o = 0;
	ready_data_o = 0;
	genStateArr_o = 0;
	genVal_o = 0;

	case (cur_state)
	WAIT:
	begin
		if(rc4_start_i == 1)
		begin
			nxt_state = INIT;
		end
		else
		begin
			nxt_state = WAIT;
		end
	end

	INIT:
	begin
		if(sarrGenerated_i == 1)
		begin
			nxt_state = READ_DATA_1;
		end
		else
		begin
			nxt_state = INIT;
		end
		genStateArr_o = 1;
		clearPixels_o = 1;
		rc4_done_o = 0;
	end

	READ_DATA_1:
	begin
		nxt_state = READ_DATA_2;
		rc4_mode_o = 2'b01;
		//rc4_pix_num_o = counterPixel_i;
		ready_to_read_o = 1;
		genVal_o = 1;
		clearPixels_o = 0;
	end

	READ_DATA_2:
	begin
		if(rc4_dfb_i == 1)
		begin
			nxt_state = READ_DATA_3;
		end
		else
		begin
			nxt_state = READ_DATA_2;
		end
		genVal_o = 0;
		ready_to_read_o = 0;
	end

	READ_DATA_3:
	begin
		nxt_state = WAIT_PS_VAL;
		rc4_mode_o = 2'b00;
		ready_data_o = 1;
	end

	WAIT_PS_VAL:
	begin
		if(valReady_i == 1)
		begin
			nxt_state = XOR;
		end
		else
		begin
			nxt_state = WAIT_PS_VAL;
		end
		genVal_o = 0;
		ready_data_o = 0;
	end

	XOR:
	begin
		nxt_state = ONE_BYTE_DEC;
		xor_sig_o = 1;
	end

	ONE_BYTE_DEC:
	begin
		nxt_state = INC;
		xor_sig_o = 0;
		enable_counter_pix_o = 1;
	end


	INC:
	begin
		if(counterPixel_i % 4 == 0)
		begin
			nxt_state = READY_TO_WRITE;
		end
		else
		begin
			nxt_state = NOT_FINISHED;
		end
		enable_counter_pix_o = 0;
	end

	NOT_FINISHED:
	begin
		nxt_state = WAIT_PS_VAL;
		genVal_o = 1;
		enable_counter_pix_o = 0;
	end

	READY_TO_WRITE:
	begin
		if(rc4_dfb_i == 1)
		begin
			nxt_state = WRITE_2;
		end
		else
		begin
			nxt_state = READY_TO_WRITE;
		end
		rc4_mode_o = 2'b10;
		ready_to_write_o = 1;
		enable_counter_pix_o = 0;
	end

	WRITE_2:
	begin
		if(counterPixel_i == img_hight_i * img_width_i)
		begin
			nxt_state = DONE;
		end
		else
		begin
			nxt_state = READ_DATA_1;
		end
		rc4_mode_o = 2'b00;
	end

	DONE:
	begin
		if(rc4_start_i)
		begin
			nxt_state = INIT;
		end
		else
		begin
			nxt_state = DONE;
		end
		rc4_done_o = 1;
	end

	endcase

end
endmodule
