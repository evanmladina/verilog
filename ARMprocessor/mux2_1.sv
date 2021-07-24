`timescale 1ns/10ps

module mux2_1(out, in, sel);
		output logic      out;
		input  logic [1:0] in;
		input  logic      sel;
		
		logic nsel, a0, a1;
		
		parameter delay = 0.05;
		
		//Logic for 2 to 1 mux.
		not #delay (nsel, sel);
		and #delay (a0, in[0], nsel);
		and #delay (a1, in[1], sel);
		or #delay (out, a0, a1);
		
endmodule

module mux2_1_testbench();
		logic [1:0] in; 
		logic      sel;
		logic      out;
		
		mux2_1 dut (.out, .in, .sel);
		
		initial begin
				sel=0; in[0]=0; in[1]=0; #10;
				sel=0; in[0]=0; in[1]=1; #10;
				sel=0; in[0]=1; in[1]=0; #10;
				sel=0; in[0]=1; in[1]=1; #10;
				sel=1; in[0]=0; in[1]=0; #10;
				sel=1; in[0]=0; in[1]=1; #10;
				sel=1; in[0]=1; in[1]=0; #10;
				sel=1; in[0]=1; in[1]=1; #10;
		end
endmodule