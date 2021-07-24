`timescale 1ns/10ps

module oneBitALU (out, cout, a, b, cin, sel);
		output logic out, cout;
		input logic a, b, cin;
		input logic [2:0] sel;
		
		logic [7:0] op;
		
		parameter delay = 0.05;
				
		//Addition and subtraction go to same wire, but split in mux.
		assign op[3] = op[2];

		//Add subtract output sent to mux selection value 3'b010
		not #delay (nb, b);
		mux2_1 m2 (.out(bMux), .in({nb,b}), .sel(sel[0]));
		fullAdder fA (.sum(op[2]), .cout, .a, .b(bMux), .cin);

		assign op[0] = b;
		and #delay (op[4], a, b);
		or #delay (op[5], a, b);
		xor #delay (op[6], a, b);
		
		mux8_1 m8 (.out, .in(op), .sel);
		
endmodule

module oneBitALU_testbench ();
		parameter WIDTH = 3;
		
		logic out, cout, a, b, cin;
		logic [2:0] sel;
		
		oneBitALU dut (.out, .cout, .a, .b, .cin, .sel);
		
		integer i, j;
		
		initial begin
				a = 0; b = 0; cin = 1; sel = 3'b010; #10;
				a = 1; b = 0; cin = 1; sel = 3'b010; #10;
				a = 0; b = 1; cin = 1; sel = 3'b010; #10;
				a = 1; b = 1; cin = 0; sel = 3'b010; #10;
				a = 0; b = 0; cin = 1; sel = 3'b011; #10;
				a = 0; b = 0; cin = 1; sel = 3'b011; #10;
				a = 1; b = 0; cin = 1; sel = 3'b011; #10;
				a = 0; b = 1;          sel = 3'b100; #10;
				a = 0; b = 1; cin = 0; sel = 3'b100; #10;
				a = 1; b = 1;          sel = 3'b101; #10;
				a = 0; b = 1;          sel = 3'b101; #10;
				a = 0; b = 1;          sel = 3'b110; #10;
				a = 1; b = 1;          sel = 3'b110; #10;

		end
endmodule