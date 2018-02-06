// $Id: $
// File name:   sarr.sv
// Created:     3/30/2017
// Author:      John Student
// Lab Section: 03
// Version:     1.0  Initial Design Entry
// Description: sarr implement



module sarr (
	input wire clk,
	input wire [7:0] waddr_i,
	input wire [7:0] wdata_i,
	input wire [7:0] raddr_i,
	input wire swap_i,
	input wire renable_i,
	input wire wenable_i,
	output wire [7:0] rdata_o
);

reg [255:0] [7:0] stateArray;


integer i;

always_ff @ (posedge clk)
begin
/*
	for( i = 0; i < 256 ;  i++)
        begin
		stateArray[i] <= 0;
	end	
*/
	//if(reset == 1)
	//begin
	//	for( i = 0; i < 256 ;  i++)
        ///	begin
	///		stateArray[i] <= i;
	///	end		
	//end
	if(wenable_i == 1)
	begin
		stateArray[waddr_i] <= wdata_i;
	end
	//else
	//begin
	//	stateArray[waddr_i] <= stateArray[waddr_i];
	//end



//	else if(renable_i == 1)
//	begin
//		rdata_o <= stateArray[raddr_i];
//	end



	//else
	//begin
	//	stateArray[raddr_i] <= stateArray[raddr_i];
	//end
	else if(swap_i == 1)
	begin
		stateArray[raddr_i] <= stateArray[waddr_i];
		stateArray[waddr_i] <= stateArray[raddr_i];
	end
	//else
	//begin
	//	for( i = 0; i < 256 ;  i++)
       // 	begin
	//		stateArray[i] <= stateArray[i];
	//	end
	//end
end

assign rdata_o = (renable_i == 1) ? stateArray[raddr_i] : 0;
endmodule


