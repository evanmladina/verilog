// Author: Alex Nagy
// Butterfly Unit: Algorithm to compute FFT value at given address.

module BFU(x_real, y_real, x_imag, y_imag, g_real, g_imag, h_real, h_imag, Tw_real, Tw_imag, clk, reset);
    output logic signed [15:0] x_real, y_real, x_imag, y_imag;
    input  logic signed [15:0] g_real, g_imag, h_real, h_imag;
    input  logic signed [15:0] Tw_real, Tw_imag;
    input logic clk, reset;

    logic signed [15:0] temp_r, temp_i;           //temp variable for algorthim.
	logic signed [15:0] temp_r1, temp_r2, temp_i1, temp_i2;
	logic signed [15:0] temp_r1_c, temp_r2_c, temp_i1_c, temp_i2_c, g_real_c, g_imag_c;

	mult tempr1 (.out(temp_r1), .A(h_real), .B(Tw_real));
	mult tempr2 (.out(temp_r2), .A(h_imag), .B(Tw_imag));
	mult tempi1 (.out(temp_i1), .A(h_real), .B(Tw_imag));
	mult tempi2 (.out(temp_i2), .A(h_imag), .B(Tw_real));

    always_comb begin
/*
        temp_r = ((h_real * Tw_real) / 32768)  //h_real or g_real?
            - ((h_imag * Tw_imag) / 32768);  
        temp_i = ((h_real * Tw_imag) / 32768)
            - ((h_imag & Tw_real) / 32768);
*/
	temp_r = temp_r1_c - temp_r2_c;
	temp_i = temp_i1_c + temp_i2_c;

        y_real = g_real_c - temp_r;
        y_imag = g_imag_c - temp_i;
        x_real = g_real_c + temp_r;
        x_imag = g_imag_c + temp_i;

    end

	always_ff @(posedge clk) begin
		if (reset) begin
			temp_r1_c <= 16'b0;
			temp_r2_c <= 16'b0;
			temp_i1_c <= 16'b0;
			temp_i2_c <= 16'b0;

			g_real_c <= 16'b0;
			g_imag_c <= 16'b0;
		end else begin
			temp_r1_c <= temp_r1;
			temp_r2_c <= temp_r2;
			temp_i1_c <= temp_i1;
			temp_i2_c <= temp_i2;

			g_real_c <= g_real;
			g_imag_c <= g_imag;
		end
	end

endmodule
