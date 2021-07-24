`timescale 1ns/10ps

module en_decode4_16 (out, in, enable);
		output logic [15:0] out;
		input logic   [3:0] in;
		input logic     enable;
		
		logic ni, nia0, nia1;
		
		parameter delay = 0.05;
		
		// Last input bit acts as enable bit, so it must be
		// anded with enable to activate/deactivate the lower decoders.
		
		not #delay (ni, in[3]);
		and #delay (nia0, ni, enable);
		and #delay (nia1, in[3], enable);
		
		// Last input bit is connected to enable
		// which picks between the two decoders.
		// as the last input bit determines if you are
		// in the lower or upper half of the number range.
		
		en_decode3_8 ed0 (out[7:0], in[2:0], nia0);
		en_decode3_8 ed1 (out[15:8], in[2:0], nia1);
endmodule

module en_decode4_16_testbench ();
		logic [15:0] out;
		logic [3:0] in;
		logic enable;
		
		en_decode4_16 dut (.out, .in, .enable);
		
		integer i;

		initial begin
				for(i=0; i<32; i++) begin
						{in, enable} = i; #10;
				end
		end
endmodule