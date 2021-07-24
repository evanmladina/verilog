module FFT_tb();
	logic clk, reset;
	logic signed [15:0] data_real_in, data_imag_in;
	logic signed [15:0] data_real_out, data_imag_out;
	logic all_fft_done;

	int fr;
	int fi;
	logic [1:0] counter;

	FFT dut (.*);

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
		fr = $fopen("fft_r.txt", "w");
		fi = $fopen("fft_i.txt", "w");
		$vcdpluson;
		$vcdplusmemon;
		reset <= 1'b1;@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		reset <= 1'b0;
		data_real_in = 16'h007f; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'h007f; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'h007f; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'h007f; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'h007f; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'h007f; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'h007f; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'h007f; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'h007f; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'h007f; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'h007f; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'h007f; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'h007f; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'h007f; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'h007f; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'h007f; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'hff81; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'hff81; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'hff81; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'hff81; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'hff81; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'hff81; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'hff81; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'hff81; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'hff81; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'hff81; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'hff81; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'hff81; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'hff81; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'hff81; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'hff81; data_imag_in = 16'h0000; @(posedge clk);
		data_real_in = 16'hff81; data_imag_in = 16'h0000; @(posedge clk);

/*
		data_real_in <= 32'h03ff03ff; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'h03ff03ff; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'h03ff03ff; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'hfc01fc01; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'hfc01fc01; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'hfc01fc01; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'hfc01fc01; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'h03ff03ff; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'h03ff03ff; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'h03ff03ff; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'h03ff03ff; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'hfc01fc01; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'hfc01fc01; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'hfc01fc01; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'hfc01fc01; data_imag_in <= 32'h00000000; @(posedge clk);
*/
/*
		data_real_in <= 32'h03ff03ff; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'h03ff03ff; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'h03ff03ff; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'h03ff03ff; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'h03ff03ff; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'h03ff03ff; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'h03ff03ff; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'h03ff03ff; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'hfc01fc01; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'hfc01fc01; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'hfc01fc01; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'hfc01fc01; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'hfc01fc01; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'hfc01fc01; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'hfc01fc01; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'hfc01fc01; data_imag_in <= 32'h00000000; @(posedge clk);
*/
/*
		data_real_in <= 32'h7fff7fff; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'h7fff7fff; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'h7fff7fff; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'h7fff7fff; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'h80018001; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'h80018001; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'h80018001; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'h80018001; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'h7fff7fff; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'h7fff7fff; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'h7fff7fff; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'h7fff7fff; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'h80018001; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'h80018001; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'h80018001; data_imag_in <= 32'h00000000; @(posedge clk);
		data_real_in <= 32'h80018001; data_imag_in <= 32'h00000000; @(posedge clk);
*/
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
