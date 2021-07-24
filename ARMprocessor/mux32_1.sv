`timescale 1ns/10ps

module mux32_1(out, in, sel);
		output logic      out;
		input logic [31:0] in; 
		input logic [4:0] sel;
		logic [1:0]         v;
		
		//Mux two 16 to 1 mux's.
		mux16_1 m0(.out(v[0]),  .in(in[15:0]), .sel(sel[3:0]));
		mux16_1 m1(.out(v[1]),  .in(in[31:16]), .sel(sel[3:0]));
		mux2_1 m(.out(out),  .in(v[1:0]),  .sel(sel[4]));

endmodule

module mux32_1_testbench();
		logic [31:0]  in;
		logic [4:0] sel;
		logic       out;
		
		mux32_1 dut (.out, .in, .sel);
		
		initial begin
				sel=5'b00000; in=1; #10;
				sel=5'b00100; in=0; #10;
				sel=5'b01000; in=2048; #10;
				sel=5'b10000; in=128; #10;
				sel=5'b01011; in=2048; #10;


		end
endmodule