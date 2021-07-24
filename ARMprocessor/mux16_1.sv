`timescale 1ns/10ps

module mux16_1(out, in, sel);
		output logic      out;
		input logic [15:0]  in; 
		input logic [3:0] sel;
		logic [1:0]         v;
	
		//Mux two 8 to 1 mux's.
		mux8_1 m0(.out(v[0]),  .in(in[7:0]), .sel(sel[2:0]));
		mux8_1 m1(.out(v[1]),  .in(in[15:8]), .sel(sel[2:0]));
		mux2_1 m(.out(out),  .in(v[1:0]),  .sel(sel[3]));

endmodule

module mux16_1_testbench();
		logic [15:0]  in;
		logic [3:0] sel;
		logic       out;
		
		mux16_1 dut (.out, .in, .sel);
		
		initial begin
				sel=4'b0000; in=2048; #10;
				sel=4'b0010; in=0; #10;
				sel=4'b0100; in=2048; #10;
				sel=4'b1000; in=128; #10;
				sel=4'b1011; in=2048; #10;


		end
endmodule