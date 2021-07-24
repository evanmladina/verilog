module addr_gen_tb();
	logic [2:0] i;
	logic [3:0] j;
	logic [4:0] ja, jb;
	logic [3:0] twaddr;

	addr_gen addrgen (.ja, .jb, .twaddr, .i, .j);

	integer a, b;
	initial begin
		$vcdpluson;
		for (a = 0; a < 5; a++) begin
			for (b = 0; b < 16; b++) begin
				i = a; j = b; #5;
			end
		end
		$finish;
	end
endmodule
