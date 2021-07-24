module mult_complex(c_r, c_i, a_r, a_i, b_r, b_i, reset, clk);
	input logic signed [15:0] a_r, a_i, b_r, b_i;
	input logic reset, clk;
	output logic signed [15:0] c_r, c_i;

	logic signed [15:0] ar_br, ar_bi, ai_br, ai_bi;
	logic signed [15:0] ar_br_t, ar_bi_t, ai_br_t, ai_bi_t;

	mult arbr (.out(ar_br_t), .A(a_r), .B(b_r));
	mult arbi (.out(ar_bi_t), .A(a_r), .B(b_i));
	mult aibr (.out(ai_br_t), .A(a_i), .B(b_r));
	mult aibi (.out(ai_bi_t), .A(a_i), .B(b_i));

	//assign c_r = ar_br - ai_bi;
	//assign c_i = ar_bi + ai_br;

	always_ff @(posedge clk) begin
		c_r <= ar_br - ai_bi;
		c_i <= ar_bi + ai_br;
	end

	always_ff @(posedge clk) begin
		if (reset) begin
			ar_br <= 16'b0;
			ai_bi <= 16'b0;
			ar_bi <= 16'b0;
			ai_br <= 16'b0;
		end else begin
			ar_br <= ar_br_t;
			ai_bi <= ai_bi_t;
			ar_bi <= ar_bi_t;
			ai_br <= ai_br_t;
		end
	end
endmodule
