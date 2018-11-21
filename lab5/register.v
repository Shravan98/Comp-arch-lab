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

module bitmux4_1(regData,q1,q2,q3,q4,reg_no);
input [1:0] reg_no;
input [31:0] q1,q2,q3,q4;
output reg [31:0] regData;
always @ (*)
begin
if(reg_no == 2'b00)
	regData = q1;
else if(reg_no==2'b01)
	regData = q2;
else if(reg_no == 2'b10)
	regData = q3;
else
	regData= q4;
end
endmodule

module bitdecoder2_4 (register,reg_no);
	input [1:0] reg_no;
	output reg [3:0] register;
	always@*
	begin
		case(reg_no)
		2'b00: register=4'd1;
		2'b01: register=4'd2;
		2'b10: register=4'd4;
		2'b11: register=4'd8;
		endcase
	end
endmodule

module RegFile(clk,reset,ReadReg1,ReadReg2,WriteData,WriteReg,RegWrite,ReadData1,ReadData2);
	input clk,reset,RegWrite;
	input [1:0] ReadReg1,ReadReg2,WriteReg;
	input [31:0] WriteData;
	output [31:0] ReadData1,ReadData2;
	wire [31:0] Register0,Register1,Register2,Register3;
	wire [3:0] decoder_out;wire [3:0] reg_clk;
	
	
	bitdecoder2_4 d1(decoder_out,WriteReg);
	assign reg_clk[0] = clk&RegWrite&decoder_out[0];
	assign reg_clk[1] = clk&RegWrite&decoder_out[1];
	assign reg_clk[2] = clk&RegWrite&decoder_out[2];
	assign reg_clk[3] = clk&RegWrite&decoder_out[3];
	reg_32bit r1(Register0,WriteData,reg_clk[0],reset);
	reg_32bit r2(Register1,WriteData,reg_clk[1],reset);
	reg_32bit r3(Register2,WriteData,reg_clk[2],reset);
	reg_32bit r4(Register3,WriteData,reg_clk[3],reset);
	bitmux4_1 m1(ReadData1,Register0,Register1,Register2,Register3,ReadReg1);
	bitmux4_1 m2(ReadData2,Register0,Register1,Register2,Register3,ReadReg2);
endmodule
	
module tbRegFile4;
  reg Clock, Reset, RegWrite;
  reg [1:0] ReadReg1, ReadReg2, WriteRegNo;
  reg [31:0]  WriteData;
  wire  [31:0]  ReadData1, ReadData2;
  RegFile rgf( Clock, Reset, ReadReg1, ReadReg2,WriteData, WriteRegNo,  RegWrite,ReadData1, ReadData2);
  initial begin
    $monitor($time, ": Reset = %b, RegWrite = %b, ReadReg1 = %b, ReadReg2 = %b, WriteRegNo = %b, WriteData = %b, ReadData1 = %b, ReadData2 = %b.", Reset, RegWrite, ReadReg1, ReadReg2, WriteRegNo, WriteData, ReadData1, ReadData2);
    #0  Clock = 1'b1; ReadReg1 = 2'b00; ReadReg2 = 2'b01; Reset = 1'b1;
    #2  Reset = 1'b0;
    #10 Reset = 1'b1; RegWrite = 1'b1;  WriteData = 32'hF0F0F0F0; WriteRegNo = 2'b00;
    #10 RegWrite = 1'b1;  WriteData = 32'hF8F8F8F8; WriteRegNo = 2'b01;
    #10 RegWrite = 1'b1;  WriteData = 32'hFAFAFAFA; WriteRegNo = 2'b10;
    #10 RegWrite = 1'b1;  WriteData = 32'hFFFFFFFF; WriteRegNo = 2'b11;
    #10 RegWrite = 1'b0;
    #10 ReadReg1 = 2'b00; ReadReg2 = 2'b01;
    #10 ReadReg1 = 2'b10; ReadReg2 = 2'b11;
    #10 $finish;
  end
  always
    #5  Clock = ~Clock;
endmodule

/*module tb32reg;
reg [31:0] d;
reg clk,reset;
wire [31:0] q;
reg_32bit R(q,d,clk,reset);
always @(clk)
#5 clk<=~clk;
initial 
$monitor(,$time,"d=%b,q=%b",d,q);
initial
begin
clk= 1'b1;
reset=1'b0;//reset the register
#20 reset=1'b1;
#20 d=32'hAFAFAFAF;
#200 $finish;
end
endmodule*/