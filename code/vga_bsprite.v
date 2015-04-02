`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:02:19 01/29/2015 
// Design Name: 
// Module Name:    vga_bsprite 
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
module vga_bsprite(
	input wire vidon,
	input wire [9:0]hc,
	input wire [9:0]vc,
	input wire [7:0]M,
	//input wire [3:0]mine_state_single,
	input wire [3:0]posx,
	input wire [3:0]posy,
	//input wire [2:0]state,	
	input wire [7:0]face,
	output wire [9:0]rom_addr26,
	output wire [7:0]rom_addr16,
	output reg[2:0]red,
	output reg[2:0]green,
	output reg[1:0]blue,
	output wire [3:0]C1,
	output wire [3:0]R1
    );
	 
	parameter hbp=10'b0010010000;
	parameter vbp=10'b0000011111;
	parameter W=16;
	parameter H=16;
	
	wire [3:0]xpix,ypix;
	reg spriteon;//,R,G,B;
	wire [9:0]fx,fy;
	reg faceon;
	wire [19:0]addrface;
	
	assign C1=(hc-hbp-240)>>4;
	assign R1=(vc-vbp-200)>>4;
	assign ypix=vc-vbp-200-(R1<<4);
	assign xpix=hc-hbp-240-(C1<<4);
	assign rom_addr16={ypix,xpix};
	assign fx=hc-hbp-307;
	assign fy=vc-vbp-174;
	assign addrface={1'b0,fy,4'b0000}+{2'b0,fy,3'b000}+{4'b0000,fy,1'b0}+{5'b00000,fx};
	assign rom_addr26=addrface[9:0];//fy*26+fx;//{1'b0,fy,4'b0000}+{2'b0,fy,3'b000}+{4'b0000,fy,1'b0}+fx;
	
	always@(*)
		begin
			if (hc-hbp>=240 && hc-hbp<400 && vc-vbp>=200 && vc-vbp<360)//&&(hc>=C1<<4+hbp)&&(hc<C1<<4+hbp+W)&&(vc>=R1<<4+vbp)&&(vc<R1<<4+vbp+H))
				spriteon=1;
			else
				spriteon=0;
		end
		
	always@(*)
	begin
		if(hc-hbp>=307 && hc-hbp<333 && vc-vbp>=174 && vc-vbp<200)
			faceon=1;
		else
			faceon=0;
	end
		
	always@(*)
	begin
	red=0;
	green=0;
	blue=0;
	if((spriteon==1)&&(vidon==1))
		begin
			red=M[7:5];
			green=M[4:2];
			blue=M[1:0];
			
			if(R1==posy && C1==posx)
			begin
				red=(red<7)?red+1:red;
				//green=(green<7)?green+1:green;
				//blue=(blue<4)?blue+1:blue;
			end
		end
	else if( (faceon==1) && (vidon==1) )
	begin
		red=face[7:5];
		green=face[4:2];
		blue=face[1:0];
	end
end
endmodule
