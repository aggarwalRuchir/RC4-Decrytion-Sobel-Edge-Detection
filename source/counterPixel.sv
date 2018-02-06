// $Id: $
// File name:   counterI.sv
// Created:     4/12/2017
// Author:      John Student
// Lab Section: 03
// Version:     1.0  Initial Design Entry
// Description: .

module counterPixel
#(
  NUM_CNT_BITS = 20
)
  
(
  input wire clk,
  input wire n_rst,
  input wire clear,
  input wire count_enable,
  input wire [NUM_CNT_BITS-1:0] rollover_val,
  output wire [NUM_CNT_BITS-1:0] count_out,
  output reg rollover_flag

);

  reg [NUM_CNT_BITS-1:0]cur_count;
  reg [NUM_CNT_BITS-1:0]nxt_count;
  reg cur_flag;
  reg nxt_flag;

  always_ff @ (posedge clk, negedge n_rst)
  begin
    if( n_rst == 0)
    begin
      cur_count <= 1'b0;
      cur_flag <= 1'b0;     
    end 
    else
    begin
      cur_count <= nxt_count;
      cur_flag <= nxt_flag;
    end
        
        
  end
  
  
  always_comb
  begin
    if(clear == 1)
    begin
      nxt_count = 1'b0;
      nxt_flag = 1'b0;
    end   
    else
    begin 
      if(count_enable == 1)
      begin      
	nxt_flag = 1'b0;
        nxt_count = cur_count + 1;
        if(nxt_count == (rollover_val + 1))
        begin
            nxt_count = 1;
        end
        if(nxt_count == rollover_val)
            nxt_flag = 1'b1; 
      end      
      else
      begin
        nxt_flag = cur_flag;
        nxt_count = cur_count;
      end
    end
  end
  
  assign rollover_flag = cur_flag;
  assign count_out = cur_count;



endmodule
