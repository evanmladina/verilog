module AGU_tb();
	logic clk, reset;
	logic [5:0] addrA, addrB;
	logic en_ram1, en_ram2, done, read_sel;
	logic [3:0] twaddr;

	AGU dut (.addrA, .addrB, .en_ram1, .en_ram2, .done, .read_sel, .twaddr, .clk, .reset);

	initial clk = 0;
	always #5 clk <= ~clk;

	initial begin
		$vcdpluson;
		reset <= 1'b1; 	@(posedge clk);
				@(posedge clk);
				@(posedge clk);
		reset <= 1'b0; 	@(posedge clk);
		    repeat(400) @(posedge clk);
		reset <= 1'b1; 	@(posedge clk);
				@(posedge clk);
				@(posedge clk);
		reset <= 1'b0; 	@(posedge clk);
		    repeat(400) @(posedge clk);
				@(posedge clk);
		$finish;
	end
endmodule
