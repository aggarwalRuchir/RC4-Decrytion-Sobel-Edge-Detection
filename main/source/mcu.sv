// $Id: $
// File name:   mcu.sv
// Created:     4/16/2017
// Author:      Ruchir Aggarwal
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: File for code of MCU(Main control unit)

module mcu
(
	input wire clk,
	input wire n_rst,
	input wire start,
	input wire RC4_done,
	input wire ED_done,
	input wire error,
	output wire RC4_start,
	output wire ED_start,
	output wire process_complete
);

typedef enum logic [2:0] {IDLE, DECRYPT_IMAGE, IMAGE_DECRYPTED, START_EDGEDETECTION, PROCESS_COMPLETE} stateType;
stateType state;
stateType nxt_state;

always_ff @(negedge n_rst, posedge clk)
begin: REG_LOGIC
	if(n_rst == 1'b0) begin
		state <= IDLE;
	end
	else begin
		state <= nxt_state;
	end
end

always_comb
begin : NXT_LOGIC
	//Set the default value
  	nxt_state = state;

    	//Define the override/special case condition
	case(state)
		IDLE: begin
			if (start == 1'b1)
				nxt_state = DECRYPT_IMAGE;
			else 
				nxt_state = IDLE;
		end
		DECRYPT_IMAGE: begin
			if (RC4_done == 1'b1)
				nxt_state = IMAGE_DECRYPTED;
			else
				nxt_state = DECRYPT_IMAGE;

			if(error == 1)
			begin
				nxt_state = IDLE;
			end
		end
		IMAGE_DECRYPTED: begin
			nxt_state = START_EDGEDETECTION;
		end
		START_EDGEDETECTION: begin
			if (ED_done == 1'b1)
				nxt_state = PROCESS_COMPLETE;
			else
				nxt_state = START_EDGEDETECTION;

			if(error == 1)
			begin
				nxt_state = IDLE;
			end
		end
		PROCESS_COMPLETE: begin
			nxt_state = IDLE;
		end
	endcase
end

assign	RC4_start = ((state == DECRYPT_IMAGE) ? 1'b1 : 1'b0);
assign	ED_start = ((state == START_EDGEDETECTION) ? 1'b1 : 1'b0);
assign	process_complete = ((state == PROCESS_COMPLETE) ? 1'b1 : 1'b0);

endmodule
