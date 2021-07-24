module top(data_o_r, data_o_i, res_ready, data_i_r, data_i_i, clk, reset);
	input logic clk, reset;
	input logic signed [15:0] data_i_r, data_i_i;
	output logic signed [15:0] data_o_r, data_o_i;
	output logic res_ready;

	logic fft_comp_done, filter_done;
	logic signed [15:0] data_o_fft_r, data_o_fft_i, filter_o_r, filter_o_i;

	FFT fftcomp (.data_real_in(data_i_r), .data_imag_in(data_i_i),
			.data_real_out(data_o_fft_r), .data_imag_out(data_o_fft_i),
			.clk(clk), .reset(reset), .all_fft_done(fft_comp_done));

	filter fil (.out_r(filter_o_r), .out_i(filter_o_i), .ready(filter_done),
			.fftout_r(data_o_fft_r), .fftout_i(data_o_fft_i), .reset(~fft_comp_done), .clk(clk));

	FFT_inv fftinvcomp (.data_real_in(filter_o_r), .data_imag_in(filter_o_i),
			.data_real_out(data_o_r), .data_imag_out(data_o_i),
			.clk(clk), .reset(~filter_done), .all_fft_done(res_ready));
endmodule
