`timescale 1ns/10ps

module en_decode3_8 (out, in, enable);
		output logic [7:0] out;
		input logic   [2:0] in;
		input logic     enable;
		
		logic ni, nia0, nia1;

		parameter delay = 0.05;
		
		// Last input bit acts as enable bit, so it must be
		// anded with enable to activate/deactivate the lower decoders.
		
		not #delay (ni, in[2]);
		and #delay (nia0, ni, enable);
		and #delay (nia1, in[2], enable);
		
		// Last input bit is connected to enable
		// which picks between the two decoders.
		// as the last input bit determines if you are
		// in the lower or upper half of the number range.
		
		en_decode2_4 ed0 (out[3:0], in[1:0], nia0);
		en_decode2_4 ed1 (out[7:4], in[1:0], nia1);
endmodule

module en_decode3_8_testbench ();
		logic [7:0] out;
		logic [2:0] in;
		logic enable;
		
		en_decode3_8 dut (.out, .in, .enable);
		
		integer i;

		initial begin
				for(i=0; i<16; i++) begin
						{in, enable} = i; #10;
				end
		end
endmodule