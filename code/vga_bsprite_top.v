`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:25:43 01/29/2015 
// Design Name: 
// Module Name:    vga_bsprite_top 
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
module vga_bsprite_top(
	output wire [7:0]Led,
	input wire clk,
	input wire [4:0]btn,
	input wire [7:0]sw,
	output wire Hsync,
	output wire Vsync,
	output wire [2:0]vgaRed,
	output wire [2:0]vgaGreen,
	output wire [1:0]vgaBlue
    );
	 wire [7:0]F0,smile,sad,laugh;
	 
	 wire clk25, vidon;
	 wire [9:0]hc,vc;
	 wire [7:0]M[0:11];
	 wire [7:0]M0;
	 wire [7:0]rom_addr16;
	 wire [9:0]rom_addr26;
	 
	 wire [25:0]counter26;
	 wire clk_1ms;
	 
	 wire [4:0]btn_out;
	 wire [7:0]sw_out;
	 
	 wire [2:0]state;

	 wire [3:0]posx,posy;
	 wire [3:0]C1,R1;
	 wire [3:0]mine_state_single;
	 
	 assign M0=M[mine_state_single];
	 assign F0=(state==3'b010)? sad : ((state==3'b011)? laugh : smile);
	 
	 smile(
		.clka(clk25),
		.addra(rom_addr26),
		.douta(smile)
	);
	
	sad(
		.clka(clk25),
		.addra(rom_addr26),
		.douta(sad)
		);
	
	laugh(
		.clka(clk25),
		.addra(rom_addr26),
		.douta(laugh)
		);
	 
	 central_module3(
	 .sw(sw[6:1]),
	 .Led(Led),
	.clk_1ms(clk_1ms),//clk_1ms
	.clk_cnt26(counter26),
	.reset(sw_out[7]),//sw[7]  sw simulate btn option
	.left(btn_out[2]),
	.right(btn_out[4]),
	.up(btn_out[1]),
	.down(btn_out[3]),
	.stamp(btn_out[0]),//but mid
	.mark(sw_out[0]),//sw[0]
	.C1(C1),
	.R1(R1),
	.posx(posx),
	.posy(posy),
	//.pos(),
	.state(state),
	.mine_state_single(mine_state_single)
    );
	 
	 clkdiv U1 (.mclk(clk),
					.clr(0),
					.clk25(clk25)
			);

			
	 vga_640_480_stripes U2(
	.clk(clk25),
	.clr(0),
	.hsync(Hsync),
	.vsync(Vsync),
	.hc(hc),
	.vc(vc),
	.vidon(vidon)
    );	 
	 
	vga_bsprite U3(
	.face(F0),
	.rom_addr26(rom_addr26),
	.vidon(vidon),
	.hc(hc),
	.vc(vc),
	.M(M0),
	.rom_addr16(rom_addr16),
	.red(vgaRed),
	.green(vgaGreen),
	.blue(vgaBlue),
	//.mine_state_single(mine_state_single),
	.posx(posx),
	.posy(posy),
	.C1(C1),
	.R1(R1)
	//.state(state)
    );
	 
	 n1 U4(
		.clka(clk25),
		.addra(rom_addr16),
		.douta(M[2])
);

	counter_26bit U5(.clk(clk), .reset(1), .clk_1ms(clk_1ms), .count_out(counter26));
	
	Anti_jitter U6(	.clk(clk),
							.button(btn), 
							.SW(sw),
							.button_out(btn_out), 
							.button_pluse(), 
							.SW_OK(sw_out)
							);
	 n0 U7(
		.clka(clk25),
		.addra(rom_addr16),
		.douta(M[1])
);
	 n2 U8(
		.clka(clk25),
		.addra(rom_addr16),
		.douta(M[3])
);
	 n3 U9(
		.clka(clk25),
		.addra(rom_addr16),
		.douta(M[4])
);
	 n4 U10(
		.clka(clk25),
		.addra(rom_addr16),
		.douta(M[5])
);
	 n5 U11(
		.clka(clk25),
		.addra(rom_addr16),
		.douta(M[6])
);
	 n6 U12(
		.clka(clk25),
		.addra(rom_addr16),
		.douta(M[7])
);
	 n7 U13(
		.clka(clk25),
		.addra(rom_addr16),
		.douta(M[8])
);
	 n8 U14(
		.clka(clk25),
		.addra(rom_addr16),
		.douta(M[9])
);
	 blank U15(
		.clka(clk25),
		.addra(rom_addr16),
		.douta(M[0])
);
	 flag U16(
		.clka(clk25),
		.addra(rom_addr16),
		.douta(M[10])
);
	 blood U17(
		.clka(clk25),
		.addra(rom_addr16),
		.douta(M[11])
);

	
endmodule
