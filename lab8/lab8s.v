`timescale 1ns/100ps

module reg11bit(Q,d,clk,reset);
	input [10:0] d;
	input clk,reset;
	output reg [10:0] Q;
	always@( clk or reset)
	begin
		if(!reset)
		Q<=11'd0;
		else
		Q<=d;
	end
endmodule

module reg4bit(Q,d,clk,reset);
	input [3:0] d;
	input clk,reset;
	output reg [3:0] Q;
	always@( clk or reset)
	begin
		if(!reset)
		Q<=4'd0;
		else
		Q<=d;
	end
endmodule

module encoder(FuncCode,OpCode);
	input [7:0] FuncCode;
  output  [2:0] OpCode;
  reg [2:0] OpCode;
  always  @ (FuncCode)  begin
    if  (FuncCode[7])
      OpCode = 3'd0;
    else if  (FuncCode[6])
      OpCode = 3'd1;
    else if  (FuncCode[5])
      OpCode = 3'd2;
    else if  (FuncCode[4])
      OpCode = 3'd3;
    else if  (FuncCode[3])
      OpCode = 3'd4;
    else if  (FuncCode[2])
      OpCode = 3'd5;
    else if  (FuncCode[1])
      OpCode = 3'd6;
    else if  (FuncCode[0])
      OpCode = 3'd7;
    else
      OpCode = 3'bZZZ;
  end
endmodule

module ALU(A,B,opcode,X);
	input [3:0] A,B;
	input [2:0] opcode;
	output reg [3:0] X;
	always@(*)
	begin
		if(opcode == 3'b000)
			X = A + B;
		else if(opcode == 3'b001)
			X= A-B;
		else if(opcode == 3'b010)
			X= A^B;
		else if(opcode == 3'b011)
			X=A|B;
		else if(opcode == 3'b100)
			X = A & B;
		else if(opcode == 3'b101)
			X = A~|B;
		else if(opcode == 3'b110)
			X = A~&B;
		else if(opcode == 3'b111)
			X = A~^B;
	end
endmodule

module evenparity(X,parity);
	input [3:0] X;
	output reg parity;
	always@(*)
		begin
			parity = X[0]^X[1]^X[2]^X[3];//odd num of 1's output is 1
		end
endmodule
		
module exec_pipeline;
	reg[7:0] funcode;
	reg[3:0] A,B;
	reg clk,reset;
	wire[2:0] opcode;
	wire[3:0] X;
	wire parity;
	wire [10:0] reg1;wire [3:0] reg2;
	encoder e1(funcode,opcode);
	reg11bit r11(reg1,{opcode,A,B},clk,reset);
	ALU a1(reg1[7:4],reg1[3:0],reg1[10:8],X);
	reg4bit r4(reg2,X,clk,reset);
	evenparity p1(reg2,parity);
	
	initial
	begin
		$dumpfile("test.vcd");
		$dumpvars();
	end
	always
	#1 clk = ~clk;
	
	initial
		$monitor(,$time,"opcode=%b,A=%b,B=%b,X=%b,parity=%b,pipe1=%b,pipe2=%b",opcode,A,B,X,parity,reg1,reg2);
	initial
	begin
		#0 clk = 1'b0;reset = 1'b0;
		#10 funcode = 8'b10101010; A = 4'b1001;	B = 4'b1101;reset = 1'b1;
		#30 funcode = 8'b11101011;
		#3  funcode = 8'b01101100;
		#100 $finish;
	end
endmodule

	

			