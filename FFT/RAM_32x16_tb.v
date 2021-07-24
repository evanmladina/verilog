module RAM_32x16_tb();
	logic clk, ena, enb;
	logic [15:0] dia, dib;
	logic [4:0] addra, addrb;
	logic [15:0] doa, dob;

	RAM_32x16 dut (.doa, .dob, .clk, .ena, .enb, .dia, .dib, .addra, .addrb);

	initial clk = 0;
	always #5 clk <= ~clk;

	initial begin
		$vcdpluson;
		$vcdplusmemon;
		addra <= 5'b00010; addrb <= 5'b10100; ena <= 1'b0; enb<= 1'b0; @(posedge clk);
		dia <= 16'h14f7; dib <= 16'h3a8b; @(posedge clk);
		ena <= 1'b1; @(posedge clk);
		enb <= 1'b1; @(posedge clk);
				@(posedge clk);
				@(posedge clk);
				@(posedge clk);
		$finish;
	end
endmodule
