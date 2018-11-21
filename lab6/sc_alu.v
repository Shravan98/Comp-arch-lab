module bit32AND (out,in1,in2);
input [31:0] in1,in2;
output [31:0] out;
assign {out}=in1 &in2;
endmodule

module bit32OR(out,in1,in2);
input [31:0] in1,in2;
output [31:0] out;
assign out = in1 | in2;
endmodule

module FA_dataflow (Cout, Sum,In1,In2,Cin);
input [31:0] In1,In2;
input Cin;
output Cout;
output [31:0] Sum;
assign {Cout,Sum}=In1+In2+Cin;
endmodule

module mux2to1(out,sel,in1,in2,in3);
 input in1,in2,in3;input [1:0] sel;
 output out;
 wire [1:0] not_sel;wire a1,a2,a3;
 not (not_sel[0],sel[0]);
 not (not_sel[1],sel[1]);
 and (a1,not_sel[1],not_sel[0],in1);
 and (a2,not_sel[1],sel[0],in2);
 and (a3,sel[1],not_sel[0],in3);
 or (out,a1,a2,a3);
endmodule

module bit8_2to1mux(out,sel,in1,in2,in3);
 input [7:0] in1,in2,in3;
 output [7:0] out;
 input [1:0] sel;
 genvar j;

 generate for (j=0; j<8;j=j+1) begin: mux_loop

 mux2to1 m1(out[j],sel,in1[j],in2[j],in3[j]);

end
endgenerate
endmodule

module bit32_2to1mux(out,sel,in1,in2,in3);
	input [31:0] in1,in2,in3;
	output [31:0] out;
	input [1:0] sel;
	genvar j;
	generate for(j=0;j<25;j=j+8) 
		begin:mux1_loop
			bit8_2to1mux s1(out[j+7:j],sel,in1[j+7:j],in2[j+7:j],in3[j+7:j]);
		end
	endgenerate
endmodule

module ALU(a,b,binvert,cin,op,out,cout);
	input [31:0] a,b;
	input binvert,cin;
	input [1:0] op;
	output cout;
	output [31:0] out;
	wire [31:0] nd,o,sum, i;
	assign i = binvert ? ~b:b;
	bit32AND a1(nd,a,b);
	bit32OR b1(o,a,b);
	FA_dataflow f(cout,sum,a,i,cin);
	bit32_2to1mux m1(out,op,nd,o,sum);
endmodule
