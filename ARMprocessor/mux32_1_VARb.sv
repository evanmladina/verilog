`timescale 1ns/10ps

module mux32_1_VARb #(parameter WIDTH=64) (out, in, sel);
		output logic      [WIDTH-1:0] out;
		input  logic [WIDTH-1:0][31:0] in;
		input  logic            [4:0] sel;
		
		genvar i;
		
		generate
			for(i=0; i< WIDTH; i++) begin : eachMux
				mux32_1 m (.out(out[i]), .in(in[i][31:0]), .sel);
			end
		endgenerate
		
endmodule

module mux32_1_VARb_testbench();
		parameter        WIDTH = 3;
		logic      [WIDTH-1:0] out;
		logic [WIDTH-1:0][31:0] in;
		logic            [4:0] sel;
		
		mux32_1_VARb #(.WIDTH(WIDTH)) dut (.out, .in, .sel);
		
		initial begin
				sel=0; in[0]=32'b00; in[1]=32'b00; in[2]=32'b10; #10;
				sel=0; in[0]=32'b00; in[1]=32'b00; in[2]=32'b10; #10;
				sel=0; in[0]=32'b01; in[1]=32'b10; in[2]=32'b10; #10;
				sel=0; in[0]=32'b10; in[1]=32'b01; in[2]=32'b10; #10;
				sel=0; in[0]=32'b11; in[1]=32'b11; in[2]=32'b10; #10;
				sel=1; in[0]=32'b01; in[1]=32'b01; in[2]=32'b10; #10;
				sel=1; in[0]=32'b10; in[1]=32'b11; in[2]=32'b10; #10;
				sel=1; in[0]=32'b00; in[1]=32'b01; in[2]=32'b10; #10;
				sel=1; in[0]=32'b01; in[1]=32'b10; in[2]=32'b10; #10;
		end
endmodule