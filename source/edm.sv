// $Id: $
// File name:   edm.sv
// Created:     4/17/2017
// Author:      Ribhav Agarwal
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: This is the detection module file

module edm (
	input wire clk,
	input wire n_rst,
	input wire ED_start,
	input wire ED_dfb,
	input wire buff_filled,
	input wire [11:0] image_width,
	input wire [11:0] image_height,
	input reg [95:0] ED_rdata,
	output reg fill_buff,
	output reg ED_done,
	output reg [1:0] ED_mode,
	output reg [19:0] ED_rpixnum,
	output reg [19:0] ED_wpixnum,
	output wire [15:0] ED_wdata
);

reg unsigned [7:0] s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12;
reg [95:0] curr_buffData, next_buffData;
wire signed [9:0] gx1,gx2,gy1,gy2;
wire unsigned [9:0] abgx1,abgx2,abgy1,abgy2;
wire [7:0] sum1,sum2;
reg [19:0] next_ED_wpixnum, next_ED_rpixnum, curr_ED_wpixnum, curr_ED_rpixnum;


typedef enum logic [3:0] {Wait, fillbuff, calc, write, upaddr1, upaddr2, upaddr3, done, done1} stateType;

reg rcount_en;
reg wcount_en;
stateType state;
stateType nxt_state;

always_ff @(posedge clk, negedge n_rst)
begin
	if (n_rst == 0)
		begin
		state <= Wait;
		curr_ED_wpixnum <= 0;
		curr_ED_rpixnum <= 0;
		curr_buffData <= 0;
		end
	else
		begin
		state <= nxt_state;
		curr_ED_wpixnum <= next_ED_wpixnum;
		curr_ED_rpixnum <= next_ED_rpixnum;
		curr_buffData <= next_buffData;
		end
end

always_comb
begin
	nxt_state = state;
	fill_buff = 0;
	ED_mode = 2'b00;
	ED_done = 0;
	next_ED_wpixnum = curr_ED_wpixnum;
	next_ED_rpixnum = curr_ED_rpixnum;
	rcount_en = 0;
	wcount_en = 0;
	next_buffData = curr_buffData;
		
	case(state)	
		Wait:
			begin
				next_buffData = '0;
				ED_mode = 2'b00;
				next_ED_wpixnum = 0;
				next_ED_rpixnum = 0;
				if (ED_start == 1)
					nxt_state = fillbuff;
				else
					nxt_state = Wait;
			end

		fillbuff:
			begin
				ED_mode = 2'b01;
				fill_buff = 1;
				if (buff_filled == 1)
					nxt_state = calc;
				else
					nxt_state = fillbuff;
		
			end

		calc:
			begin
				ED_mode = 2'b00;
				fill_buff = 0;
				next_buffData = ED_rdata;
	
				nxt_state = write;		
			end

		write:
			begin
				ED_mode = 2'b10;
				if (curr_ED_rpixnum != 0 && curr_ED_rpixnum % (image_width) == (image_width - 4) && ED_dfb == 1)
					nxt_state = upaddr2;
				else if ((curr_ED_rpixnum == 0 && ED_dfb == 1) || (curr_ED_rpixnum % (image_width) != (image_width - 4) && ED_dfb == 1))
					nxt_state = upaddr1;
				else
					nxt_state = write;
		
			end

		upaddr1:
			begin
				rcount_en = 1;
				wcount_en = 1;
				ED_mode = 2'b00;
				next_ED_rpixnum = next_ED_rpixnum + 2;
				next_ED_wpixnum = next_ED_wpixnum + 2;
				if (curr_ED_wpixnum <= ((image_width - 2)*(image_height - 2) - 2))
					nxt_state = fillbuff;
				else
					nxt_state = done;
		
			end

		upaddr2:
			begin
				next_ED_rpixnum = next_ED_rpixnum + 2;
				next_ED_wpixnum = next_ED_wpixnum + 2;
				rcount_en = 1;
				wcount_en = 1;
				ED_mode = 2'b00;
				nxt_state = upaddr3;
		
			end

		upaddr3:
			begin
				next_ED_rpixnum = next_ED_rpixnum + 2;
				rcount_en = 1;
				if (curr_ED_wpixnum <= ((image_width - 2)*(image_height - 2) - 2))
					nxt_state = fillbuff;
				else
					nxt_state = done;
		
			end

		done:
			begin
				ED_done = 1;
				nxt_state = done1;
			end

		done1:
			begin
				ED_done = 1;
				if (ED_start == 0)
					nxt_state = Wait;
				else
					nxt_state = done1;
			end
	
		endcase

end

	assign s1 = curr_buffData [7:0];
	assign s2 = curr_buffData [15:8];
	assign s3 = curr_buffData [23:16];
	assign s4 = curr_buffData [31:24];
	assign s5 = curr_buffData [39:32];
	assign s6 = curr_buffData [47:40];
	assign s7 = curr_buffData [55:48];
	assign s8 = curr_buffData [63:56];
	assign s9 = curr_buffData [71:64];
	assign s10 = curr_buffData [79:72];
	assign s11 = curr_buffData [87:80];
	assign s12 = curr_buffData [95:88];

	assign ED_wpixnum = curr_ED_wpixnum;
	assign ED_rpixnum = curr_ED_rpixnum;

	assign gx1 = (s3 - s1) + (s7 - s5)*2 + (s11 - s9);
	assign gy1 = (s1 - s9) + (s2 - s10)*2 + (s3 - s11);
	assign abgx1 = gx1[9] ? ~gx1 + 1 : gx1;
	assign abgy1 = gy1[9] ? ~gy1 + 1 : gy1;
	assign sum1 = (((abgx1 + abgy1) > 255)? 255 : (abgx1[7:0] + abgy1[7:0]));
	assign ED_wdata [7:0] = (sum1 < 50) ? 8'd50 : sum1[7:0];

	assign gx2 = (s4 - s2) + (s8 - s6)*2 + (s12 - s10);
	assign gy2 = (s2 - s10) + (s3 - s11)*2 + (s4 - s12);
	assign abgx2 = gx2[9] ? ~gx2 + 1 : gx2;
	assign abgy2 = gy2[9] ? ~gy2 + 1 : gy2;
	assign sum2 = (((abgx2 + abgy2) > 255)? 255 : (abgx2[7:0] + abgy2[7:0]));
	assign ED_wdata [15:8] = (sum2 < 50) ? 8'd50 : sum2[7:0];


endmodule
