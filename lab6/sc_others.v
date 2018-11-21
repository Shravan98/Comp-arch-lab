module mux2to1(out,sel,a,b);
	input [31:0] a,b;
	input sel;
	output [31:0] out;
	assign out = sel?b:a;
endmodule

module reg_32bit(q,d,clk,reset);//neg-reset
	input [31:0] d;
	input clk,reset;
	output reg [31:0] q;
	always@(posedge clk or negedge reset)
	begin
	if(!reset)
		q=32'd0;
	else
		q=d;
	end
endmodule

module signextender(out,in);
	input [15:0] in;
	output [31:0] out;
	assign out = { {16{in[15]}}, in};
end module

module shiftleft(out,in)
	input [31:0] in;
	output reg [31:0] out;
	assign out = {in[29:0],1'b0,1'b0};
endmodule

module FULLADDER_behavioral(s,c,x,y);
	input [31:0] x,y;
	output reg [31:0] s;output reg c;
	//DECODER dec(d0,d1,d2,d3,d4,d5,d6,d7,x,y,z);
	//always@(*)
		//s = d1 || d2 || d4 || d7;
		//c = d3 || d5 || d6 || d7;
	always@*
		begin
		s=x^y;
		c=x&y;
		end
endmodule
//ALU