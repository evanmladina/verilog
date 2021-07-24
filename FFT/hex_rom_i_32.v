module hex_rom_i_32 (dout, addr, en, clk);
	output logic [15:0] dout;
	input logic [4:0]addr;
	input logic en, clk;

	//(*rom_style = "block" *) logic [15:0] data;
	logic [15:0] data;

	always_ff @(posedge clk)
	begin
	    if(en)
	        case(addr)
		    5'd0: data <= 16'h0000;
		    5'd1: data <= 16'h8be9;
		    5'd2: data <= 16'h6ead;
		    5'd3: data <= 16'haeab;
		    5'd4: data <= 16'h080f;
		    5'd5: data <= 16'h012d;
		    5'd6: data <= 16'h000f;
		    5'd7: data <= 16'hfffe;
		    5'd8: data <= 16'hffff;
		    5'd9: data <= 16'h0000;
		    5'd10: data <= 16'h0000;
		    5'd11: data <= 16'h0000;
		    5'd12: data <= 16'h0000;
		    5'd13: data <= 16'h0000;
		    5'd14: data <= 16'h0000;
		    5'd15: data <= 16'h0000;
		    5'd16: data <= 16'h0000;
		    5'd17: data <= 16'h0000;
		    5'd18: data <= 16'h0000;
		    5'd19: data <= 16'h0000;
		    5'd20: data <= 16'h0000;
		    5'd21: data <= 16'h0000;
		    5'd22: data <= 16'h0000;
		    5'd23: data <= 16'h0000;
		    5'd24: data <= 16'h0000;
		    5'd25: data <= 16'h0000;
		    5'd26: data <= 16'h0000;
		    5'd27: data <= 16'h0000;
		    5'd28: data <= 16'h0000;
		    5'd29: data <= 16'h0000;
		    5'd30: data <= 16'h0000;
		    5'd31: data <= 16'h0000;
		endcase
	end

	assign dout = data;

endmodule
