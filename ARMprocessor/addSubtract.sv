`timescale 1ns/10ps

module addSubtract #(parameter WIDTH = 64) (sum, a, b, addSub);
		output logic [WIDTH-1:0] sum;
		input logic [WIDTH-1:0] a, b;
		input logic addSub;
		logic [WIDTH-1:0] cout, cin, nb, bMux;
		
		parameter delay = 0.05;
		
		not #delay (nb[0], b[0]);
		mux2_1 m0 (.out(bMux[0]), .in({nb[0],b[0]}), .sel(addSub));
		fullAdder fA0 (.sum(sum[0]), .cout(cout[0]), .a(a[0]), .b(bMux[0]), .cin(addSub));
		
		genvar i;
		
		generate
			for(i=1; i< WIDTH; i++) begin : eachBit
				not #delay (nb[i], b[i]);
				mux2_1 m (.out(bMux[i]), .in({nb[i],b[i]}), .sel(addSub));
				fullAdder fA (.sum(sum[i]), .cout(cout[i]), .a(a[i]), .b(bMux[i]), .cin(cout[i-1]));
			end
		endgenerate
		
endmodule

module addSubtract_testbench ();
		parameter WIDTH = 3;
		
		logic [WIDTH-1:0] sum, a, b;
		logic finalCout, addSub;
		
		addSubtract #(.WIDTH(WIDTH)) dut (.sum, .a, .b, .addSub);
		
		integer i, j;
		
		initial begin
				for (i=0; i<2**WIDTH; i++) begin
					for (j=0; j<2**WIDTH; j++) begin
						a[WIDTH-1:0] = i; b[WIDTH-1:0] = j; addSub = 0;	#10;
					end
				end
				
				for (i=0; i<2**WIDTH; i++) begin
					for (j=0; j<2**WIDTH; j++) begin
						a[WIDTH-1:0] = i; b[WIDTH-1:0] = j; addSub = 1;	#10;
					end
				end
		end
endmodule