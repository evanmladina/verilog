module FFT_inv_tb();
	logic clk, reset;
	logic signed [15:0] data_real_in, data_imag_in;
	logic signed [15:0] data_real_out, data_imag_out;
	logic all_fft_done;

	int fr;
	int fi;
	logic [1:0] counter;


	FFT_inv dut (.*);

	initial clk = 0;
	always #0.01 clk <= ~clk;

	always @(posedge all_fft_done) begin
		counter = 2'b00;
		repeat(32) begin
			@(posedge clk);
			$fwrite(fr, "\"%h\", ", data_real_out); 
			$fwrite(fi, "\"%h\", ", data_imag_out); 
			counter <= counter + 2'b01;
			if(counter == 2'b11) begin
				$fwrite(fr, "\n"); 
				$fwrite(fi, "\n"); 
				counter = 2'b00;
			end
		end
	end

	initial begin
		fr = $fopen("ifft_r.txt", "w");
		fi = $fopen("ifft_i.txt", "w");
		$vcdpluson;
		$vcdplusmemon;
		reset <= 1'b1;@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		reset <= 1'b0;
		data_real_in = 16'hfff8; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'h0000; data_imag_in = 16'hffff; @(posedge clk);
		data_real_in = 16'h07e9; data_imag_in = 16'hae7d; @(posedge clk);
		data_real_in = 16'h0000; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'h0000; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'h0000; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'h0801; data_imag_in = 16'he45f; @(posedge clk);
		data_real_in = 16'h0000; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'h0000; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'h0000; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'h0831; data_imag_in = 16'hee9d; @(posedge clk);
		data_real_in = 16'h0000; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'h0000; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'h0000; data_imag_in = 16'hffff; @(posedge clk);
		data_real_in = 16'h0867; data_imag_in = 16'hf20a; @(posedge clk);
		data_real_in = 16'h0000; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'h0000; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'h0000; data_imag_in = 16'hffff; @(posedge clk);
		data_real_in = 16'h0835; data_imag_in = 16'hf1ed; @(posedge clk);
		data_real_in = 16'h0000; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'h0000; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'h0000; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'h04ad; data_imag_in = 16'hed5b; @(posedge clk);
		data_real_in = 16'h0000; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'h0000; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'hfffe; data_imag_in = 16'hffff; @(posedge clk);
		data_real_in = 16'he96c; data_imag_in = 16'hee2f; @(posedge clk);
		data_real_in = 16'h0000; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'h0000; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'hffff; data_imag_in = 16'hfffd; @(posedge clk);
		data_real_in = 16'hff78; data_imag_in = 16'h0077; @(posedge clk);
		data_real_in = 16'h0000; data_imag_in = 16'h0000; @(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		repeat(500) @(posedge clk);
		@(posedge clk);
		$fclose(fr);
		$fclose(fi);
		$finish;
	end
endmodule
