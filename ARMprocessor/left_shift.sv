`timescale 1ns/10ps

module left_shift #(parameter WIDTH = 64, SHIFT_AMT = 2) (out, in);
		output logic [WIDTH-1:0] out;
		input logic [WIDTH-1:0] in;

		parameter delay = 0.05;

		integer i, j;
		
		always_comb begin	
			for(i=0; i<SHIFT_AMT; i++)
				out[i] = 1'b0;
			for(j=SHIFT_AMT; j<WIDTH; j++)
				out[j] = in[j-SHIFT_AMT];
		end

endmodule


module left_shift_testbench();
		parameter WIDTH = 6;
		parameter SHIFT_AMT = 2;
		logic [WIDTH-1:0] out, in;
		
		left_shift #(.WIDTH(WIDTH), .SHIFT_AMT(SHIFT_AMT)) dut (.out, .in);
		
		initial begin
				in = 6; #10;
				in = 4; #10;
				in = 2; #10;
				in = -2; #10;
				
		end
endmodule