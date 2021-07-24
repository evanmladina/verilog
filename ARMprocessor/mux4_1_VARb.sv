`timescale 1ns/10ps

module mux4_1_VARb #(parameter WIDTH=64) (out, in, sel);
		output logic      [WIDTH-1:0] out;
		input  logic [3:0][WIDTH-1:0] in;
		input  logic            [1:0] sel;
		
		logic [WIDTH-1:0][3:0] muxRearrange;
		
		genvar i, j;
		
		generate
			for(i=0; i< WIDTH; i++) begin : eachMux
				for(j=0; j<4; j++) begin : eachPin
					assign muxRearrange[i][j] = in[j][i];
				end
				mux4_1 m (.out(out[i]), .in(muxRearrange[i]), .sel);
			end
		endgenerate
		
endmodule


module mux4_1_VARb_testbench();
		parameter       WIDTH = 3;
		logic     [WIDTH-1:0] out;
		logic  [3:0][WIDTH-1:0]in;
		logic           [1:0] sel;
		
		mux4_1_VARb #(.WIDTH(WIDTH)) dut (.out, .in, .sel);
		
		initial begin

				sel=2'b00; in[0]=2'b000; in[1]=2'b001; in[2]=2'b000; in[3]=2'b001; #10;
				sel=2'b10; in[0]=2'b000; in[1]=2'b001; in[2]=2'b000; in[3]=2'b001; #10;
				sel=2'b01; in[0]=2'b000; in[1]=2'b001; in[2]=2'b000; in[3]=2'b001; #10;

		end
endmodule