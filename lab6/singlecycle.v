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

module instructionmemory(instruction,pointer);
	input [4:0] pointer;
	//input clk;
	output reg [31:0] instruction;
	reg [31:0] memory[0:31];//size of im 32 bit im[0:size] size represents number of adrress
	initial 
	begin
	memory[0] = 32'b00000000000000000000000000000000;  // nop
    memory[1] = 32'b00000000000000000000000000000000;  // nop
    memory[2] = 32'b00000000000000000000000000000000;  // nop
    memory[3] = 32'b10001100000100010000000000001000;  // lw  $s1($17), 8($0)
    memory[4] = 32'b10001100000100100000000000000100;  // lw  $s2($18), 4($0)
    memory[5] = 32'b00000010001100100100000000100000;  // add $t0($8), $s1($17), $s2($18)
    memory[6] = 32'b00000000000000010000000000000000;  // nop
    memory[7] = 32'b00000000000000000000000000000000;  // nop
    memory[8] = 32'b00000000000000000000000000000000;  // nop
    memory[9] = 32'b00000000000000000000000000000000;  // nop
    memory[10]= 32'b00000000000000000000000000000000;  // nop
    memory[11]= 32'b00000000000000000000000000000000;  // nop
    memory[12]= 32'b00000000000000000000000000000000;  // nop
    memory[13]= 32'b00000000000000000000000000000000;  // nop
    memory[14]= 32'b00000000000000000000000000000000;  // nop
    memory[15]= 32'b00000000000000000000000000000000;  // nop
    memory[16]= 32'b00000000000000000000000000000000;  // nop
    memory[17]= 32'b00000000000000000000000000000000;  // nop
    memory[18]= 32'b00000000000000000000000000000000;  // nop 
    memory[19]= 32'b00000000000000000000000000000000;  // nop
    memory[20]= 32'b00000000000000000000000000000000;  // nop
    memory[21]= 32'b00000000000000000000000000000000;  // nop
    memory[22]= 32'b00000000000000000000000000000000;  // nop
    memory[23]= 32'b00000000000000000000000000000000;  // nop
    memory[24]= 32'b00000000000000000000000000000000;  // nop
    memory[25]= 32'b00000000000000000000000000000000;  // nop
    memory[26]= 32'b00000000000000000000000000000000;  // nop
    memory[27]= 32'b00000000000000000000000000000000;  // nop
    memory[28]= 32'b00000000000000000000000000000000;  // nop 
    memory[29]= 32'b00000000000000000000000000000000;  // nop
    memory[30]= 32'b00000000000000000000000000000000;  // nop
    memory[31]= 32'b00000000000000000000000000000000;  // nop
	end
	integer addr;
	always@(*)
	begin
	addr=pointer;
	instruction = memory[addr];
	end
endmodule
//PC
module PC(out,in);
	input [4:0] in;
	output reg [4:0] out;
	always@(*)
		out = in;
endmodule

module  ALUControlUnit(Op, Func, ALUOp0, ALUOp1);
  input [5:0] Func;
  input ALUOp0, ALUOp1;
  output  [2:0] Op;
  assign  Op[0] = ALUOp1 & (Func[3] | Func[0]);
  assign  Op[1] = (~ALUOp1) | (~Func[2]);
  assign  Op[2] = ALUOp0 | (ALUOp1 & Func[1]);
endmodule

module  MainControlUnit(RegDst, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, ALUOp0, ALUOp1, Op);
  output  RegDst, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, ALUOp0, ALUOp1;
  input [5:0] Op;
  wire  RFormat, LW, SW, BEQ;
  assign  RFormat = (~Op[5])&(~Op[4])&(~Op[3])&(~Op[2])&(~Op[1])&(~Op[0]);
  assign  LW = (Op[5])&(~Op[4])&(~Op[3])&(~Op[2])&(Op[1])&(Op[0]);
  assign  SW = (Op[5])&(~Op[4])&(Op[3])&(~Op[2])&(Op[1])&(Op[0]);
  assign  BEQ = (~Op[5])&(~Op[4])&(~Op[3])&(Op[2])&(~Op[1])&(~Op[0]);
  assign  RegDst = RFormat;
  assign  ALUSrc = LW | SW;
  assign  MemToReg = LW;
  assign  RegWrite = RFormat | LW;
  assign  MemRead = LW;
  assign  MemWrite = SW;
  assign  Branch = BEQ;
  assign  ALUOp0 = RFormat;
  assign  ALUOp1 = BEQ;
endmodule

module reg_32bit(q,d,clk,reset);//neg-reset
	input [31:0] d;
	input clk,reset;
	output reg [31:0] q;
	
	initial
	q=32'd2;
	
	always@(posedge clk)
	begin
	if(!reset)
		q<=32'd2;
	else
		q<=d;
	end
endmodule

module mux32_1(Out, Data00, Data01, Data02, Data03, Data04, Data05, Data06, Data07, Data08, Data09, Data10, Data11, Data12, Data13, Data14, Data15, Data16, Data17, Data18, Data19, Data20, Data21, Data22, Data23, Data24, Data25, Data26, Data27, Data28, Data29, Data30, Data31, Select);
  input [31:0]  Data00, Data01, Data02, Data03, Data04, Data05, Data06, Data07, Data08, Data09, Data10, Data11, Data12, Data13, Data14, Data15, Data16, Data17, Data18, Data19, Data20, Data21, Data22, Data23, Data24, Data25, Data26, Data27, Data28, Data29, Data30, Data31;
  input [4:0] Select;
  output  [31:0]  Out;
  reg [31:0]  Out;
  always @ (Data00 or Data01 or Data02 or Data03 or Data04 or Data05 or Data06 or Data07 or Data08 or Data09 or Data10 or Data11 or Data12 or Data13 or Data14 or Data15 or Data16 or Data17 or Data18 or Data19 or Data20 or Data21 or Data22 or Data23 or Data24 or Data25 or Data26 or Data27 or Data28 or Data29 or Data30 or Data31 or Select)
    case  (Select)
      5'b00000:  Out = Data00;
      5'b00001:  Out = Data01;
      5'b00010:  Out = Data02;
      5'b00011:  Out = Data03;
      5'b00100:  Out = Data04;
      5'b00101:  Out = Data05;
      5'b00110:  Out = Data06;
      5'b00111:  Out = Data07;
      5'b01000:  Out = Data08;
      5'b01001:  Out = Data09;
      5'b01010:  Out = Data10;
      5'b01011:  Out = Data11;
      5'b01100:  Out = Data12;
      5'b01101:  Out = Data13;
      5'b01110:  Out = Data14;
      5'b01111:  Out = Data15;
      5'b10000:  Out = Data16;
      5'b10001:  Out = Data17;
      5'b10010:  Out = Data18;
      5'b10011:  Out = Data19;
      5'b10100:  Out = Data20;
      5'b10101:  Out = Data21;
      5'b10110:  Out = Data22;
      5'b10111:  Out = Data23;
      5'b11000:  Out = Data24;
      5'b11001:  Out = Data25;
      5'b11010:  Out = Data26;
      5'b11011:  Out = Data27;
      5'b11100:  Out = Data28;
      5'b11101:  Out = Data29;
      5'b11110:  Out = Data30;
      5'b11111:  Out = Data31;
    endcase
endmodule

module decoder5_32(Out, In);
  input [4:0] In;
  output reg [31:0] Out;
  always@(*)
  begin
		Out[0] = (~In[4] & ~In[3] & ~In[2] & ~In[1] & ~In[0]);
          Out[1] = (~In[4] & ~In[3] & ~In[2] & ~In[1] & In[0]);
          Out[2] = (~In[4] & ~In[3] & ~In[2] & In[1] & ~In[0]);
          Out[3] = (~In[4] & ~In[3] & ~In[2] & In[1] & In[0]);
          Out[4] = (~In[4] & ~In[3] & In[2] & ~In[1] & ~In[0]);
          Out[5] = (~In[4] & ~In[3] & In[2] & ~In[1] & In[0]);
          Out[6] = (~In[4] & ~In[3] & In[2] & In[1] & ~In[0]);
          Out[7] = (~In[4] & ~In[3] & In[2] & In[1] & In[0]);
          Out[8] = (~In[4] & In[3] & ~In[2] & ~In[1] & ~In[0]);
          Out[9] = (~In[4] & In[3] & ~In[2] & ~In[1] & In[0]);
          Out[10] = (~In[4] & In[3] & ~In[2] & In[1] & ~In[0]);
          Out[11] = (~In[4] & In[3] & ~In[2] & In[1] & In[0]);
          Out[12] = (~In[4] & In[3] & In[2] & ~In[1] & ~In[0]);
          Out[13] = (~In[4] & In[3] & In[2] & ~In[1] & In[0]);
          Out[14] = (~In[4] & In[3] & In[2] & In[1] & ~In[0]);
          Out[15] = (~In[4] & In[3] & In[2] & In[1] & In[0]);
          Out[16] = (In[4] & ~In[3] & ~In[2] & ~In[1] & ~In[0]);
          Out[17] = (In[4] & ~In[3] & ~In[2] & ~In[1] & In[0]);
          Out[18] = (In[4] & ~In[3] & ~In[2] & In[1] & ~In[0]);
          Out[19] = (In[4] & ~In[3] & ~In[2] & In[1] & In[0]);
          Out[20] = (In[4] & ~In[3] & In[2] & ~In[1] & ~In[0]);
          Out[21] = (In[4] & ~In[3] & In[2] & ~In[1] & In[0]);
          Out[22] = (In[4] & ~In[3] & In[2] & In[1] & ~In[0]);
          Out[23] = (In[4] & ~In[3] & In[2] & In[1] & In[0]);
          Out[24] = (In[4] & In[3] & ~In[2] & ~In[1] & ~In[0]);
          Out[25] = (In[4] & In[3] & ~In[2] & ~In[1] & In[0]);
          Out[26] = (In[4] & In[3] & ~In[2] & In[1] & ~In[0]);
          Out[27] = (In[4] & In[3] & ~In[2] & In[1] & In[0]);
          Out[28] = (In[4] & In[3] & In[2] & ~In[1] & ~In[0]);
          Out[29] = (In[4] & In[3] & In[2] & ~In[1] & In[0]);
          Out[30] = (In[4] & In[3] & In[2] & In[1] & ~In[0]);
          Out[31] = (In[4] & In[3] & In[2] & In[1] & In[0]);
	end
endmodule


module RegFile_32(ReadData1, ReadData2, Clock, Reset, RegWrite, ReadReg1, ReadReg2, WriteRegNo, WriteData);
  input Clock, Reset, RegWrite;
  input [4:0] ReadReg1, ReadReg2, WriteRegNo;
  input [31:0]  WriteData;
  output  [31:0]  ReadData1, ReadData2;
  wire  [31:0]  Data0, Data1, Data2, Data3, Data4, Data5, Data6, Data7, Data8, Data9, Data10, Data11, Data12, Data13, Data14, Data15, Data16, Data17, Data18, Data19, Data20, Data21, Data22, Data23, Data24, Data25, Data26, Data27, Data28, Data29, Data30, Data31;
  wire  [31:0] Decode;
  wire  [31:0]c;
  genvar  j;
  decoder5_32 dec(Decode, WriteRegNo);
  generate
    for(j = 0; j < 32; j = j + 1) begin:  and_loop
      and g(c[j], RegWrite, Decode[j], Clock);
    end
  endgenerate
  reg_32bit r0(Data0, WriteData, c[0], Reset);
  reg_32bit r1(Data1, WriteData, c[1], Reset);
  reg_32bit r2(Data2, WriteData, c[2], Reset);
  reg_32bit r3(Data3, WriteData, c[3], Reset);
  reg_32bit r4(Data4, WriteData, c[4], Reset);
  reg_32bit r5(Data5, WriteData, c[5], Reset);
  reg_32bit r6(Data6, WriteData, c[6], Reset);
  reg_32bit r7(Data7, WriteData, c[7], Reset);
  reg_32bit r8(Data8, WriteData, c[8], Reset);
  reg_32bit r9(Data9, WriteData, c[9], Reset);
  reg_32bit r10(Data10, WriteData, c[10], Reset);
  reg_32bit r11(Data11, WriteData, c[11], Reset);
  reg_32bit r12(Data12, WriteData, c[12], Reset);
  reg_32bit r13(Data13, WriteData, c[13], Reset);
  reg_32bit r14(Data14, WriteData, c[14], Reset);
  reg_32bit r15(Data15, WriteData, c[15], Reset);
  reg_32bit r16(Data16, WriteData, c[16], Reset);
  reg_32bit r17(Data17, WriteData, c[17], Reset);
  reg_32bit r18(Data18, WriteData, c[18], Reset);
  reg_32bit r19(Data19, WriteData, c[19], Reset);
  reg_32bit r20(Data20, WriteData, c[20], Reset);
  reg_32bit r21(Data21, WriteData, c[21], Reset);
  reg_32bit r22(Data22, WriteData, c[22], Reset);
  reg_32bit r23(Data23, WriteData, c[23], Reset);
  reg_32bit r24(Data24, WriteData, c[24], Reset);
  reg_32bit r25(Data25, WriteData, c[25], Reset);
  reg_32bit r26(Data26, WriteData, c[26], Reset);
  reg_32bit r27(Data27, WriteData, c[27], Reset);
  reg_32bit r28(Data28, WriteData, c[28], Reset);
  reg_32bit r29(Data29, WriteData, c[29], Reset);
  reg_32bit r30(Data30, WriteData, c[30], Reset);
  reg_32bit r31(Data31, WriteData, c[31], Reset);
  mux32_1 m0(ReadData1, Data0, Data1, Data2, Data3, Data4, Data5, Data6, Data7, Data8, Data9, Data10, Data11, Data12, Data13, Data14, Data15, Data16, Data17, Data18, Data19, Data20, Data21, Data22, Data23, Data24, Data25, Data26, Data27, Data28, Data29, Data30, Data31, ReadReg1);
  mux32_1 m1(ReadData2, Data0, Data1, Data2, Data3, Data4, Data5, Data6, Data7, Data8, Data9, Data10, Data11, Data12, Data13, Data14, Data15, Data16, Data17, Data18, Data19, Data20, Data21, Data22, Data23, Data24, Data25, Data26, Data27, Data28, Data29, Data30, Data31, ReadReg2);
endmodule

module signextender(out,in);
	input [15:0] in;
	output [31:0] out;
	assign out = { {16{in[15]}}, in};
endmodule

module SCDP(ALU_output,PC,reset,clk);
	input reset,clk;
	input [4:0] PC;
	output [31:0] ALU_output;
	wire [4:0] im_in;
	wire [31:0] instruction;
	reg [4:0] w1;
	
	PC p1(im_in,PC);
	instructionmemory ins_mem(instruction,im_in);
	
	wire RegDst, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, ALUOp0, ALUOp1;
	MainControlUnit mcu(RegDst, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, ALUOp0, ALUOp1, instruction[31:26]);
	always@(*)
	begin
		if(RegDst)
		w1=instruction[15:11];
		else
		w1 = instruction[20:16];
	end
	wire [31:0] ReadData1,ReadData2;
	RegFile_32 r32(ReadData1, ReadData2, clk, reset, RegWrite, instruction[25:21], instruction[20:16], w1, ALU_output);
	
	wire [31:0] sign_ext;
	signextender se(sign_ext,instruction[15:0]);
	
	reg [31:0] addB;
	always@(*)
	begin
		if(ALUSrc)
		addB = sign_ext;
		else
		addB = ReadData2;
	end
	
	wire [2:0] aluOp;
	ALUControlUnit au(aluOp,instruction[5:0], ALUOp0,ALUOp1);
	
	wire cout;
	ALU a1(ReadData1,addB,1'b0,1'b0,aluOp[1:0],ALU_output,cout);
	
endmodule
	
module TestBench;
wire [31:0] ALU_output;
reg [4:0] PC;
reg reset,clk;
SCDP sdp(ALU_output,PC,reset,clk);
initial
begin
$monitor("at time %0d IPC = %d, Reset = %d , CLK = %d , ALU Output = %d",$time,PC,reset,clk, ALU_output);
#0 clk = 0; PC = 6;reset=0;
#30 reset = 1;
#400 $finish;
end

always
begin
#10 clk = ~clk;
end

initial
begin
$dumpfile("sc.vcd");
$dumpvars();
end

endmodule
	
		

