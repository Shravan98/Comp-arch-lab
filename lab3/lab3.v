module mealy(clk,rst,inp,out);
	input inp;input clk,rst;
	output reg out;
	reg [1:0] state;
	always@(posedge clk,posedge rst)
	begin
		if(rst)
			begin
			state <= 2'b00;
			out <= 1'b0;
			end
		else
		begin
			case(state)
			2'b00:begin
				if(inp)
				begin
					state<=2'b01;
					out<=1'b0;
				end
				else
				begin
					state<=2'b10;
					out<=1'b0;
				end
			end
			2'b01:begin
				if(inp)
				begin
					state<=2'b00;
					out<=1'b1;
				end
				else
				begin
					state<=2'b10;
					out<=1'b0;
				end
			end
			2'b10:begin
				if(inp)
				begin
					state<=2'b01;
					out<=1'b0;
				end
				else
				begin
					state<=2'b00;
					out<=1'b1;
				end
			end
			default:begin
				state<=2'b00;
				out<=1'b0;
				end
			endcase
		end
	end
endmodule

module shiftreg(enable,clk,in,num,Q);
	parameter n =4;
	input in,clk,enable;
	input [3:0] num;
	output reg [3:0] Q;
	//initial
	//begin
	/*initial
	begin
	Q=num;
	end*/
	//end
	always@(posedge clk)
	begin
		if(enable)
		Q={in,Q[n-1:1]};
		else
		Q=num;
	end
endmodule

module testbench;
	parameter n=4;
	reg in,clk,enable;
	reg [3:0] num;
	wire [3:0] Q;
	
	shiftreg s1(enable,clk,in,num,Q);

	initial
	begin
	 $monitor(,$time,"enable=%b,clk=%b,in=%b,Q=%b,num=%b",enable,clk,in,Q,num);
	 clk=1'b0;
	 num = 4'd6;
	end
	always
	#2  clk=~clk;
	initial
	begin
	#0	in=1'b0;enable=1'b0;
	#4	in=1'b0;enable=1'b1;
	#4  in=1'b1;enable=1'b1;
	#6  in=1'b1;enable=1'b1;
	#7	$finish;
	end
	
	initial
	begin
    $dumpfile("lab3.vcd");
    $dumpvars();
	end
	
endmodule


