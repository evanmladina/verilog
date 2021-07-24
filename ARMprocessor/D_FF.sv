module D_FF (q, d, reset, clk);
		output reg q;
		input d, reset, clk;
		always_ff @(posedge clk)
		if (reset)
		q <= 0; // On reset, set to 0
		else
		q <= d; // Otherwise out = d
endmodule

module D_FF_testbench();
		logic d, reset, clk;
		logic q;
		
		parameter PERIOD = 100;
		
		initial begin
			clk<=0;
			forever #(PERIOD/2) clk=~clk;
		end
		
		D_FF dut (.q, .d, .reset, .clk);
		
		initial begin
				d=1; reset=0; #50;
				d=1; reset=1; #50;
				d=1; reset=0; #50;
				d=1; reset=0; #50;
		end
endmodule