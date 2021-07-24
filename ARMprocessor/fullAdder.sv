`timescale 1ns/10ps

module fullAdder(sum, cout, a, b, cin);
		output logic sum, cout;
		input logic a, b, cin;
		
		parameter delay = 0.05;
		
		//Compute sum
		xor #delay (sum, a, b, cin);
		
		//Compute cout
		logic ab, acin, bcin;
		and #delay (ab, a, b);
		and #delay (acin, a, cin);
		and #delay (bcin, b, cin);
		or #delay (cout, ab, acin, bcin);
endmodule

module fullAdder_testbench();
		logic sum, cout, a, b, cin;
		
		fullAdder dut (.sum, .cout, .a, .b, .cin);
		
		initial begin
				a = 0; b = 0; cin = 0; #10;
				a = 0; b = 1; cin = 0; #10;
				a = 1; b = 0; cin = 0; #10;
				a = 1; b = 1; cin = 0; #10;
				a = 0; b = 0; cin = 1; #10;
				a = 0; b = 1; cin = 1; #10;
				a = 1; b = 0; cin = 1; #10;
				a = 1; b = 1; cin = 1; #10;
		end
endmodule