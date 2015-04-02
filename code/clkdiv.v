`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:51:51 01/16/2015 
// Design Name: 
// Module Name:    clkdiv 
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
module clkdiv(
	input mclk,
	input clr,
	output reg clk25
    );
	 
	 reg [1:0] count=0;
	always @ (posedge mclk)
	begin
		if(clr)
		begin
			count<=0;
			//clk25<=0;
		end
		else if(count==2'b11)
		begin
			count<=0;
			clk25<=1;
		end
		else
		begin
			count<= count+1;
			clk25<=0;
		end
	
	end


endmodule
