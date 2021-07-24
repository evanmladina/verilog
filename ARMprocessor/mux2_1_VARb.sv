`timescale 1ns/10ps

module mux2_1_VARb #(parameter WIDTH=64) (out, in, sel);
		output logic     [WIDTH-1:0] out;
		input  logic [1:0][WIDTH-1:0] in;
		input  logic                 sel;
		
		logic [WIDTH-1:0][1:0] muxRearrange;
		
		genvar i, j;
		
		generate
			for(i=0; i< WIDTH; i++) begin : eachMux
				for(j=0; j<2; j++) begin : eachPin
					assign muxRearrange[i][j] = in[j][i];
				end
				mux2_1 m (.out(out[i]), .in(muxRearrange[i]), .sel);
			end
		endgenerate
		
endmodule

module mux2_1_VARb_testbench();
		parameter       WIDTH = 3;
		logic     [WIDTH-1:0] out;
		logic  [1:0][WIDTH-1:0]in;
		logic                 sel;
		
		mux2_1_VARb #(.WIDTH(WIDTH)) dut (.out, .in, .sel);
		
		initial begin
				sel=0; in={2'b000, 2'b001}; #10;
				sel=0; in[0]=2'b000; in[1]=2'b001; #10;
				sel=0; in[0]=2'b000; in[1]=2'b001; #10;
				sel=0; in[0]=2'b011; in[1]=2'b100; #10;
				sel=0; in[0]=2'b101; in[1]=2'b010; #10;
				sel=0; in[0]=2'b110; in[1]=2'b110; #10;
				sel=1; in[0]=2'b010; in[1]=2'b011; #10;
				sel=1; in[0]=2'b101; in[1]=2'b111; #10;
				sel=1; in[0]=2'b001; in[1]=2'b010; #10;
				sel=1; in[0]=2'b010; in[1]=2'b101; #10;
		end
endmodule