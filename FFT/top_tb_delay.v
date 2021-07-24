module top_tb_delay();
	logic clk, reset;
	logic signed [15:0] data_i_r, data_i_i;
	logic signed [15:0] data_o_r, data_o_i;
	logic res_ready;

	logic [1:0] counter;
	int fr;
	int fi;

	top dut (.*);

	localparam delay = 0.02;
	
	initial clk = 0;
	always #0.01 clk <= ~clk;

	always @(posedge res_ready) begin
		counter = 2'b00;
		repeat(32) begin
			@(posedge clk);
			$fwrite(fr, "\"%h\", ", data_o_r); 
			$fwrite(fi, "\"%h\", ", data_o_i); 
			counter <= counter + 2'b01;
			if(counter == 2'b11) begin
				$fwrite(fr, "\n"); 
				$fwrite(fi, "\n"); 
				counter = 2'b00;
			end
		end
	end

	initial begin
		fr = $fopen("top_r.txt", "w");
		fi = $fopen("top_i.txt", "w");
		$vcdpluson;
		$vcdplusmemon;
		reset <= 1'b1;#(delay);
		#(delay);
		#(delay);
		reset <= 1'b0;
		data_i_r = 16'h007f; data_i_i = 16'h0000; #(delay);
		data_i_r = 16'h007f; data_i_i = 16'h0000; #(delay);
		data_i_r = 16'h007f; data_i_i = 16'h0000; #(delay);
		data_i_r = 16'h007f; data_i_i = 16'h0000; #(delay);
		data_i_r = 16'h007f; data_i_i = 16'h0000; #(delay);
		data_i_r = 16'h007f; data_i_i = 16'h0000; #(delay);
		data_i_r = 16'h007f; data_i_i = 16'h0000; #(delay);
		data_i_r = 16'h007f; data_i_i = 16'h0000; #(delay);
		data_i_r = 16'hff81; data_i_i = 16'h0000; #(delay);
		data_i_r = 16'hff81; data_i_i = 16'h0000; #(delay);
		data_i_r = 16'hff81; data_i_i = 16'h0000; #(delay);
		data_i_r = 16'hff81; data_i_i = 16'h0000; #(delay);
		data_i_r = 16'hff81; data_i_i = 16'h0000; #(delay);
		data_i_r = 16'hff81; data_i_i = 16'h0000; #(delay);
		data_i_r = 16'hff81; data_i_i = 16'h0000; #(delay);
		data_i_r = 16'hff81; data_i_i = 16'h0000; #(delay);
		data_i_r = 16'h007f; data_i_i = 16'h0000; #(delay);
		data_i_r = 16'h007f; data_i_i = 16'h0000; #(delay);
		data_i_r = 16'h007f; data_i_i = 16'h0000; #(delay);
		data_i_r = 16'h007f; data_i_i = 16'h0000; #(delay);
		data_i_r = 16'h007f; data_i_i = 16'h0000; #(delay);
		data_i_r = 16'h007f; data_i_i = 16'h0000; #(delay);
		data_i_r = 16'h007f; data_i_i = 16'h0000; #(delay);
		data_i_r = 16'h007f; data_i_i = 16'h0000; #(delay);
		data_i_r = 16'hff81; data_i_i = 16'h0000; #(delay);
		data_i_r = 16'hff81; data_i_i = 16'h0000; #(delay);
		data_i_r = 16'hff81; data_i_i = 16'h0000; #(delay);
		data_i_r = 16'hff81; data_i_i = 16'h0000; #(delay);
		data_i_r = 16'hff81; data_i_i = 16'h0000; #(delay);
		data_i_r = 16'hff81; data_i_i = 16'h0000; #(delay);
		data_i_r = 16'hff81; data_i_i = 16'h0000; #(delay);
		data_i_r = 16'hff81; data_i_i = 16'h0000; #(delay);
		repeat(500) #(delay);
		$fclose(fr);
		$fclose(fi);
		$finish;
	end
endmodule
