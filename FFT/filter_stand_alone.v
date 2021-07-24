module filter_stand_alone(out_r, out_i, ready, fftout_r, fftout_i, reset, clk);
	input logic signed [15:0] fftout_r, fftout_i;
	input logic reset, clk;
	output logic signed [15:0] out_r, out_i;
	output logic ready;

	logic [4:0] counter;
	logic signed [15:0] romr, romi, a_r_c, a_i_c;
	logic signed [15:0] fftout_r_1, fftout_i_1;
	logic signed [15:0] fftout_r_2, fftout_i_2;
	logic ready_1, ready_2;

	hex_rom_r_32 hexromr (.dout(romr), .addr(counter), .en(1'b1), .clk(clk));
	hex_rom_i_32 hexromi (.dout(romi), .addr(counter), .en(1'b1), .clk(clk));

	mult_complex mult2 (.c_r(out_r), .c_i(out_i), .a_r(fftout_r_2), .a_i(fftout_i_2),
		.b_r(romr), .b_i(romi), .reset(reset), .clk(clk));

	always_ff @(posedge clk) begin
		fftout_r_1 <= fftout_r;
		fftout_i_1 <= fftout_i;
		fftout_r_2 <= fftout_r_1;
		fftout_i_2 <= fftout_i_1;
	end

	always_ff @(posedge clk) begin
		if (reset) begin
			ready <= 1'b0;
			ready_1 <= 1'b0;
			ready_2 <= 1'b0;
		end else begin
			ready_2 <= 1'b1;
			ready_1 <= ready_2;
			ready <= ready_1;
		end

		if (reset) begin
			counter <= 5'b00000;
		end else begin
			if (counter == 5'b11111) begin
				counter <= counter;
			end else begin
				counter <= counter + 1'b1;
			end
		end
	end
endmodule
