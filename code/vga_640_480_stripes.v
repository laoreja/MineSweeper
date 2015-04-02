`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:14:47 01/16/2015 
// Design Name: 
// Module Name:    vga_640_480_stripes 
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
module vga_640_480_stripes(
	input wire clk,
	input wire clr,
	output reg hsync,
	output reg vsync,
	output reg [9:0] hc,
	output reg [9:0] vc,
	output reg vidon
    );
	 
	 parameter hpixels = 10'b1100100000, //800
				  vlines = 10'b1000001001, //521
				  hbp = 10'b0010010000, //144
				  hfp = 10'b1100010000, //784
				  vbp = 10'b0000011111, //31
				  vfp = 10'b0111111111; //511
				  
	 reg vsenable; //enable for the vertical counter
	 
	 //horizontal sync signal counter
	 always @(posedge clk or posedge clr)
	 begin
		if(clr==1)
			hc<=0;
		else
		begin
			if(hc==hpixels-1)
				begin //the counter has reached the end of pixel count
					hc<=0;
					vsenable <=1;//enable the vertical counter to inc
				end
			else
			begin
				hc<=hc+1;
				vsenable <= 0;
			end
		end
	end
	
	//generate hsync pulse, SP=96, when 0<hc<96, SP is low...
	always @ (*)
	begin 
		if(hc<96)
			hsync=0;
		else
			hsync=1;
		end
		
	//vertical sync signal counter
	always @ (posedge clk or posedge clr)
	begin
		if(clr==1)
			vc<=0;
		else
			if(vsenable==1)
			begin
				if(vc==vlines-1)//reset when the number of lines is reached
					vc<=0;
				else
					vc<=vc+1;
			end
		end
	//generate vsync pulse
	always @(*)
		begin
			if(vc<2)
				vsync=0;
			else 
				vsync=1;
		end
	
	//enable video out when within the porches
	always@(*)
	begin
		if((hc<hfp)&&(hc>hbp)&&(vc<vfp)&&(vc>vbp))
			vidon = 1;
		else
			vidon = 0;
	end
	 
				  


endmodule
