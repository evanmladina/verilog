`timescale 1ns/10ps

module multiBitAdder #(parameter WIDTH = 64) (sum, a, b);
		output logic [WIDTH-1:0] sum;
		input logic [WIDTH-1:0] a, b;
		logic [WIDTH-1:0] cout, cin;
		
		fullAdder fA0 (.sum(sum[0]), .cout(cout[0]), .a(a[0]), .b(b[0]), .cin(0));
		
		genvar i;
		
		generate
			for(i=1; i< WIDTH; i++) begin : eachBit
				fullAdder fA (.sum(sum[i]), .cout(cout[i]), .a(a[i]), .b(b[i]), .cin(cout[i-1]));
			end
		endgenerate
endmodule

module multiBitAdder_testbench ();
		parameter WIDTH = 3;
		
		logic [WIDTH-1:0] sum, a, b;
		
		multiBitAdder #(.WIDTH(WIDTH)) dut (.sum, .a, .b);
		
		integer i, j;
		
		initial begin
				for (i=0; i<2**WIDTH; i++) begin
					for (j=0; j<2**WIDTH; j++) begin
						a[WIDTH-1:0] = i; b[WIDTH-1:0] = j;	#10;
					end
				end
				
				a = 5; b = -2; #10;
		end
endmodule