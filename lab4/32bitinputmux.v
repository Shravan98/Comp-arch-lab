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
//this is the variable that is be used in the generate
//block
 generate for (j=0; j<8;j=j+1) begin: mux_loop
//mux_loop is the name of the loop
 mux2to1 m1(out[j],sel,in1[j],in2[j],in3[j]);
//mux2to1 is instantiated every time it is called
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

module testbench_32bit_input_mux;
	reg [31:0] inp1,inp2,inp3;
	reg [1:0] sel;
	wire [31:0] out;
	bit32_2to1mux d1(out,sel,inp1,inp2,inp3);
	
	initial
	begin
		$dumpfile("test.vcd");
		$dumpvars();
	end
	
	initial
		$monitor(,$time,"inp1=%b,inp2=%b,inp3=%b,sel=%b,out=%b",inp1,inp2,inp3,sel,out);
	
	initial
	begin
		inp1=32'b10101010101010101010101010101010;
		inp2=32'b11111111010101010000010101001110;
		inp3=32'b11101010010110010111010100111010;
		sel=2'b00;
		#30 sel=2'b10;
		#100 $finish;
	end
	
endmodule