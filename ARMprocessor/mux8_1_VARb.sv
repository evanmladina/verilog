`timescale 1ns/10ps

module mux8_1_VARb #(parameter WIDTH=64) (out, in, sel);
		output logic      [WIDTH-1:0] out;
		input  logic [7:0][WIDTH-1:0] in;
		input  logic            [2:0] sel;
		
		logic [WIDTH-1:0][7:0] muxRearrange;
		
		genvar i, j;
		
		generate
			for(i=0; i< WIDTH; i++) begin : eachMux
				for(j=0; j<8; j++) begin : eachPin
					assign muxRearrange[i][j] = in[j][i];
				end
				mux8_1 m (.out(out[i]), .in(muxRearrange[i]), .sel);
			end
		endgenerate
		
endmodule