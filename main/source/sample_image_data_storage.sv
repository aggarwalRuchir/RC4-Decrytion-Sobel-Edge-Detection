// $Id: $
// File name:   sample_image_data_storage.sv
// Created:     4/17/2017
// Author:      Gautam Rangarajan
// Lab Section: 337-002
// Version:     1.0  Initial Design Entry
// Description: sample image data storage module`

module sample_image_data_storage
(
	input wire clk,
	input wire n_rst,
	input wire [11:0]image_width,
	input wire SI_dfb,
	input wire [31:0]SI_rdata,
	input wire [19:0]ED_rpixNum,
	input wire fill_buff,
	output wire buff_filled,
	output wire [95:0]ED_rdata,
	output wire [19:0]SI_rpixNum,
	output wire [1:0]SI_mode
);

	typedef enum bit [3:0] {IDLE, READ1, COPY1, READ2, COPY2, READ3, COPY3, DONE} state_type;

	state_type curr_state, next_state;

	reg [95:0] curr_DATA, next_DATA;
	reg [19:0] SI_rpixNumTemp;
	
	always_ff @ (posedge clk, negedge n_rst)
	begin

        	if(n_rst == 0)
		begin
            	curr_state <= IDLE;
		curr_DATA <= '0;
		end
        	else 
		begin
            	curr_state <= next_state;
		curr_DATA <= next_DATA;
		end
    	end

	always_comb
	begin

		next_DATA = curr_DATA;
		next_state = curr_state;	
		SI_rpixNumTemp = 0;

		case(curr_state)

			IDLE:
				begin	
				if(fill_buff)
				begin
				next_state = READ1;
				end
				end
		
			READ1:
				begin
				SI_rpixNumTemp = ED_rpixNum;
				if(SI_dfb)
					next_state = COPY1;
				else
					next_state = READ1;
				end

			COPY1:
				begin
				next_DATA[31:0] = SI_rdata;
				next_state = READ2;
				end

			READ2:
				begin
				SI_rpixNumTemp = ED_rpixNum + image_width;
				if(SI_dfb)
				begin
					next_state = COPY2;
				end
				else
					next_state = READ2;
				end


			COPY2:
				begin
				next_DATA[63:32] = SI_rdata;
				next_state = READ3;
				end

			READ3:
				begin
				SI_rpixNumTemp = ED_rpixNum + (2 * image_width);
				if(SI_dfb)
				begin
					next_state = COPY3;
				end
				else
					next_state = READ3;
				end

			COPY3:
				begin
				next_DATA[95:64] = SI_rdata;
				next_state = DONE;
				end

			DONE:
				begin
				if(fill_buff == 0)
				begin
				next_state = IDLE;
				end
				end
		endcase


	end
				

	assign SI_mode = (((curr_state == READ1) || (curr_state == READ2) || (curr_state == READ3))? 2'b01 : 2'b00);
	assign buff_filled = ((curr_state == DONE)? 1 : 0);
	assign ED_rdata = curr_DATA;
	assign SI_rpixNum = SI_rpixNumTemp;

endmodule
