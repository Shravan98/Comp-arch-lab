module DECODER(d0,d1,d2,d3,d4,d5,d6,d7,x,y,z);
	input x,y,z;
	output d0,d1,d2,d3,d4,d5,d6,d7;
	wire x0,y0,z0;
	not n1(x0,x);
	not n2(y0,y);
	not n3(z0,z);
	and a0(d0,x0,y0,z0);
	and a1(d1,x0,y0,z);
	and a2(d2,x0,y,z0);
	and a3(d3,x0,y,z);
	and a4(d4,x,y0,z0);
	and a5(d5,x,y0,z);
	and a6(d6,x,y,z0);
	and a7(d7,x,y,z);
endmodule

module FADDER(s,c,x,y,z);
	input x,y,z;
	wire d0,d1,d2,d3,d4,d5,d6,d7;
	output s,c;
	DECODER dec(d0,d1,d2,d3,d4,d5,d6,d7,x,y,z);
	assign s = d1 | d2 | d4 | d7,
	 c = d3 | d5 | d6 | d7;
endmodule

module FADDER8(s,cout,x,y,cin);
	input [7:0] x; 
	input [7:0] y;
	input cin;
	wire [6:0] c;
	output cout;
	output [7:0] s;
		FADDER f1(s[0],c[0],x[0],y[0],cin);
		FADDER f2(s[1],c[1],x[1],y[1],c[0]);
		FADDER f3(s[2],c[2],x[2],y[2],c[1]);
		FADDER f4(s[3],c[3],x[3],y[3],c[2]);
		FADDER f5(s[4],c[4],x[4],y[4],c[3]);
		FADDER f6(s[5],c[5],x[5],y[5],c[4]);
		FADDER f7(s[6],c[6],x[6],y[6],c[5]);
		FADDER f8(s[7],cout,x[7],y[7],c[6]);
endmodule

module FADDER32(s,cout,x,y,cin);
	input [31:0] x;
	input [31:0] y;
	input cin;
	wire [2:0] carry;
	output [31:0] s;
	output cout;
		FADDER8 f1(s[7:0],carry[0],x[7:0],y[7:0],cin);
		FADDER8 f2(s[15:8],carry[1],x[15:8],y[15:8],carry[0]);
		FADDER8 f3(s[23:16],carry[2],x[23:16],y[23:16],carry[1]);
		FADDER8 f4(s[31:24],cout,x[31:24],y[31:24],carry[2]);
endmodule

module FULLADDER_behavioral(s,c,x,y,z);
	input x,y,z;
	output reg s,c;
	//DECODER dec(d0,d1,d2,d3,d4,d5,d6,d7,x,y,z);
	//always@(*)
		//s = d1 || d2 || d4 || d7;
		//c = d3 || d5 || d6 || d7;
	always@(*)
		begin
		s = x^y^z;
		c = z&(x|y)|(x&y);
		end
endmodule

module ADDSUB(s,v,x,y,m);
	input [3:0] x,y;
	input m;
	reg [3:0] d;
	wire [2:0] carry;
	wire cout;
	output [3:0] s;
	output reg v;
	integer i;
	always@(*)
	begin
		for(i=0;i<4;i=i+1)
			begin
				d[i] = m^y[i];
			end
	end
	
	
		FULLADDER_behavioral f1(s[0],carry[0],x[0],d[0],m);
		FULLADDER_behavioral f2(s[1],carry[1],x[1],d[1],carry[0]);
		FULLADDER_behavioral f3(s[2],carry[2],x[2],d[2],carry[1]);
		FULLADDER_behavioral f4(s[3],cout,x[3],d[3],carry[2]);
	always@(*)
	begin
		v = cout^carry[2];
	end
	
endmodule
		
	
module testbench;
	 reg [31:0] x,y;
	 reg [3:0] x1,y1;
	 reg cin,m;
	 wire [31:0] s;
	 wire [3:0] s1;
	 wire c,v;
	 FADDER32 fl(s,c,x,y,cin);
	 ADDSUB a1(s1,v,x1,y1,m);
	 initial
		begin
		//$monitor(,$time," x=%b,y=%b,z=%b,s=%d,c=%b",x,y,cin,s,c);
		$monitor(,$time,"x1=%b,y1=%b,m=%b,s1=%d,v=%b",x1,y1,m,s1,v);
		end
	 initial
		begin
		// #5 x=8'd130;y=8'd125;cin=1'b0;
		 #0 x1=4'd13;y1=4'd2;m=1'b0;
		 /*#4 x=1'b1;y=1'b0;cin=1'b0;
		 #4 x=1'b0;y=1'b1;cin=1'b0;
		 #4 x=1'b1;y=1'b1;cin=1'b0;
		 #4 x=1'b0;y=1'b0;cin=1'b1;
		 #4 x=1'b1;y=1'b0;cin=1'b1;
		 #4 x=1'b0;y=1'b1;cin=1'b1;
		 #4 x=1'b1;y=1'b1;cin=1'b1;*/
		end
endmodule