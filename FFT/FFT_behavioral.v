module FFT(data_real_in, data_imag_in, data_real_out, data_imag_out, clk, reset, all_fft_done);
	input logic clk, reset;
	input logic signed [15:0] data_real_in, data_imag_in;
	output logic signed [15:0] data_real_out, data_imag_out;
	output logic all_fft_done;

	//enum {LOAD, TRAN, OUT} ps, ns;

	localparam LOAD = 2'b00;
	localparam TRAN = 2'b01;
	localparam OUT = 2'b10;

	logic [1:0] ps, ns;

	// to assign: reset_AGU
	// to connect: read_sel, twaddr
	logic [4:0] addr1, addr2, addr1_connection, addr2_connection, addr1_c2, addr2_c2;
	logic fft_done, reset_AGU, enm1, enm2, read_sel, enm1_connection, enm1_conn1;
	logic [3:0] twaddr;
	logic [4:0] load_counter, out_counter;
	logic signed [15:0] tw_real, tw_imag; //connect
	logic signed [19:0] g_real, g_imag, h_real, h_imag;
	logic signed [15:0] x_real, x_imag, y_real, y_imag;
	logic signed [15:0] dia_1r, dia_1i, dib_1r, dib_1i;
	logic signed [19:0] doa_1r, doa_1i, dob_1r, dob_1i;
	logic signed [19:0] doa_2r, doa_2i, dob_2r, dob_2i;

	always_comb begin
		case (ps)
			LOAD:	begin
					if (load_counter == 5'b11111) begin
						ns = TRAN;
					end else begin
						ns = LOAD;
					end
				end
			TRAN:	begin
					if (fft_done) begin
						ns = OUT;
					end else begin
						ns = TRAN;
					end
				end
			OUT:	begin
					ns = OUT;
				end
		endcase
	end

	always_ff @(posedge clk) begin
		if (reset) begin
			ps <= LOAD;
			reset_AGU <= 1'b1;
			load_counter <= 5'b00000;
			out_counter <= 5'b00000;
			all_fft_done <= 1'b0;
		end else begin
			ps <= ns;
			if ((ps == LOAD) & (ns == LOAD)) begin
				reset_AGU <= 1'b1;
				load_counter <= load_counter + 1'b1;
				out_counter <= 5'b00000;
				all_fft_done <= 1'b0;
			end else if ((ps == LOAD) & (ns == TRAN)) begin
				reset_AGU <= 1'b0;
				load_counter <= 5'b00000;
				out_counter <= 5'b00000;
				all_fft_done <= 1'b0;
			end else if ((ps == TRAN) & (ns == TRAN)) begin
				reset_AGU <= 1'b0;
				load_counter <= 5'b00000;
				out_counter <= 5'b00000;
				all_fft_done <= 1'b0;
			end else if ((ps == TRAN) & (ns == OUT)) begin
				reset_AGU <= 1'b0;
				load_counter <= 5'b00000;
				out_counter <= 5'b00000;
				all_fft_done <= 1'b1;
			end else if ((ps == OUT) & (ns == OUT)) begin
				reset_AGU <= 1'b0;
				load_counter <= 5'b00000;
				if (out_counter == 5'b11111) begin
					out_counter <= out_counter;
				end else begin
					out_counter <= out_counter + 1'b1;
				end
				all_fft_done <= 1'b1;
			end
		end
	end

	always_comb begin
		if (reset) begin
			enm1_connection = 1'b0;
			enm1_conn1 = 1'b0;
			addr1_connection = 5'b0;
			addr2_connection = 5'b0;

			dia_1r = 16'b0;
			dia_1i = 16'b0;
			dib_1r = 16'b0;
			dib_1i = 16'b0;
		end else if (ps == LOAD) begin
			enm1_connection = 1'b1;
			enm1_conn1 = 1'b0;
			addr1_connection = {load_counter[0], load_counter[1], load_counter[2],
						load_counter[3], load_counter[4]};
			addr2_connection = 5'b0;

			dia_1r = data_real_in[15:0];
			dia_1i = data_imag_in[15:0];
			dib_1r = 16'b0; //data_real_in[15:0];
			dib_1i = 16'b0; //data_imag_in[15:0];
		end else begin
			enm1_connection = enm1;
			enm1_conn1 = enm1;
			addr1_connection = addr1;
			addr2_connection = addr2;

			dia_1r = x_real;
			dia_1i = x_imag;
			dib_1r = y_real;
			dib_1i = y_imag;
		end

		if (ps == OUT) begin
			addr1_c2 = out_counter[4:0];
			addr2_c2 = 5'b00000;
		end else begin
			addr1_c2 = addr1;
			addr2_c2 = addr2;
		end

		if (read_sel) begin
			g_real = doa_2r;
			g_imag = doa_2i;
			h_real = dob_2r;
			h_imag = dob_2i;
		end else begin
			g_real = doa_1r;
			g_imag = doa_1i;
			h_real = dob_1r;
			h_imag = dob_1i;
		end
	end

	RAM_32x16 ram1real (.doa(doa_1r), .dob(dob_1r), .clk(clk), .ena(enm1_connection), .enb(enm1_conn1),
				.dia(dia_1r), .dib(dib_1r), .addra(addr1_connection), .addrb(addr2_connection));
	RAM_32x16 ram1imag (.doa(doa_1i), .dob(dob_1i), .clk(clk), .ena(enm1_connection), .enb(enm1_conn1),
				.dia(dia_1i), .dib(dib_1i), .addra(addr1_connection), .addrb(addr2_connection));
	RAM_32x16 ram2real (.doa(doa_2r), .dob(dob_2r), .clk(clk), .ena(enm2), .enb(enm2),
				.dia(x_real), .dib(y_real), .addra(addr1_c2), .addrb(addr2_c2));
	RAM_32x16 ram2imag (.doa(doa_2i), .dob(dob_2i), .clk(clk), .ena(enm2), .enb(enm2),
				.dia(x_imag), .dib(y_imag), .addra(addr1_c2), .addrb(addr2_c2));

	AGU addrgen (.addrA(addr1), .addrB(addr2), .en_ram1(enm1), .en_ram2(enm2), .done(fft_done),
			.read_sel(read_sel), .twaddr(twaddr), .clk(clk), .reset(reset_AGU));

	Twiddle_Factor_ROM rwiddlerom (.clk(clk), .Tw_real(tw_real), .Tw_imag(tw_imag), .Tw_addr(twaddr));

	BFU butfly (.x_real(x_real), .y_real(y_real), .x_imag(x_imag), .y_imag(y_imag),
		.g_real(g_real[15:0]), .g_imag(g_imag[15:0]), .h_real(h_real[15:0]), .h_imag(h_imag[15:0]),
		.Tw_real(tw_real), .Tw_imag(tw_imag), .clk(clk), .reset(1'b0));

	assign data_real_out = doa_2r[15:0];
	assign data_imag_out = (~doa_2i[15:0]) + 1'b1;
endmodule
