module pss(
input reg [2:0] user
,output reg [1:0] winornot
,input reg [2:0] compu

,output reg [6:0] seg
,output reg [3:0]COM
,input CLK
);

divfreq F0(CLK,CLK_div);

reg [2:0] puser;
reg [2:0] pcompu;

reg [6:0] nu;
reg [6:0] nc;

initial 
	begin
//		puser <= 3'b000;
//		pcompu <= 3'b000;
		
//		nu=7'b1111111;
//		nc=7'b1111111;
		COM = 4'b1011;
	end

//game rule set up 
always @ (user,compu)


	if(compu == 3'b010 && user == 3'b100) 
		begin 
			winornot <= 2'b01; 
			pcompu = pcompu + 3'b001;
		end
	else if(compu == 3'b001 && user == 3'b100) 
		begin 
			winornot <= 2'b10;	
			puser <= puser + 3'b001; 
		end
	else if(compu == 3'b001 && user == 3'b010) 
		begin 
			winornot <= 2'b01; 
			pcompu = pcompu + 3'b001;
		end
	
	else if(compu == 3'b100 && user == 3'b010) 
		begin 
			winornot <= 2'b10;	
			puser <= puser + 3'b001; 
		end	
	else if(compu == 3'b100 && user == 3'b001)
		begin 
			winornot <= 2'b01; 
			pcompu = pcompu + 3'b001;
		end
	else if(compu == 3'b010 && user == 3'b001) 
		begin 
			winornot <= 2'b10;	
			puser <= puser + 3'b001; 
		end
	
	else
		begin
			winornot <= 2'b00 ;
			puser <= puser;
		end
		

//point display setup
always @(puser)
case(puser)
	0: nu <= 7'b0000001;
	1: nu <= 7'b1001111;
	2: nu <= 7'b0010010;
	3: nu <= 7'b0000110;
	4:	nu <= 7'b1001100;
	5:	nu <= 7'b0100100;
	6:	nu <= 7'b0100000;
	7:	nu <= 7'b0001101;
	default:	nu <= 7'b0000001;
endcase


always @(pcompu)
	case(pcompu)
		3'b000: nc <= 7'b0000001;
		3'b001: nc <= 7'b1001111;
		3'b010: nc <= 7'b0010010;
		3'b011: nc <= 7'b0000110;
		3'b100: nc <= 7'b1001100;
		3'b101: nc <= 7'b0100100;
		3'b110: nc <= 7'b0100000;
		3'b111: nc <= 7'b0001101;
		default: nc <= 7'b1111111;
	endcase


always@(COM)
case (COM)
		4'b1011:	seg <= nu;
		4'b1110:	seg <= nc;
		default: seg <= 7'b1111111;
endcase

always@(posedge CLK_div)
	if(COM == 4'b1011) COM = 4'b1110;
	else if(COM == 4'b1110) COM = 4'b1011;
	else COM=4'b1111;

	
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






/*
//ramdom is useless

module makerandom(input CLK,output reg [2:0]rockpaper);

divfreq F0(CLK,CLK_div);

int x = 0;

always @ ( posedge CLK_div)
	begin 
			x = x % 3;
			x = x + 1;
	end

always@ (x)
	case(x)
		0: rockpaper = 3'b001;
		1: rockpaper = 3'b010;
		2: rockpaper = 3'b100;
	endcase



endmodule

//using clk to implement ramdom

*/
