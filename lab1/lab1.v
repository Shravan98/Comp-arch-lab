module halfadder(a,b,s,c);
	input a,b;
	output s,c;
	wire s1,s2,s3;
	//xor x1(s,a,b);
	//and a1 (c,a,b);
	 nand #10 n3(s1,a,b);
	 nand #10 n4(s2,s1,a);
	 nand #10 n5(s3,s1,b);
	 nand #10 n6(s,s2,s3);
	 nand n2(c,s1,1);
endmodule

module fulladder(a,b,cin,s,cout);
	input a,b,cin;
	output s,cout;
	wire i1,s1,s2,s3,s4,s5,s6;
	
	 nand #10 n3(s1,a,b);
	 nand #10 n4(s2,s1,a);
	 nand #10 n5(s3,s1,b);
	 nand #10 n6(i1,s2,s3);
	 nand #10 n3(s4,i1,cin);
	 nand #10 n4(s5,s4,i1);
	 nand #10 n5(s6,s4,cin);
	 nand #10 n6(s,s5,s6);
	 nand #10 n7(cout,s1,s4);
endmodule	 
	
module bit4ripplecarry(a,b,cin,s,cout);
	input [3:0] a,b;
	input cin;
	output [3:0] s;
	output cout;
	wire c[2:0];
	
	fulladder f1(a[0],b[0],cin,s[0],c[0]);
	fulladder f2(a[1],b[1],c[0],s[1],c[1]);
	fulladder f3(a[2],b[2],c[1],s[2],c[2]);
	fulladder f4(a[3],b[3],c[2],s[3],cout);
endmodule	


module nbitripplecarry(a,b,control,s,cout);
	parameter n=32;
	input [n-1:0] a,b;
	input control;
	reg [n-1:0] mod;
	wire [n-1:0] carry;
	output [n-1:0] s;
	output reg cout;
	
	
	integer j;
	always@*
	begin
	for(j=0;j<n;j=j+1) 
	begin
		mod[j] = control^b[j];
	end
	end 
	
	fulladder f0(a[0],mod[0],control,s[0],carry[0]);
	genvar i;
	for(i=1;i<n;i=i+1)
	begin:two
		fulladder f1(a[i],mod[i],carry[i-1],s[i],carry[i]);
	end
	//endgenerate
	always@*
		cout = carry[n-1];
endmodule
	
module testbench;
	reg [31:0] a,b;
	reg control;
	wire [31:0] s;
	wire cout;
	
	nbitripplecarry n1(a,b,control,s,cout);
	
	initial
	begin
		$monitor(,$time,"a=%d,b=%d,control=%b,s=%d,cout=%b",a,b,control,s,cout);
	end
	
	initial
		begin
		a=32'd13;b=32'd12;control=1'b1;
		end
endmodule
	