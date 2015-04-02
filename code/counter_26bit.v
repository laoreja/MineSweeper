`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:57:02 11/23/2014 
// Design Name: 
// Module Name:    counter_26bit 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module counter_26bit(clk, reset, clk_1ms, count_out);

		parameter COUNTER=26;
		input clk;
		input reset;
		output clk_1ms;
		output wire [COUNTER-1:0] count_out; 
		reg [COUNTER-1:0] count;
		reg second_m;
		wire clk;
	
		
	initial
		count<=0;
		
		always@(posedge clk)begin
			if(!reset || (count[16:0]==99999))begin //reset==1
				count[16:0]<=0; 
				count[25:17]<=count[25:17]+1; 
				second_m<=1; //if we consider the fpga as 50Mhz,then here becomes 1ms
			end
			else begin
				count[16:0] <= count[16:0]+1;
				second_m<=0;
			end 
		end
		
		assign clk_1ms=second_m; 
		assign count_out=count;
		
endmodule