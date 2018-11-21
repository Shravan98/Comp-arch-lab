module fulladder(a,b,cin,s,cout);
	input a,b,cin;
	output reg s,cout;
	always@*
	begin
		s = a^b^cin;
		cout = cin&(a|b) | (a&b);
	end
endmodule

module dflipflop(clear,clk,d,Q);
	input clear,clk,d; //clear on 0
	output reg Q;
	always@(posedge clk or negedge clear)
	begin
		if(!clear)
			Q<=1'b0;
		else
			Q<=d;
	end
endmodule

module shiftregister(enable,clk,in,Q,num);
	parameter n =4;
	input in,clk,enable;input [3:0] num;
	output reg [n-1:0] Q;
	initial
	Q=num;
	always@(posedge clk)
	begin
		if(enable)
		Q={in,Q[n-1:1]};
		else
		Q=num;
	end
endmodule

module serial_adder(in1,in2,enable,clk,out,clear);
	input [3:0] in1,in2;input enable,clk,clear;
	output [3:0] out;
	wire [3:0] x,y;wire z,s,cout;//wire [31:0] reg[0:3];
	reg mul;
	
	always@*
		mul = clk&enable;
		
	//shiftregister sa(enable,clk,s,x,in1);
	//shiftregister sb(enable,clk,s,y,in2);
	fulladder f1(x[0],y[0],z,s,cout);
	dflipflop df(clear,mul,cout,z);
	shiftregister sa(enable,clk,s,x,in1);
	shiftregister sb(enable,clk,s,y,in2);
	assign out = x;
	
	
endmodule
		
module testbench;
			reg [3:0] a,b;
			reg enable,clk,clear;
			wire [3:0] out;
			
			serial_adder s(a,b,enable,clk,out,clear);

			always
			#1	clk=~clk;
			
			initial	
			begin
				$monitor(,$time,"a=%d,b=%d,out=%b",a,b,out);
				a = 4'd9;b=4'd3;clk = 1'b0;enable=1'b0;clear=1'b1;
			#2	enable=1'b1;clear=1'b1;
			//#6	a = 4'd3;b=4'd2;enable=1'b1;clear=1'b1;
			#30	a = 4'd5;b=4'd11;enable=1'b0;clear=1'b1;
			#31 enable = 1'b1;
			//#5	a = 4'd6;b=4'd6;enable=1'b1;clear=1'b1;
			//#4	a = 4'd8;b=4'd4;enable=1'b1;clear=1'b1;
			//#8	a = 4'd10;b=4'd4;enable=1'b1;clear=1'b1;
			#1 $finish;
			end
			
			initial
			begin
			$dumpfile("sa.vcd");
			$dumpvars();
			end
endmodule
			
				
	
	