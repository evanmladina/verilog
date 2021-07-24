module FFT_inv(data_real_in, data_imag_in, data_real_out, data_imag_out, clk, reset, all_fft_done);
	input logic clk, reset;
	input logic signed [15:0] data_real_in, data_imag_in;
	output logic signed [15:0] data_real_out, data_imag_out;
	output logic all_fft_done;

	logic signed [15:0] data_real_out_t, data_imag_out_t;

	logic signed [15:0] data_real_in_neg;
	assign data_real_in_neg = (~data_real_in) + 1'b1;

	FFT fftinv (.data_real_in(data_imag_in), .data_imag_in(data_real_in_neg),
		.data_real_out(data_imag_out_t), .data_imag_out(data_real_out_t),
		.clk(clk), .reset(reset), .all_fft_done(all_fft_done));

	assign data_real_out = {data_real_out_t[15], data_real_out_t[15], data_real_out_t[15], data_real_out_t[15],
        	data_real_out_t[15], data_real_out_t[15:5]};
  	assign data_imag_out = {data_imag_out_t[15], data_imag_out_t[15], data_imag_out_t[15], data_imag_out_t[15],
        	data_imag_out_t[15], data_imag_out_t[15:5]};

endmodule
