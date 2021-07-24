`timescale 1ns/10ps

module en_decode2_4 (out, in, enable);
		output logic   [3:0] out;
		input logic     [1:0] in;
		input logic       enable;
		
		logic ni0, ni1;
		
		parameter delay = 0.05;
		
		//Logic for 2 to 4 decoder.
		not #delay (ni0, in[0]);
		not #delay (ni1, in[1]);
		
		and #delay (out[0], ni0, ni1, enable);
		and #delay (out[1], in[0], ni1, enable);
		and #delay (out[2], ni0, in[1], enable);
		and #delay (out[3], in[0], in[1], enable);
endmodule

module en_decode2_4_testbench();
		logic [3:0] out;
		logic [1:0] in;
		logic enable;

		en_decode2_4 dut (.out, .in, .enable);
		
		integer i;

		initial begin
				for(i=0; i<8; i++) begin
						{in, enable} = i; #10;
				end
		end
endmodule