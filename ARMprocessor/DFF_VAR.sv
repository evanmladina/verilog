module DFF_VAR #(parameter WIDTH=64) (q, d, reset, clk);
		output logic [WIDTH-1:0] q;
		input logic  [WIDTH-1:0] d;
		input logic     reset, clk;

		genvar i;
		
		generate
			for(i=0; i< WIDTH; i++) begin : eachDff
				D_FF DFF (.q(q[i]), .d(d[i]), .reset, .clk);
			end
		endgenerate
endmodule

module DFF_VAR_testbench();
		parameter TEST_WIDTH=2;
		logic [TEST_WIDTH-1:0] q, d;
		logic       reset, clk;

		parameter PERIOD = 100;
		
		initial begin
			clk<=0;
			forever #(PERIOD/2) clk=~clk;
		end
		
		DFF_VAR #(.WIDTH(TEST_WIDTH)) dut (.q, .d, .reset, .clk);
		
		initial begin
				d=11; reset=0; #50;
				d=10; reset=0; #50;
				d=01; reset=1; #50;
				d=01; reset=0; #50;
		end
endmodule