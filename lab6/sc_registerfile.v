module reg_32bit(q,d,clk,reset);//neg-reset
	input [31:0] d;
	input clk,reset;
	output reg [31:0] q;
	always@(posedge clk or negedge reset)
	begin
	if(!reset)
		q<=32'd0;
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
  output  [31:0] Out;
  assign  Out[0] = (~In[4] & ~In[3] & ~In[2] & ~In[1] & ~In[0]),
          Out[1] = (~In[4] & ~In[3] & ~In[2] & ~In[1] & In[0]),
          Out[2] = (~In[4] & ~In[3] & ~In[2] & In[1] & ~In[0]),
          Out[3] = (~In[4] & ~In[3] & ~In[2] & In[1] & In[0]),
          Out[4] = (~In[4] & ~In[3] & In[2] & ~In[1] & ~In[0]),
          Out[5] = (~In[4] & ~In[3] & In[2] & ~In[1] & In[0]),
          Out[6] = (~In[4] & ~In[3] & In[2] & In[1] & ~In[0]),
          Out[7] = (~In[4] & ~In[3] & In[2] & In[1] & In[0]),
          Out[8] = (~In[4] & In[3] & ~In[2] & ~In[1] & ~In[0]),
          Out[9] = (~In[4] & In[3] & ~In[2] & ~In[1] & In[0]),
          Out[10] = (~In[4] & In[3] & ~In[2] & In[1] & ~In[0]),
          Out[11] = (~In[4] & In[3] & ~In[2] & In[1] & In[0]),
          Out[12] = (~In[4] & In[3] & In[2] & ~In[1] & ~In[0]),
          Out[13] = (~In[4] & In[3] & In[2] & ~In[1] & In[0]),
          Out[14] = (~In[4] & In[3] & In[2] & In[1] & ~In[0]),
          Out[15] = (~In[4] & In[3] & In[2] & In[1] & In[0]),
          Out[16] = (In[4] & ~In[3] & ~In[2] & ~In[1] & ~In[0]),
          Out[17] = (In[4] & ~In[3] & ~In[2] & ~In[1] & In[0]),
          Out[18] = (In[4] & ~In[3] & ~In[2] & In[1] & ~In[0]),
          Out[19] = (In[4] & ~In[3] & ~In[2] & In[1] & In[0]),
          Out[20] = (In[4] & ~In[3] & In[2] & ~In[1] & ~In[0]),
          Out[21] = (In[4] & ~In[3] & In[2] & ~In[1] & In[0]),
          Out[22] = (In[4] & ~In[3] & In[2] & In[1] & ~In[0]),
          Out[23] = (In[4] & ~In[3] & In[2] & In[1] & In[0]),
          Out[24] = (In[4] & In[3] & ~In[2] & ~In[1] & ~In[0]),
          Out[25] = (In[4] & In[3] & ~In[2] & ~In[1] & In[0]),
          Out[26] = (In[4] & In[3] & ~In[2] & In[1] & ~In[0]),
          Out[27] = (In[4] & In[3] & ~In[2] & In[1] & In[0]),
          Out[28] = (In[4] & In[3] & In[2] & ~In[1] & ~In[0]),
          Out[29] = (In[4] & In[3] & In[2] & ~In[1] & In[0]),
          Out[30] = (In[4] & In[3] & In[2] & In[1] & ~In[0]),
          Out[31] = (In[4] & In[3] & In[2] & In[1] & In[0]);
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
  mux32_1 m0(ReadData1, Data00, Data01, Data02, Data03, Data04, Data05, Data06, Data07, Data08, Data09, Data10, Data11, Data12, Data13, Data14, Data15, Data16, Data17, Data18, Data19, Data20, Data21, Data22, Data23, Data24, Data25, Data26, Data27, Data28, Data29, Data30, Data31, ReadReg1);
  mux32_1 m1(ReadData2, Data00, Data01, Data02, Data03, Data04, Data05, Data06, Data07, Data08, Data09, Data10, Data11, Data12, Data13, Data14, Data15, Data16, Data17, Data18, Data19, Data20, Data21, Data22, Data23, Data24, Data25, Data26, Data27, Data28, Data29, Data30, Data31, ReadReg2);
endmodule