`timescale 1ns/10ps

module en_DFF_VAR #(parameter WIDTH=64) (q, d, enable, clk);
		output logic [WIDTH-1:0] q;
		input logic  [WIDTH-1:0] d;
		input logic    enable, clk;

		genvar i;
		
		//Generate WIDTH number of enable D flip flops.
		generate
			for(i=0; i< WIDTH; i++) begin : eachDff
				en_D_FF DFF (.q(q[i]), .d(d[i]), .enable, .clk);
			end
		endgenerate
endmodule

module en_DFF_VAR_testbench();
		parameter TEST_WIDTH=2;
		logic [TEST_WIDTH-1:0] q, d;
		logic       enable, clk;

		parameter PERIOD = 100;
		
		initial begin
			clk<=0;
			forever #(PERIOD/2) clk=~clk;
		end
		
		en_DFF_VAR #(.WIDTH(TEST_WIDTH)) dut (.q, .d, .enable, .clk);
		
		initial begin
			d=2'b10; enable=0; clk=0; #10;
				               clk=1; #10;
				     enable=1; clk=0; #10;
				               clk=1; #10;
				               clk=0; #10;
				d=2'b01;       clk=1; #10;
				               clk=0; #10;
				d=2'b10;			clk=1; #10;
									clk=0; #10;
				     enable=0; clk=1; #10;
		end
endmodule