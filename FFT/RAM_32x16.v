module RAM_32x16(doa, dob, clk, ena, enb, dia, dib, addra, addrb);
	input logic clk, ena, enb;
	input logic [15:0] dia, dib;
	input logic [4:0] addra, addrb;
	output logic [15:0] doa, dob;

	logic [15:0] mem [0:31];

	assign doa = mem[addra];
	assign dob = mem[addrb];

	always_ff @(posedge clk) begin
		if (ena) begin
			mem[addra] <= dia;
		end

		if (enb) begin
			mem[addrb] <= dib;
		end
	end
endmodule
