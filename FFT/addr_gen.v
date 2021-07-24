module addr_gen(ja, jb, twaddr, i, j);
	input logic [2:0] i;
	input logic [3:0] j;
	output logic [4:0] ja, jb;
	output logic [3:0] twaddr;

	logic [4:0] ja_temp, jb_temp;
	
	assign ja_temp = j << 1;
	assign jb_temp = ja_temp + 1;

	assign ja = ((ja_temp << i) | (ja_temp >> (5 - i))) & 8'h1F;
	assign jb = ((jb_temp << i) | (jb_temp >> (5 - i))) & 8'h1F;

	assign twaddr = (((32'hFFFFFFF0 >> i) & 4'hF) & j);
endmodule
