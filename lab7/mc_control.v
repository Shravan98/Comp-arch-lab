module multicycle_control(op5,op4,op3,op2,op1,op0,s3,s2,s1,s0,Pcwrite,PcwriteCond,IorD,MemRead,MemWrite,IRWrite,MemtoReg,PCSource1,PCSource0,ALUop1,ALUop0,ALUSrcB1,ALUSrcB0,ALUSrcA,RegWrite,RegDst,Ns3,Ns2,Ns1,Ns0);

	input op5,op4,op3,op2,op1,op0,s3,s2,s1,s0;
	reg [16:0] temp;
	output reg Pcwrite,PcwriteCond,IorD,MemRead,MemWrite,IRWrite,MemtoReg,PCSource1,PCSource0,ALUop1,ALUop0,ALUSrcB1,ALUSrcB0,ALUSrcA,RegWrite,RegDst,Ns3,Ns2,Ns1,Ns0;
	always@(*)
	begin
	temp[0] = ~s3&~s2&~s1&~s0;
	temp[1] = ~s3&~s2&~s1&s0;
	temp[2] = ~s3&~s2&s1&~s0;
	temp[3] = ~s3&~s2&s1&s0;
	temp[4] = ~s3&s2&~s1&~s0;
	temp[5] = ~s3&s2&~s1&s0;
	temp[6] = (~s3)&(s2)&(s1)&(~s0);
	temp[7]  = (~s3)&(s1)&(s1)&(s0);
	temp[8]  = (s3)&(~s1)&(~s1)&(~s0);
	temp[9]  = (s3)&(~s1)&(~s1)&(s0);
	temp[10]  = (~s3)&(~s1)&(~s1)&(s0)&(~op5)
			&(~op4)&(~op3)&(~op2)&(op1)&(~op0);
	temp[11]  = (~s3)&(~s1)&(~s1)&(s0)&(~op5)
			&(~op4)&(~op3)&(op2)&(~op1)&(~op0);
	temp[12]  = (~s3)&(~s1)&(~s1)&(s0)&(~op5)
			&(~op4)&(~op3)&(~op2)&(~op1)&(~op0);
	temp[13]  = (~s3)&(~s1)&(s1)&(~s0)&(op5)
			&(~op4)&(op3)&(~op2)&(op1)&(op0);	
	temp[14]  = (~s3)&(~s1)&(~s1)&(s0)&(op5)
			&(~op4)&(~op3)&(~op2)&(op1)&(op0);	
	temp[15]  = (~s3)&(~s1)&(~s1)&(s0)&(op5)
			&(~op4)&(op3)&(~op2)&(op1)&(op0);
	temp[16]  = (~s3)&(~s1)&(s1)&(~s0)&(op5)
			&(~op4)&(~op3)&(~op2)&(op1)&(op0);
	
	Pcwrite = temp[0] | temp[9];
	PcwriteCond = temp[8];
	IorD = temp[3] | temp[5];
	MemRead = temp[0] | temp[3];
	MemWrite = temp[5];
	IRWrite = temp[0];
	MemtoReg = temp[4];
	PCSource1 = temp[9];
	PCSource0 = temp[8];
	ALUop1 = temp[6];
	ALUop0 = temp[8];
	ALUSrcB1 = temp[1] | temp[2];
	ALUSrcB0 = temp[0]|temp[1];
	ALUSrcA = temp[2];
	RegWrite = temp[4] | temp[7];
	RegDst = temp[7];
	Ns3 = temp[10] | temp[11];
	Ns2 = temp[3] | temp[6] | temp[12] | temp[13];
	Ns1 = temp[6] | temp[12] | temp[14] | temp[15] | temp[16];
	Ns0 = temp[0] | temp[6] | temp[10] | temp[13] | temp[16];
	end
endmodule

module statetransfer(s,ns,clk,reset);
	
	input [3:0] ns;input clk,reset;
	output reg [3:0] s;
	initial
		s<=4'b0000;
	always@(clk /*or reset*/)
	begin
		if(reset)
		s<=ns;
		//else
		//s<=4'b000;
	end
endmodule

/*module initialize_reg(s);
	output reg [3:0] s;
	initial
		s=4'b0000;
endmodule*/

module testbench_mccontrol;
	reg[5:0] op;
	wire [3:0] s;
	reg clk,reset;
	wire Pcwrite,PcwriteCond,IorD,MemRead,MemWrite,IRWrite,MemtoReg,PCSource1,PCSource0,ALUop1,ALUop0,ALUSrcB1,ALUSrcB0,ALUSrcA,RegWrite,RegDst;
	wire[3:0] ns;
	//initialize_reg r(s);
	statetransfer st(s,ns,clk,reset);
	multicycle_control mc(op[5],op[4],op[3],op[2],op[1],op[0],s[3],s[2],s[1],s[0],Pcwrite,PcwriteCond,IorD,MemRead,MemWrite,IRWrite,MemtoReg,PCSource1,PCSource0,ALUop1,ALUop0,ALUSrcB1,ALUSrcB0,ALUSrcA,RegWrite,RegDst,ns[3],ns[2],ns[1],ns[0]);
	

	initial
	begin
		$dumpfile("test.vcd");
		$dumpvars();
	end
	always
	#1 clk=~clk;
	initial
	begin
	$monitor(,$time,"op=%b,state=%b,next state=%b",op,s,ns);
	#0 clk = 1'b0;op=6'd0;reset = 1'b0;
	#1 reset = 1'b1;
	#2 op = 6'd30;
	#5 op=6'd3;
	#3 op=6'd14;
	$finish;
	end
	

endmodule


