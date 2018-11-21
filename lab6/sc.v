module bit32add(in1,in2,cin,sum,carry);
	input [31:0] in1,in2;
	input cin;
	output [31:0] sum;
	output carry;
	

	assign {carry,sum} = in1+in2+cin;
	
	/*
	
	always @ (a or b) begin
		s[0] = 0;
		for (i=0;i<=31;i=i+1) begin
		sum [i] = a[i] ^ b[i] ^ s[i];
		s[i+1] = (a[i] & b[i]) | (b[i] & s[i]) | (s[i] & a[i]);
		end
	carry = s[32];
	end
	
	*/	
endmodule


module bit32and (out,in1,in2);
input [31:0] in1,in2;
output [31:0] out;
assign {out}=in1 &in2;
endmodule

module bit32or (out,in1,in2);
input [31:0] in1,in2;
output [31:0] out;
assign {out}=in1|in2;
endmodule


module mux2to1(out,sel0,sel1,in1,in2,in3);
	input in1,in2,in3,sel0,sel1;
	output out;
	wire not_sel0,not_sel,a1,a2,a3,t;
	
	
	
	not (not_sel0,sel0);
	not (not_sel1,sel1);
	and (a1,not_sel1,not_sel0,in1);
	and (a2,not_sel1,sel0,in2);
	and (a3,sel1,not_sel0,in3);
	or(out,a1,a2,a3);
	
	
endmodule

module bit8_mux(in1,in2,in3,out,sel0,sel1);
	input [7:0] in1,in2,in3;
	output [7:0] out;
	input sel0,sel1;
	genvar i;
	
	generate for(i=0;i<=7;i=i+1) begin: loop
		mux2to1 m2(out[i],sel0,sel1,in1[i],in2[i],in3[i]);
	end
	endgenerate
	
endmodule

module bit32_mux(in1,in2,in3,out,sel0,sel1);
	input [31:0] in1,in2,in3;
	output [31:0] out;
	input sel0,sel1;
	
	/*
	genvar i,j;
	
	generate for(i=0;i<=3;i=i+1) begin: loop
		
		mux2to1 m2(out[(i*8)+7:i*8],sel,in1[[(i*8)+7:i*8],in2[[(i*8)+7:i*8]);
	end
	endgenerate
	*/
	
	
	 bit8_mux n1(in1[7:0],in2[7:0],in3[7:0],out[7:0],sel0,sel1);
	 bit8_mux n2(in1[15:8],in2[15:8],in3[15:8],out[15:8],sel0,sel1);
	 bit8_mux n3(in1[23:16],in2[23:16],in3[23:16],out[23:16],sel0,sel1);
	 bit8_mux n4(in1[31:24],in2[31:24],in3[31:24],out[31:24],sel0,sel1);
endmodule



module reg_32bit(r,D,clock,reset);
	input [31:0] D;
	input reset, clock;
	 
	output reg [31:0] r;
	
	
	
	always @ (posedge clock)
	begin
	if (!reset) r <= 32'd2;
	else r <= D;
	
	
end
endmodule



module bit_mux4_1(regData,q1,q2,q3,q4,reg_no);
	input [31:0] q1,q2,q3,q4;
	input [1:0] reg_no;
	output reg [31:0] regData;
		
	always@(*)
	begin
	
	if (reg_no==2'b00)
	regData = q1;
	else if (reg_no==2'b01)
	regData = q2;
	else if (reg_no==2'b10)
	regData = q3;
	else
	regData = q4;
	end
endmodule

module deco2to4(regno,regout);
	
	input [1:0] regno;
	output reg [3:0] regout;
	
	always@(*)
	begin
		if(regno==2'b00)
		regout = 4'b0001;
		else if(regno==2'b01)
		regout = 4'b0010;
		else if(regno==2'b10)
		regout = 4'b0100;
		else
		regout = 4'b1000;	
		
	end
	
endmodule


//////////////////////////////////////////////
module  MainControlUnit(RegDst, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, ALUOp0, ALUOp1, Op);
  output reg RegDst, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, ALUOp0, ALUOp1;
  input [5:0] Op;
  reg  RFormat, LW, SW, BEQ;
  always@*
  begin
  RFormat = (~Op[5])&(~Op[4])&(~Op[3])&(~Op[2])&(~Op[1])&(~Op[0]);
  LW = (Op[5])&(~Op[4])&(~Op[3])&(~Op[2])&(Op[1])&(Op[0]);
   SW = (Op[5])&(~Op[4])&(Op[3])&(~Op[2])&(Op[1])&(Op[0]);
   BEQ = (~Op[5])&(~Op[4])&(~Op[3])&(Op[2])&(~Op[1])&(~Op[0]);
   RegDst = RFormat;
   ALUSrc = LW | SW;
  MemToReg = LW;
   RegWrite = RFormat | LW;
  MemRead = LW;
  MemWrite = SW;
    Branch = BEQ;
   ALUOp0 = RFormat;
   ALUOp1 = BEQ;
   end
endmodule

module ALU_control(ALUop,funct_field,operation);
	input [1:0] ALUop;
	input [5:0] funct_field;
	
	output reg [2:0] operation;
	
	always@*
	begin
	 operation[2] = (ALUop[0]) | (ALUop[1]&funct_field[1]);
	operation[1] = (~ALUop[1])|(~funct_field[2]);
	 operation[0] = (ALUop[1])&(funct_field[3]|funct_field[0]);
end
endmodule

///////////////////////////////

module regfile(clk,reset,ReadReg1,ReadReg2,WriteData,WriteReg,RegWrite,ReadData1,ReadData2);
	
	input clk,reset,RegWrite;
	input [1:0] ReadReg1,ReadReg2,WriteReg;
	input [31:0] WriteData;
	output[31:0] ReadData2,ReadData1;
	reg [3:0] regclk;
	
	wire [31:0] temp[3:0];
	wire [3:0] deco;
	genvar i;
	
	generate for(i=0;i<=3;i=i+1) begin: loop
		reg_32bit a(temp[i],WriteData,regclk[i],reset);
	end
	endgenerate
	
	bit_mux4_1 m1(ReadData1,temp[0],temp[1],temp[2],temp[3],ReadReg1);
	bit_mux4_1 m2(ReadData2,temp[0],temp[1],temp[2],temp[3],ReadReg2);
	
	
	deco2to4 d1(WriteReg,deco);
	
	integer j;
		
	always@(*)
	begin
	for(j=0;j<=3;j++)
	begin
		regclk[j] = deco[j] & RegWrite & clk ;
	end
	end
	
endmodule

module ALU(in1,in2,binvert,cin,operation,out,cout);

	input [31:0] in1,in2;	
	input cin,binvert;
	input [1:0] operation;
	output [31:0] out;
	output cout;
	wire [31:0] mux1,mux2,mux3; 
	reg [31:0] add;
	
	
	always@(binvert)
	begin
		if(binvert==1'b0)
		add = in2;
		else
		add = ~in2;
	end
	
	bit32and a(mux1,in1,in2);
	bit32or b(mux2,in1,in2);
	bit32add c(in1,add,cin,mux3,cout);
	
	
	bit32_mux d(mux1,mux2,mux3,out,operation[0],operation[1]);
	
endmodule


module instmem(PC,inst);
	input [4:0] PC;
	output reg [31:0] inst;

	reg [31:0] mem[31:0];
	initial
	begin
	mem[0] = 32'b00000000000000010000000000000000;
	mem[1] = 32'b00000000000000010001000000000000;

	end
	
	always@*
	inst = mem[PC];
	
endmodule

module regpc(PC,out);

	input [4:0] PC;
	output reg [4:0] out;
	
	always@*
	out = PC;
	
	
	
endmodule


module SCDP(ALU_output,PC,reset,clk);
	output reg [31:0] ALU_output;
	input [4:0] PC;
	input reset;
	input clk;
	
	wire [4:0] inputInstmem;
	regpc rpc(PC,inputInstmem);
	
	wire [31:0] inst;
	instmem imem(inputInstmem,inst);
	
	wire RegDst, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, ALUOp0, ALUOp1;	
	MainControlUnit mcu(RegDst, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, ALUOp0, ALUOp1, inst[31:26]);
	
	reg [1:0] aluop;
	
	always@*
	begin
	aluop[0] = ALUOp0;
	aluop[1] = ALUOp1;
	end
	
	wire [2:0] Aluinput;//
	ALU_control alucon(aluop,inst[5:0],Aluinput);
	
	
	
	reg [31:0] WriteData;//
	reg [1:0] WriteReg;
	
	always@*
	begin
		if(RegDst==0)
		WriteReg = inst[17:16];
		else
		WriteReg = inst[12:11];
	end
	
	wire [31:0] ReadData2,ReadData1;
	regfile rf(clk,reset,inst[22:21],inst[17:16],WriteData,WriteReg,RegWrite,ReadData1,ReadData2);
	
	integer i;

	
	reg [31:0] aluin2;
	
	
	reg [31:0] signextend;
	always@*
	begin
	signextend[15:0] = inst[15:0];
		
	for(i=16;i<=31;i=i+1)
	signextend[i] = inst[15];
	
	
		if(ALUSrc==0)
		aluin2 = ReadData2;
		else
		aluin2 = signextend;
	end
	
	wire [31:0] Aluout;
	wire cout;
	ALU abb(ReadData1,aluin2,Aluinput[2],1'b0,Aluinput[1:0],Aluout,cout);
	
	always@*
	begin
	 WriteData = Aluout;
	 ALU_output = ReadData1;
	end
	
	

endmodule

module TestBench;
wire [31:0] ALU_output;
reg [4:0] PC;
reg reset,clk;

SCDP sc(ALU_output,PC,reset,clk);
initial
begin
#0 clk = 0; PC = 5'd0; reset = 0;
#50 reset = 1;
#400 $finish;
end
always
begin
#20 clk = ~clk;
end



initial
begin
$dumpfile("test.vcd");
$dumpvars();
end

endmodule
