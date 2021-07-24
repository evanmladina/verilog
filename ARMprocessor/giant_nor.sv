`timescale 1ns/10ps

module giant_nor #(parameter WIDTH = 64) (zero, result);
		output logic zero;
		input logic [WIDTH-1:0] result;
		
		logic [WIDTH/4 - 1:0] norOut;
		logic [WIDTH/8 - 1:0] norAnd;
		logic a1Out, a2Out;
		
		parameter delay = 0.05;
		
		genvar i;
		
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
		
endmodule
