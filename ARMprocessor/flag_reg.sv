`timescale 1ns/10ps

module flag_reg #(parameter WIDTH = 64) (out_flags, in_flags, clk, enable);
		output logic [3:0] out_flags;
		input logic [3:0] in_flags;
		input logic clk, enable;
		
		en_D_FF neg_reg (.q(out_flags[3]), .d(in_flags[3]), .enable, .clk);
		en_D_FF zero_reg (.q(out_flags[2]), .d(in_flags[2]), .enable, .clk);
		en_D_FF overflow_reg (.q(out_flags[1]), .d(in_flags[1]), .enable, .clk);
		en_D_FF carry_reg (.q(out_flags[0]), .d(in_flags[0]), .enable, .clk);

endmodule


module flag_reg_testbench();
		logic [3:0] out_flags, in_flags;
		logic clk, enable;
		
		flag_reg dut (.out_flags, .in_flags, .clk, .enable);
		
		initial begin
				in_flags = 4'b0010; enable = 0; clk = 1; #10;
				in_flags = 4'b0110; enable = 1; clk = 0; #10;
				in_flags = 4'b0000; enable = 1; clk = 1; #10;
				in_flags = 4'b1000; enable = 0; clk = 0; #10;
				in_flags = 4'b1111; enable = 0; clk = 1; #10;
				
		end
endmodule