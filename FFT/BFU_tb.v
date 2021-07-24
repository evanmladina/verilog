module BFU_tb();
	logic signed [15:0] x_real, y_real, x_imag, y_imag;
	logic signed [15:0] g_real, g_imag, h_real, h_imag;
	logic signed [15:0] Tw_real, Tw_imag;
	logic clk, reset;

	BFU dut (.*);

	initial clk = 0;
	always #5 clk <= ~clk;

	initial begin
		$vcdpluson;
		reset <= 1'b1; @(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		g_real <= 16'h27c8; g_imag <= 16'h0000; h_real <= 16'h3ba6; h_imag <= 16'h0000;
			Tw_real <= 16'h7fff; Tw_imag <= 16'h7fff; @(posedge clk);
		reset <= 1'b0; @(posedge clk);
		g_real <= 16'h0000; g_imag <= 16'h198f; h_real <= 16'h0000; h_imag <= 16'h2d86;
			Tw_real <= 16'h7fff; Tw_imag <= 16'h7fff; @(posedge clk);
		g_real <= 16'h17c8; g_imag <= 16'h198f; h_real <= 16'h3ba6; h_imag <= 16'h2d86;
			Tw_real <= 16'h7fff; Tw_imag <= 16'h7fff; @(posedge clk);
		g_real <= 16'h17c8; g_imag <= 16'h198f; h_real <= 16'h3ba6; h_imag <= 16'h2d86;
			Tw_real <= 16'h1726; Tw_imag <= 16'h2c81; @(posedge clk);
		g_real <= 16'h17c8; g_imag <= 16'h198f; h_real <= 16'heba6; h_imag <= 16'h2d86;
			Tw_real <= 16'h1726; Tw_imag <= 16'hac81; @(posedge clk);
		g_real <= 16'h17c8; g_imag <= 16'h198f; h_real <= 16'heba6; h_imag <= 16'h2d86;
			Tw_real <= 16'hf726; Tw_imag <= 16'hac81; @(posedge clk);
		@(posedge clk);
		@(posedge clk);
		$finish;
	end
endmodule
