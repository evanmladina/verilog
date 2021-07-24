module filter_tb();
	logic signed [15:0] fftout_r, fftout_i;
	logic reset, clk;
	logic signed [15:0] out_r, out_i;
	logic ready;

	filter_stand_alone dut (.*);

	int fr_fil;
	int fi_fil;

	initial clk = 0;
	always #0.1 clk <= ~clk;


	initial begin
		fr_fil = $fopen("filter_r.txt", "w");
		fi_fil = $fopen("filter_i.txt", "w");
		$vcdpluson;
		reset <= 1'b1; @(posedge clk);
		@(posedge clk);
		@(posedge clk);
		reset <= 1'b0;
		fftout_r = 16'hfff8; fftout_i = 16'h0000; @(posedge clk);
		fftout_r = 16'h0001; fftout_i = 16'h0000; @(posedge clk);
		fftout_r = 16'h01fe; fftout_i = 16'hf611; @(posedge clk);
		fftout_r = 16'h0000; fftout_i = 16'h0000; @(posedge clk);
		$fwrite(fr_fil, "\"%h\", ", out_r); $fwrite(fi_fil, "\"%h\", ", out_i);
		fftout_r = 16'h0000; fftout_i = 16'h0000; @(posedge clk);
		$fwrite(fr_fil, "\"%h\", ", out_r); $fwrite(fi_fil, "\"%h\", ", out_i);
		fftout_r = 16'h0000; fftout_i = 16'h0000; @(posedge clk);
		$fwrite(fr_fil, "\"%h\", ", out_r); $fwrite(fi_fil, "\"%h\", ", out_i);
		fftout_r = 16'h01fa; fftout_i = 16'hfd0d; @(posedge clk);
		$fwrite(fr_fil, "\"%h\",\n", out_r); $fwrite(fi_fil, "\"%h\",\n", out_i);
		fftout_r = 16'h0000; fftout_i = 16'h0000; @(posedge clk);
		$fwrite(fr_fil, "\"%h\", ", out_r); $fwrite(fi_fil, "\"%h\", ", out_i);
		fftout_r = 16'h0000; fftout_i = 16'h0000; @(posedge clk);
		$fwrite(fr_fil, "\"%h\", ", out_r); $fwrite(fi_fil, "\"%h\", ", out_i);
		fftout_r = 16'h0000; fftout_i = 16'h0000; @(posedge clk);
		$fwrite(fr_fil, "\"%h\", ", out_r); $fwrite(fi_fil, "\"%h\", ", out_i);
		fftout_r = 16'h01fa; fftout_i = 16'hfeaf; @(posedge clk);
		$fwrite(fr_fil, "\"%h\",\n", out_r); $fwrite(fi_fil, "\"%h\",\n", out_i);
		fftout_r = 16'h0000; fftout_i = 16'h0000; @(posedge clk)
		$fwrite(fr_fil, "\"%h\", ", out_r); $fwrite(fi_fil, "\"%h\", ", out_i);
		fftout_r = 16'h0000; fftout_i = 16'h0000; @(posedge clk);
		$fwrite(fr_fil, "\"%h\", ", out_r); $fwrite(fi_fil, "\"%h\", ", out_i);
		fftout_r = 16'h0000; fftout_i = 16'hffff; @(posedge clk);
		$fwrite(fr_fil, "\"%h\", ", out_r); $fwrite(fi_fil, "\"%h\", ", out_i);
		fftout_r = 16'h01fa; fftout_i = 16'hff9b; @(posedge clk);
		$fwrite(fr_fil, "\"%h\",\n", out_r); $fwrite(fi_fil, "\"%h\",\n", out_i);
		fftout_r = 16'h0000; fftout_i = 16'h0000; @(posedge clk);
		$fwrite(fr_fil, "\"%h\", ", out_r); $fwrite(fi_fil, "\"%h\", ", out_i);
		fftout_r = 16'h0000; fftout_i = 16'h0000; @(posedge clk);
		$fwrite(fr_fil, "\"%h\", ", out_r); $fwrite(fi_fil, "\"%h\", ", out_i);
		fftout_r = 16'h0001; fftout_i = 16'h0000; @(posedge clk);
		$fwrite(fr_fil, "\"%h\", ", out_r); $fwrite(fi_fil, "\"%h\", ", out_i);
		fftout_r = 16'h01fa; fftout_i = 16'h0065; @(posedge clk);
		$fwrite(fr_fil, "\"%h\",\n", out_r); $fwrite(fi_fil, "\"%h\",\n", out_i);
		fftout_r = 16'h0000; fftout_i = 16'h0000; @(posedge clk);
		$fwrite(fr_fil, "\"%h\", ", out_r); $fwrite(fi_fil, "\"%h\", ", out_i);
		fftout_r = 16'h0000; fftout_i = 16'h0000; @(posedge clk);
		$fwrite(fr_fil, "\"%h\", ", out_r); $fwrite(fi_fil, "\"%h\", ", out_i);
		fftout_r = 16'h0000; fftout_i = 16'h0000; @(posedge clk);
		$fwrite(fr_fil, "\"%h\", ", out_r); $fwrite(fi_fil, "\"%h\", ", out_i);
		fftout_r = 16'h01fa; fftout_i = 16'h0151; @(posedge clk);
		$fwrite(fr_fil, "\"%h\",\n", out_r); $fwrite(fi_fil, "\"%h\",\n", out_i);
		fftout_r = 16'h0000; fftout_i = 16'h0000; @(posedge clk);
		$fwrite(fr_fil, "\"%h\", ", out_r); $fwrite(fi_fil, "\"%h\", ", out_i);
		fftout_r = 16'h0000; fftout_i = 16'h0000; @(posedge clk);
		$fwrite(fr_fil, "\"%h\", ", out_r); $fwrite(fi_fil, "\"%h\", ", out_i);
		fftout_r = 16'h0002; fftout_i = 16'h0000; @(posedge clk);
		$fwrite(fr_fil, "\"%h\", ", out_r); $fwrite(fi_fil, "\"%h\", ", out_i);
		fftout_r = 16'h01fa; fftout_i = 16'h02f3; @(posedge clk);
		$fwrite(fr_fil, "\"%h\",\n", out_r); $fwrite(fi_fil, "\"%h\",\n", out_i);
		fftout_r = 16'h0000; fftout_i = 16'h0000; @(posedge clk);
		$fwrite(fr_fil, "\"%h\", ", out_r); $fwrite(fi_fil, "\"%h\", ", out_i);
		fftout_r = 16'h0000; fftout_i = 16'h0000; @(posedge clk);
		$fwrite(fr_fil, "\"%h\", ", out_r); $fwrite(fi_fil, "\"%h\", ", out_i);
		fftout_r = 16'h0004; fftout_i = 16'h0001; @(posedge clk);
		$fwrite(fr_fil, "\"%h\", ", out_r); $fwrite(fi_fil, "\"%h\", ", out_i);
		fftout_r = 16'h01fe; fftout_i = 16'h09ef; @(posedge clk);
		$fwrite(fr_fil, "\"%h\",\n", out_r); $fwrite(fi_fil, "\"%h\",\n", out_i);
		fftout_r = 16'h0008; fftout_i = 16'h0000; @(posedge clk);
		$fwrite(fr_fil, "\"%h\", ", out_r); $fwrite(fi_fil, "\"%h\", ", out_i);
		@(posedge clk);
		$fwrite(fr_fil, "\"%h\", ", out_r); $fwrite(fi_fil, "\"%h\", ", out_i);
		@(posedge clk);
		$fwrite(fr_fil, "\"%h\", ", out_r); $fwrite(fi_fil, "\"%h\", ", out_i);
		@(posedge clk);
		$fwrite(fr_fil, "\"%h\"", out_r); $fwrite(fi_fil, "\"%h\"", out_i);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		$fclose(fr_fil);
		$fclose(fi_fil);
		$finish;
	end
endmodule

