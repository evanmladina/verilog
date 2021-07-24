`timescale 1ns/10ps

module sign_extend #(parameter WIDTH_IN = 26, WIDTH_OUT=64) (out, in, sign);
		output logic [WIDTH_OUT-1:0] out;
		input logic [WIDTH_IN-1:0] in;
		input logic sign;
		
		logic muxOut;
		
		parameter delay = 0.05;
		
		//Get sign extension of top bit, or 0
		mux2_1 m (muxOut, {in[WIDTH_IN-1], 1'b0}, sign);
		
		integer i, j;
		
		always_comb begin
		
			//Copy lower bits
			for(i=0; i<WIDTH_IN; i++)
				out[i] = in[i];

			//Copy output of mux (either sign extend of last bit or 0) to remaining bits.
			for(j=WIDTH_IN; j<WIDTH_OUT; j++)
				out[j] = muxOut;

		end

endmodule


module sign_extend_testbench();
		parameter WIDTH_IN = 3;
		parameter WIDTH_OUT = 6;
		logic [WIDTH_OUT-1:0] out;
		logic [WIDTH_IN-1:0] in;
		logic sign;
		
		sign_extend #(.WIDTH_IN(WIDTH_IN), .WIDTH_OUT(WIDTH_OUT)) dut (.out, .in, .sign);
		
		initial begin
				in = 3'b110; sign = 1'b0; #10;
				in = 3'b010; sign = 1'b0; #10;
				in = 3'b110; sign = 1'b1; #10;
				in = 3'b100; sign = 1'b0; #10;
				in = 3'b010; sign = 1'b1; #10;
				
		end
endmodule