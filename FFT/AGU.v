module AGU(addrA, addrB, en_ram1, en_ram2, done, read_sel, twaddr, clk, reset);
	input logic clk, reset;
	output logic [4:0] addrA, addrB;
	output logic en_ram1, en_ram2, done, read_sel;
	output logic [3:0] twaddr;

	logic [6:0] i;
	logic [7:0] j;

	addr_gen addrgenm (.ja(addrA), .jb(addrB), .twaddr(twaddr), .i(i[2:0]), .j(j[3:0]));

	localparam COMPUTE = 2'b00;
	localparam WRITE = 2'b01;
	localparam DONE = 2'b10;

	logic [1:0] ps, ns;

	//enum {COMPUTE, WRITE, DONE} ps, ns;

	localparam BUTCYCLE = 2'd1;
	logic [1:0]  but_p;

	always_comb begin
		case (ps)
			//RESET:	if (reset) begin
			//		ns = RESET;
			//	end else begin
			//		ns = COMPUTE;
			//	end
			COMPUTE:if (but_p < (BUTCYCLE - 1'b1)) begin
					ns = COMPUTE;
				end else begin
					ns = WRITE;
				end
			WRITE:	if ((i[2:0] == 3'b100) & (j[3:0] == 4'b1111)) begin
					ns = DONE;
				end else begin
					ns = COMPUTE;
				end
			DONE:	ns = DONE;
		endcase
	end

	always_ff @(posedge clk) begin
		if (reset) begin
			ps <= COMPUTE;
			but_p <= 2'b00;
			i <= 7'b0;
			j <= 8'b0;
			en_ram1 <= 1'b0;
			en_ram2 <= 1'b0;
			done <= 1'b0;
		end else begin
			ps <= ns;
			if ((ps == COMPUTE) & (ns == COMPUTE)) begin
				but_p <= but_p + 1'b1;
				i <= i;
				j <= j;
				en_ram1 <= en_ram1;
				en_ram2 <= en_ram2;
				done <= 1'b0;
			end else if ((ps == COMPUTE) & (ns == WRITE)) begin
				but_p <= 2'b00;
				i <= i;
				j <= j;
				if (read_sel == 1'b0) begin
					en_ram1 <= 1'b0;
					en_ram2 <= 1'b1;
				end else begin
					en_ram1 <= 1'b1;
					en_ram2 <= 1'b0;
				end
				done <= 1'b0;
			end else if ((ps == WRITE) & (ns == COMPUTE)) begin
				but_p <= 2'b00;
				if (j[3:0] == 4'b1111) begin
					i <= i + 1'b1;
					j <= 8'b0;
				end else begin
					i <= i;
					j <= j + 1'b1;
				end
				en_ram1 <= 1'b0;
				en_ram2 <= 1'b0;
				done <= 1'b0;
			end else if ((ps == WRITE) & (ns == DONE)) begin
				but_p <= 2'b00;
				i <= 7'b0;
				j <= 8'b0;
				en_ram1 <= 1'b0;
				en_ram2 <= 1'b0;
				done <= 1'b1;
			end else if ((ps == DONE) & (ns == DONE)) begin
				but_p <= 2'b00;
				i <= 7'b0;
				j <= 8'b0;
				en_ram1 <= 1'b0;
				en_ram2 <= 1'b0;
				done <= 1'b1;
			end
		end
	end

	assign read_sel = i[0];
endmodule
