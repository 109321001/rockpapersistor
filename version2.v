module version2(
input reg [2:0] user
,input CLK
,output reg [1:0] winornot
,input reg [2:0] compu
,output reg beep
,output reg [7:0] seg
,output reg [3:0]COM
);

divfreq F0(CLK,CLK_div);
divfreqtime V0(CLK,wiggle);

int up,cp;
reg [7:0] nu;
reg [7:0] nc;

initial 
	begin
		beep=1'b0;
		up=0;
		cp=0;
		
		nu=8'b11111110;
		nc=8'b11111110;
		COM = 4'b1011;
	end



always @ (user,compu)


	if(compu == 3'b010 && user == 3'b100) winornot <= 2'b01;
	else if(compu == 3'b001 && user == 3'b100) winornot <= 2'b10;	
	else if(compu == 3'b001 && user == 3'b010) winornot <= 2'b01;
	
	else if(compu == 3'b100 && user == 3'b010) winornot <= 2'b10;	
	else if(compu == 3'b100 && user == 3'b001) winornot <= 2'b01;
	else if(compu == 3'b010 && user == 3'b001) winornot <= 2'b10;
	
	else winornot <= 2'b00;
		

always@(winornot)
	if(winornot==2'b10)  beep=1'b1;
	else beep=1'b0;


//test
always@(posedge wiggle)
	if(winornot==2'b10)  up = up +1;
	else up=up;
	
always@(posedge wiggle)
	if(winornot==2'b01)  cp = cp +1;
	else cp=cp;


always @(up)
case(up)
		0: nu <= 8'b00000010;
		1: nu <= 8'b10011110;
		2: nu <= 8'b00100100;
		3: nu <= 8'b00001100;
		4: nu <= 8'b10011000;
		5: nu <= 8'b01001000;
		6: nu <= 8'b01000000;
		7: nu <= 8'b00011010;
		default: nu <= 8'b11111110;
endcase


always @(cp)
	case(cp)
		0: nc <= 8'b00000010;
		1: nc <= 8'b10011110;
		2: nc <= 8'b00100100;
		3: nc <= 8'b00001100;
		4: nc <= 8'b10011000;
		5: nc <= 8'b01001000;
		6: nc <= 8'b01000000;
		7: nc <= 8'b00011010;
		default: nc <= 8'b11111110;
	endcase


always@(COM)
case (COM)
		4'b1011:	seg <= nu;
		4'b1110:	seg <= nc;
		default: seg <= 8'b11111110;
endcase

always@(posedge CLK_div)
	if(COM == 4'b1011) COM = 4'b1110;
	else if(COM == 4'b1110) COM = 4'b1011;
	else COM=4'b1111;	
	

endmodule

module divfreqtime(input CLK, output reg CLK_div);
reg [24:0] Count;
always @(posedge CLK)
begin
if(Count > 25000000)
begin
Count <= 25'b0;
CLK_div <= ~CLK_div;
end
else
Count <= Count + 1'b1;
end
endmodule

module divfreq(input CLK, output reg CLK_div);
reg [24:0] Count;
always @(posedge CLK)
begin
if(Count > 250000)
begin
Count <= 25'b0;
CLK_div <= ~CLK_div;
end
else
Count <= Count + 1'b1;
end
endmodule
