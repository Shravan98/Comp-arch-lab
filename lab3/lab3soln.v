module dff(clk,in,q,reset);
	input clk,in,reset;
	output q;
	reg q;
	always@(posedge clk)
	begin
	if(!reset) q<=1'b0;
	else q<=in;
	end
endmodule

module jkff(in,clk,q);
	input[1:0] in;
	input clk;
	output q;
	reg q;
	initial
		q = 1'b0;
	always@(posedge clk)
	begin
		case(in)
		2'b00:begin q<=q; end
		2'b01:begin q<=1'b0; end
		2'b10:begin q<=1'b1; end
		2'b11:begin q<=~q; end
		endcase
	end
endmodule


module counter(in,q,clk);
	input[1:0] in;
	input clk;
	output[3:0] q;
	wire x,y,z;
	jkff j1(in,clk,q[0]); 
	jkff j2({q[0],q[0]},clk,q[1]);
	and	gate1(y,q[0],q[1]);
	jkff j3({y,y},clk,q[2]);
	and	gate2(z,q[2],y);
	jkff j4({z,z},clk,q[3]);
endmodule

module FSM(clk,rst,in,out);
	input clk,rst,in;
	output out;
	reg[1:0] state;
	reg out;
	
	always @(posedge clk)
	begin
		if(rst) begin
		state<=2'b00;
		out<=0;
		end
		else begin
			case(state)
			2'b00:begin
				if(in) begin
				state <=2'b01;
				out<=1'b0;
				end
				else begin
				state <=2'b00;
				out<=1'b0;
				end
				end
			2'b01:begin
				if(in) begin
				state<=2'b01;
				out<=1'b0;
				end
				else begin
				state<=2'b10;
				out<=1'b0;
				end
				end
			2'b10:begin
				if(in) begin
				state<=2'b11;
				out<=1'b0;
				end
				else begin
				state<=2'b10;
				out<=1'b0;
				end
				end
			2'b11:begin
				if(in) begin
				state<=2'b00;
				out<=1'b1;
				end
				else begin
				state<=2'b10;
				out<=1'b1;
				end
				end
			endcase
			end
		end		
endmodule

module shiftreg(EN, in, CLK, Q,val);
	input EN;
	input in;
	input CLK;
	input[3:0] val;
	output [3:0] Q;
	reg [3:0] Q;
	initial
	begin
	Q=val;
	end
	always @(posedge CLK)
	begin
	Q={in,Q[3:1]};
	end
endmodule
module fa(a,b,cin,sum,cout);
	input a,b,cin;
	output sum,cout;
	assign {cout,sum} = a+b+cin;
endmodule

module serial_adder(a,b,clk,out,c);
	input[3:0] a,b;
	input clk;
	output[3:0] out;
	output c;
	wire[3:0] q1,q2;
	wire cout,cin,s;
	fa f1(q1[0],q2[0],cin,s,cout);
	dff d1(clk,cout,cin,1'b0);
	shiftreg A(1'b1,s,clk,q1,a);
	shiftreg B(1'b1,1'b0,clk,q2,b);
	assign out = q1;
endmodule
module serial_testbench;
	reg[3:0] a,b;
	wire[3:0] out;
	reg clk;
	serial_adder s1(a,b,clk,out,c);
	initial
		begin
			$monitor($time," a=%b b=%b out=%b",a,b,out);
			#0 clk=1'b0;a = 4'b0100;b=4'b1001;
			#50 $finish;
		end
	always
	#5 clk=~clk;
endmodule
