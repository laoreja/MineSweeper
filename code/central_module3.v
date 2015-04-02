`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:00:26 02/01/2015 
// Design Name: 
// Module Name:    central_module3 
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
module central_module3(
	input [6:1]sw,
	output reg [7:0]Led,
	input clk_1ms,//clk_1ms
	input [25:0] clk_cnt26,
	input reset,//sw[7]  sw simulate btn option
	input left,
	input right,
	input up,
	input down,
	input stamp,//but mid
	input mark,//sw[0]
	input wire [3:0]C1,
	input wire [3:0]R1,
	output reg [3:0]posx,
	output reg [3:0]posy,
	//output reg [7:0]pos,
	output reg [2:0]state,
	output  [3:0]mine_state_single
    );
	 //mine state    0--blank,1-9--mine num, 10-flag,11-mine

	 reg [3:0]mine_state[0:99];
	 
	 wire [7:0]pos;
	 
	 reg [99:0]mines;
	 reg [3:0]mine_count[0:99];
	 //reg [297:0]mine_count;
	 reg minesarray[0:99];
	 
	 reg [99:0] stamp_record;
	 reg left_old;
	 reg right_old;
	 reg up_old;
	 reg down_old;
	 reg stamp_old;
	 reg mark_old;
	 integer j;
	 
	 //reg [2:0]pos;
	 integer i;
	 
	 parameter s0=3'b000,s1=3'b001,s2=3'b010,s3=3'b011;
	 //the states of the state machine
	 //s0:initial
	 //s1:waiting
	 //s2:stamp on the mines
	 //s3:you win
	  
	 initial
	 begin
		stamp_record=100'b0;
		posx<=0;
		posy<=0;
		
		state<=s0;	 
		//mines=100'b0;
		/*
				minesarray[{clk_cnt26[17],clk_cnt26[20],clk_cnt26[25]}+clk_cnt26[24]]=1;
			   mines = mines | (1<<({clk_cnt26[17],clk_cnt26[20],clk_cnt26[25]}+clk_cnt26[24]));
				minesarray[10+{clk_cnt26[18],clk_cnt26[21],clk_cnt26[17]}+clk_cnt26[25]]=1;
				mines = mines | (1<<(10+{clk_cnt26[18],clk_cnt26[21],clk_cnt26[17]}+clk_cnt26[25]));
				minesarray[20+{clk_cnt26[19],clk_cnt26[22],clk_cnt26[18]}+clk_cnt26[17]]=1;
				mines = mines | (1<<(20+{clk_cnt26[19],clk_cnt26[22],clk_cnt26[18]}+clk_cnt26[17]));
				minesarray[30+{clk_cnt26[20],clk_cnt26[23],clk_cnt26[19]}+clk_cnt26[18]]=1;
				mines = mines | (1<<(30+{clk_cnt26[20],clk_cnt26[23],clk_cnt26[19]}+clk_cnt26[18]));
				minesarray[40+{clk_cnt26[21],clk_cnt26[24],clk_cnt26[20]}+clk_cnt26[19]]=1;
				mines = mines | (1<<(40+{clk_cnt26[21],clk_cnt26[24],clk_cnt26[20]}+clk_cnt26[19]));
				minesarray[50+{clk_cnt26[22],clk_cnt26[25],clk_cnt26[21]}+clk_cnt26[20]]=1;
				mines = mines | (1<<(50+{clk_cnt26[22],clk_cnt26[25],clk_cnt26[21]}+clk_cnt26[20]));
				minesarray[60+{clk_cnt26[23],clk_cnt26[17],clk_cnt26[22]}+clk_cnt26[21]]=1;
				mines = mines | (1<<(60+{clk_cnt26[23],clk_cnt26[17],clk_cnt26[22]}+clk_cnt26[21]));
				minesarray[70+{clk_cnt26[24],clk_cnt26[18],clk_cnt26[23]}+clk_cnt26[22]]=1;
				mines = mines | (1<<(70+{clk_cnt26[24],clk_cnt26[18],clk_cnt26[23]}+clk_cnt26[22]));
				minesarray[80+{clk_cnt26[25],clk_cnt26[19],clk_cnt26[24]}+clk_cnt26[23]]=1;
				mines = mines | (1<<(80+{clk_cnt26[25],clk_cnt26[19],clk_cnt26[24]}+clk_cnt26[23]));
				minesarray[90+{clk_cnt26[17],clk_cnt26[20],clk_cnt26[25]}+clk_cnt26[24]]=1;
				mines = mines | (1<<(90+{clk_cnt26[17],clk_cnt26[20],clk_cnt26[25]}+clk_cnt26[24]));
				*/				
		/*
		mines[1]=1'b1;
		mines[11]=1'b1;
		mines[21]=1'b1;
		mines[31]=1'b1;
		mines[41]=1'b1;
		mines[51]=1'b1;
		mines[61]=1'b1;
		mines[71]=1'b1;
		mines[81]=1'b1;
		mines[89]=1'b1;
		mines[91]=1'b1;
		minesarray[1]=1;
		minesarray[11]=1;
		minesarray[21]=1;
		minesarray[31]=1;
		minesarray[41]=1;
		minesarray[51]=1;
		minesarray[61]=1;
		minesarray[71]=1;
		minesarray[81]=1;
		minesarray[91]=1;
		minesarray[89]=1;
		*/
		/*
		case (clk_cnt26[17])
			1'b0:
			begin
				mines[1]=1'b1;
				mines[11]=1'b1;
				mines[21]=1'b1;
				mines[31]=1'b1;
				mines[41]=1'b1;
				mines[51]=1'b1;
				mines[61]=1'b1;
				mines[71]=1'b1;
				mines[81]=1'b1;
				mines[89]=1'b1;
				mines[91]=1'b1;
				minesarray[1]=1;
				minesarray[11]=1;
				minesarray[21]=1;
				minesarray[31]=1;
				minesarray[41]=1;
				minesarray[51]=1;
				minesarray[61]=1;
				minesarray[71]=1;
				minesarray[81]=1;
				minesarray[91]=1;
				minesarray[89]=1;
			end
			1'b1:
			begin
				mines[0]=1'b1;
				mines[15]=1'b1;
				mines[27]=1'b1;
				mines[32]=1'b1;
				mines[44]=1'b1;
				mines[59]=1'b1;
				mines[60]=1'b1;
				mines[72]=1'b1;
				mines[88]=1'b1;
				mines[99]=1'b1;
				mines[98]=1'b1;
				minesarray[0]=1;
				minesarray[15]=1;
				minesarray[27]=1;
				minesarray[32]=1;
				minesarray[44]=1;
				minesarray[59]=1;
				minesarray[60]=1;
				minesarray[72]=1;
				minesarray[88]=1;
				minesarray[99]=1;
				minesarray[98]=1;
			end
		endcase
		*/
	
			/*
			3'b100:
			begin
				mines[3]=1'b1;
				mines[19]=1'b1;
				mines[28]=1'b1;
				mines[43]=1'b1;
				mines[61]=1'b1;
				mines[65]=1'b1;
				mines[72]=1'b1;
				mines[87]=1'b1;
				mines[93]=1'b1;
				mines[97]=1'b1;
				mines[90]=1'b1;
				minesarray[3]=1;
				minesarray[19]=1;
				minesarray[28]=1;
				minesarray[43]=1;
				minesarray[61]=1;
				minesarray[65]=1;
				minesarray[72]=1;
				minesarray[87]=1;
				minesarray[93]=1;
				minesarray[97]=1;
				minesarray[90]=1;

			
			end
			3'b101:
			begin				
				mines[2]=1'b1;
				mines[18]=1'b1;
				mines[27]=1'b1;
				mines[42]=1'b1;
				mines[60]=1'b1;
				mines[64]=1'b1;
				mines[71]=1'b1;
				mines[86]=1'b1;
				mines[92]=1'b1;
				mines[96]=1'b1;
				mines[89]=1'b1;
				minesarray[2]=1;
				minesarray[18]=1;
				minesarray[27]=1;
				minesarray[42]=1;
				minesarray[60]=1;
				minesarray[64]=1;
				minesarray[71]=1;
				minesarray[86]=1;
				minesarray[92]=1;
				minesarray[96]=1;
				minesarray[89]=1;

			
			end
			3'b110:
			begin
				mines[9]=1'b1;
				mines[17]=1'b1;
				mines[26]=1'b1;
				mines[41]=1'b1;
				mines[59]=1'b1;
				mines[63]=1'b1;
				mines[70]=1'b1;
				mines[85]=1'b1;
				mines[91]=1'b1;
				mines[95]=1'b1;
				mines[88]=1'b1;
				minesarray[9]=1;
				minesarray[17]=1;
				minesarray[26]=1;
				minesarray[41]=1;
				minesarray[59]=1;
				minesarray[63]=1;
				minesarray[70]=1;
				minesarray[85]=1;
				minesarray[91]=1;
				minesarray[95]=1;
				minesarray[88]=1;			
			end
			3'b111:
			begin
				mines[8]=1'b1;
				mines[16]=1'b1;
				mines[25]=1'b1;
				mines[40]=1'b1;
				mines[59]=1'b1;
				mines[63]=1'b1;
				mines[70]=1'b1;
				mines[84]=1'b1;
				mines[90]=1'b1;
				mines[94]=1'b1;
				mines[87]=1'b1;
				minesarray[8]=1;
				minesarray[16]=1;
				minesarray[25]=1;
				minesarray[40]=1;
				minesarray[59]=1;
				minesarray[63]=1;
				minesarray[70]=1;
				minesarray[84]=1;
				minesarray[90]=1;
				minesarray[94]=1;
				minesarray[87]=1;			
			end			
		endcase
		*/


		/*
		for(i=0;i<100;i=i+1) 
		begin
			
				if(i<10)
				begin
					mine_count[i] = ((i==0)?0:(minesarray[i-1]))+ ((i==9)?0:(minesarray[i+1])) +  ( (i==0)?0:(minesarray[i+9]) )+ minesarray[i+10] + ( (i==9)?0:(minesarray[i+11]) )  ;
				end
				else if(i>89)
				begin
					if(i==99)
					begin
						mine_count[99]= minesarray[88]+ minesarray[89]+ minesarray[98];
					end
					else
					begin
						mine_count[i] = (  (i==90)?0:(minesarray[i-11]) ) + minesarray[i-10] + minesarray[i-9] + ((i==90)?0:(minesarray[i-1]))+ minesarray[i+1] ;
					end
				end
				else
				begin
					mine_count[i] =   (  (i%10==0)?0:(minesarray[i-11]) ) + minesarray[i-10] + ( (i%10==9)?0:(minesarray[i-9]) ) + ((i%10==0)?0:(minesarray[i-1]))+ ((i%10==9)?0:(minesarray[i+1])) +  ( (i%10==0)?0:(minesarray[i+9]) )+ minesarray[i+10] + ( (i%10==9)?0:(minesarray[i+11]) )  ;
				end
		end
		*/
				mines=100'b0;
				/*
				case (clk_cnt26[17])
					1'b0:
					begin
					
						mines[1]=1'b1;
						mines[11]=1'b1;
						mines[21]=1'b1;
						mines[31]=1'b1;
						mines[41]=1'b1;
						mines[51]=1'b1;
						mines[61]=1'b1;
						mines[71]=1'b1;
						mines[81]=1'b1;
						mines[89]=1'b1;
						mines[91]=1'b1;
						minesarray[1]=1;
						minesarray[11]=1;
						minesarray[21]=1;
						minesarray[31]=1;
						minesarray[41]=1;
						minesarray[51]=1;
						minesarray[61]=1;
						minesarray[71]=1;
						minesarray[81]=1;
						minesarray[91]=1;
						minesarray[89]=1;
						
					end
					1'b1:
					begin
					*/
						mines[0]=1'b1;
						mines[15]=1'b1;
						mines[27]=1'b1;
						mines[32]=1'b1;
						mines[44]=1'b1;
						mines[59]=1'b1;
						mines[60]=1'b1;
						mines[72]=1'b1;
						mines[88]=1'b1;
						mines[99]=1'b1;
						mines[98]=1'b1;
						minesarray[0]=1;
						minesarray[15]=1;
						minesarray[27]=1;
						minesarray[32]=1;
						minesarray[44]=1;
						minesarray[59]=1;
						minesarray[60]=1;
						minesarray[72]=1;
						minesarray[88]=1;
						minesarray[99]=1;
						minesarray[98]=1;
					//here, since it's in the initial state, maybe the clk counter has not worked yet. and thus clk_cnt26[17] is unknown, thus the problem occur.
				
				
				for(i=0;i<100;i=i+1) 
				begin
			
					if(i<10)
					begin
						mine_count[i] = ((i==0)?0:(minesarray[i-1]))+ ((i==9)?0:(minesarray[i+1])) +  ( (i==0)?0:(minesarray[i+9]) )+ minesarray[i+10] + ( (i==9)?0:(minesarray[i+11]) )  ;
					end
					else if(i>89)
					begin
						if(i==99)
						begin
							mine_count[99]= minesarray[88]+ minesarray[89]+ minesarray[98];
						end
						else
						begin
							mine_count[i] = (  (i==90)?0:(minesarray[i-11]) ) + minesarray[i-10] + minesarray[i-9] + ((i==90)?0:(minesarray[i-1]))+ minesarray[i+1] ;
						end
					end
					else
					begin
						mine_count[i] =   (  (i%10==0)?0:(minesarray[i-11]) ) + minesarray[i-10] + ( (i%10==9)?0:(minesarray[i-9]) ) + ((i%10==0)?0:(minesarray[i-1]))+ ((i%10==9)?0:(minesarray[i+1])) +  ( (i%10==0)?0:(minesarray[i+9]) )+ minesarray[i+10] + ( (i%10==9)?0:(minesarray[i+11]) )  ;
					end
				end

		
		for(j=0;j<100;j=j+1)
			mine_state[j]=4'b0;
		
	 end
	 
	 
	 always@(*)
	 begin
		case(sw[6:1])
			//6'b000000:Led=pos;
			//6'b000000: Led[7:0]=mines[7:0];
			//6'b000001: Led[6:1]=mine_oneline[11:6];
			//6'b000001: Led[7:0]=stamp_record[7:0];
			//6'b000010: Led={mine_state_single,1'b0,state};
			6'b000000:Led={mines[1],mines[11],mines[21],minesarray[1],minesarray[10],minesarray[11]};
			6'b000011: Led={mine_state[0],mine_state[1]};
			//6'b000111: Led=rand[0];
			6'b000100: Led={mine_count[0],mine_count[1]};
			//6'b010000: Led={R1,C1};
			//6'b100000: Led={posy,posx};
			
		endcase
	 end
	 
	 always @(posedge clk_1ms)//to be modified
	 begin
	 if(reset)
		state<=s0;
		
		case(state)
			s0:
			begin
				left_old <= 0;
				right_old <= 0;
				up_old<=0;
				down_old<=0;
				mark_old <= 0;
				stamp_old<=0;
								
				
				posx =4'b0;
				posy=4'b0;
				//mark_record=100'b0;
				stamp_record=100'b0;
				
				for(j=0;j<100;j=j+1)
					mine_state[j]=4'b0;
					
				
				state<=s1;
			end
			
			s1:
			begin
				left_old<=left;
				right_old<=right;
				up_old<=up;
				down_old<=down;
				mark_old <= mark;
				stamp_old <= stamp;

				
				if(left==1 && left_old==0 )
				begin
					if(posx==0)
						posx=9;
					else
						posx = posx-4'b1;
				end
				else if(right==1 && right_old==0 )
				begin
					if(posx==9)
						posx=0;
					else
						posx= posx + 4'b1;
				end
				else if(up==1 && up_old==0 )
				begin
					if(posy==0)
						posy=9;
					else
						posy = posy-4'b1;
				end
				else if(down==1 && down_old==0 )
				begin
					if(posy==9)
						posy=0;
					else
						posy= posy + 4'b1;
				end

				
				if( stamp_old==0 && stamp==1 && mine_state[pos]==0)
				begin
					stamp_record = stamp_record | ( 1 << pos );
					mine_state[pos]=mine_count[pos]+1;
					if(pos>9 && mines[pos-10]==0)
					begin
						mine_state[pos-10] = mine_count[pos-10]+1;
						stamp_record = stamp_record | ( 1 << (pos-10) );
						if(pos%10!=0 && mines[pos-11]==0)
						begin
							mine_state[pos-11] = mine_count[pos-11]+1;
							stamp_record = stamp_record | ( 1 << (pos-11) );
						end
						if(pos %10!=9 && mines[pos-9]==0)
						begin
							mine_state[pos-9]= mine_count[pos-9]+1;
							stamp_record = stamp_record | ( 1 << (pos-9) );
						end
					end
					
					if(pos<89 && mines[pos+10]==0)
					begin
						mine_state[pos+10] = mine_count[pos+10]+1;
						stamp_record = stamp_record | ( 1 << (pos+10) );
						if(pos%10!=9 && mines[pos+11]==0)
						begin
							mine_state[pos+11] = mine_count[pos+11]+1;
							stamp_record = stamp_record | ( 1 << (pos+11) );
						end
						if(pos%10!=0 && mines[pos+9]==0)
						begin
							mine_state[pos+9]= mine_count[pos+9]+1;
							stamp_record = stamp_record | ( 1 << (pos+9) );
						end
					end
					
					if(pos%10!=0 && mines[pos-1]==0)
					begin
						mine_state[pos-1]=mine_count[pos-1]+1;
						stamp_record = stamp_record | ( 1 << (pos-1) );
					end
					if(pos%10!=9 && mines[pos+1]==0)
					begin
						mine_state[pos+1]=mine_count[pos+1]+1;
						stamp_record = stamp_record | ( 1 << (pos+1) );
					end
				end
				
				if( mark_old==0 && mark==1 )
				begin
					
					if(mine_state[pos]==0)
						mine_state[pos]=10;
					else if(mine_state[pos]==10)
						mine_state[pos]=0;
				end
				
				
				if((~stamp_record) ==mines)
				begin
					state<=s3;
				end
				
				if( stamp_record & mines)
				begin
					state<=s2;
				end
			end
			
			s2://lose
			begin
				for(j=0;j<100;j=j+1)
				begin
					if(mines[j]==1)
						mine_state[j]=4'b1011;
				end

			end
			
			s3://win
			begin
				
			end
			

		endcase
	end


assign		pos={1'b0,posy,3'b000}+{3'b000,posy,1'b0}+{4'b0000,posx};
assign		mine_state_single=mine_state[{1'b0,R1,3'b000}+{3'b000,R1,1'b0}+{4'b0000,C1}];
	
	 

endmodule
