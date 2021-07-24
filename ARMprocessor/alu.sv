`timescale 1ns/10ps

module alu #(parameter WIDTH = 64) (result, negative, zero, overflow, carry_out, A, B, cntrl);
		output logic [WIDTH-1:0] result;
		output logic negative, zero, overflow, carry_out;
		input logic [WIDTH-1:0] A, B;
		input logic [2:0] cntrl;
		
		logic [WIDTH-1:0] cout;
		logic [WIDTH-1:0] cin;
		logic [WIDTH/4 - 1:0] norOut;
		logic [WIDTH/8 - 1:0] norAnd;
		logic a1Out, a2Out;

		
		assign cin[0] = cntrl[0];
		
		parameter delay = 0.05;
		
		oneBitALU ALU0 (.out(result[0]), .cout(cout[0]), .a(A[0]), .b(B[0]), .cin(cin[0]), .sel(cntrl));
		
		genvar i;
		
		generate
			for(i=1; i< WIDTH; i++) begin : eachBit
				assign cin[i] = cout[i-1];
				oneBitALU ALU (.out(result[i]), .cout(cout[i]), .a(A[i]), .b(B[i]), .cin(cout[i-1]), .sel(cntrl));
			end
		endgenerate
		
		//Giant nor gate for zero flag
		generate		
			for(i=0; i<WIDTH/8; i++) begin : eachNor
				nor #delay n1 (norOut[(2*i)], result[8*i], result[(8*i)+1], result[(8*i)+2], result[(8*i)+3]);
				nor #delay n2 (norOut[(2*i)+1], result[(8*i)+4], result[(8*i)+5], result[(8*i)+6], result[(8*i)+7]);
				and #delay a (norAnd[i], norOut[(2*i)], norOut[(2*i)+1]);
			end
		endgenerate
		
		and #delay a1 (a1Out, norAnd[0], norAnd[1], norAnd[2], norAnd[3]);
		and #delay a2 (a2Out, norAnd[4], norAnd[5], norAnd[6], norAnd[7]);
		and #delay (zero, a1Out, a2Out);
		
		assign negative = result[WIDTH-1];
		assign carry_out = cout[WIDTH-1];
		xor #delay (overflow, cout[WIDTH-1], cin[WIDTH-1]);
				
endmodule