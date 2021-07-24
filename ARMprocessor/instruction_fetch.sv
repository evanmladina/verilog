`timescale 1ns/10ps

module instruction_fetch #(parameter WIDTH = 64) (RD_instr, cntrl, reset, clk);
		output logic [31:0] RD_instr;
		input logic reset, clk;
		input logic [19:0] cntrl;
		
		logic [31:0] instr;
		
		//Control logic
		logic BrTaken, UncondBr;
		always_comb begin
			BrTaken = cntrl[9];
			UncondBr = cntrl[8];
		end
		
		//Datapath logic
		logic [WIDTH-1:0] pc_in_addr;
		logic [WIDTH-1:0] a_four_out, a_br_out;
		logic [18:0] RD_condAddr19;
		logic [25:0] RD_brAddr26;
		logic [WIDTH-1:0] se_cond, se_br, se_mux, se_shift, se_four;
		
		always_comb begin
			RD_condAddr19 = RD_instr[23:5];
			RD_brAddr26 = RD_instr[25:0];
		end
		
		logic [63:0] instr_addr;
		//Connect proper wires for program counter and instruction memory
		prog_count pc (.out(instr_addr), .in(pc_in_addr), .reset, .clk);
		instructmem i_mem (.address(instr_addr), .instruction(instr), .clk);
		
		//Program count flip flop
		logic [63:0] RD_instr_addr;
		DFF_VAR #(.WIDTH(64)) instr_addr_FF (.q(RD_instr_addr), .d(instr_addr), .reset(1'b0), .clk);
		
		//Instruction fetch flip flop
		//logic [31:0] RD_instr;
		DFF_VAR #(.WIDTH(32)) iFetch_FF (.q(RD_instr), .d(instr), .reset(1'b0), .clk);
		
		//Perform sign extention for branching
		sign_extend #(.WIDTH_IN(19), .WIDTH_OUT(WIDTH)) seCond (.out(se_cond), .in(RD_condAddr19), .sign(1'b1));
		sign_extend #(.WIDTH_IN(26), .WIDTH_OUT(WIDTH)) seBr (.out(se_br), .in(RD_brAddr26), .sign(1'b1));
		mux2_1_VARb seMux (.out(se_mux), .in({se_br, se_cond}), .sel(UncondBr));
		left_shift ls (.out(se_shift), .in(se_mux));
		
		//Construct two adders, one for branching, one for incrementing by 4 (next instruction)
		multiBitAdder #(.WIDTH(WIDTH)) aBr (.sum(a_br_out), .a(se_shift), .b(RD_instr_addr));
		sign_extend #(.WIDTH_IN(4), .WIDTH_OUT(WIDTH)) seFour (.out(se_four), .in(4'b0100), .sign(1'b0));
		multiBitAdder #(.WIDTH(WIDTH)) aFour (.sum(a_four_out), .a(instr_addr), .b(se_four));
		
		mux2_1_VARb addMux (.out(pc_in_addr), .in({a_br_out, a_four_out}), .sel(BrTaken));


endmodule


module instruction_fetch_testbench();
		parameter WIDTH = 32;
		logic [31:0] instr;
		logic [WIDTH-1:0] instr_addr;
		logic [19:0] cntrl;
		logic clk, reset;
		
		instruction_fetch dut (.instr, .instr_addr, .cntrl, .reset, .clk);
		
		initial begin
				instr = {11'b10001011000, 5'b00001, 6'b000000, 5'b00011, 5'b00000}; clk = 1; #10;
				instr = {11'b10001011000, 5'b00001, 6'b000000, 5'b00011, 5'b00000}; clk = 0; #10;
				instr = {11'b10001011000, 5'b00001, 6'b000000, 5'b00011, 5'b00000}; clk = 1; #10;
				instr = 5; clk = 0; #10;
				
		end
endmodule