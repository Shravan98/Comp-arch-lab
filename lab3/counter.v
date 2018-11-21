module sync_counter(Q,enable,clk);
	input enable,clk;
	output reg [3:0] Q;
	reg m,n;
	initial
	begin
		Q=4'd0;
		m=Q[0]&Q[1];
		n=m&Q[2];
	end
	always@(posedge clk)
	begin
		if(enable)
		begin
			Q[0] <= ~Q[0];
			
			if(Q[0])
				Q[1] <= ~Q[1];
			else
				Q[1] <= Q[1];
				
			m = Q[0]&Q[1];
			
			if(m)
				Q[2] <= ~Q[2];
			else
				Q[2] <= Q[2];
			
			n=m&Q[2];
			
			if(n)
				Q[3] <=~Q[3];
			else
				Q[3] <= Q[3];
		end
		else
			Q=4'd0;
	end
endmodule

module testbench;
	reg enable,clk;
	wire [3:0] Q;
	
	sync_counter sc(Q,enable,clk);
	
	initial
	begin
		$monitor(,$time,"enable=%b,clk=%b,count=%b",enable,clk,Q);
		clk=1'b0;
	end
	
	always
	#2 clk=~clk;
	
	initial
	begin
		#0 enable=1'b1;
		#20 enable = 1'b0;
		#4 enable = 1'b1;
		#30 $finish;
	end
	
	initial
	begin
    $dumpfile("counter.vcd");
    $dumpvars();
	end
		
endmodule