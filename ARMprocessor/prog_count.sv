`timescale 1ns/10ps

module prog_count #(parameter WIDTH = 64) (out, in, reset, clk);
		output logic [WIDTH-1:0] out;
		input logic [WIDTH-1:0] in;
		input logic reset, clk;

		parameter delay = 0.05;

		DFF_VAR pc_64b (.q(out), .d(in), .reset, .clk);

endmodule


module prog_count_testbench();
		parameter WIDTH = 6;
		logic [WIDTH-1:0] out, in;
		logic reset, clk;
		
		prog_count #(.WIDTH(WIDTH)) dut (.out, .in, .reset, .clk);
		
		initial begin
				in = 1; clk = 0; reset = 0; #10;
				in = 2; clk = 1; reset = 1; #10;
				in = 3; clk = 0; reset = 1; #10;
				in = 4; clk = 1; reset = 0; #10;
				in = 5; clk = 0; #10;
				in = 6; clk = 1; #10;
				
		end
endmodule