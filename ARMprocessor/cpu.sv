`timescale 1ns/10ps

module cpu #(parameter WIDTH = 64) (clk, reset);
		input logic clk, reset;
		
		logic [31:0] RD_instr;
		logic [19:0] cntrl;
		logic [3:0] in_flags, out_flags;
		logic [1:0] Reg_B_Tests;
		
		instruction_fetch i_f (.RD_instr, .cntrl, .reset, .clk);
		
		data_op d_op (.flags(in_flags), .Reg_B_Tests, .instr(RD_instr), .cntrl, .clk, .store_flags(out_flags));
		processor_cntrl p_c (.cntrl, .opcode(RD_instr[31:21]), .ALU_flags(in_flags), .store_flags(out_flags), .instr(RD_instr), .Reg_B_Tests);

		logic [19:0] EX_cntrl;
		DFF_VAR #(.WIDTH(20)) EX_cntrl_DFF (.q(EX_cntrl), .d(cntrl), .reset(1'b0), .clk);

		flag_reg f_r (.out_flags, .in_flags, .clk, .enable(EX_cntrl[15]));

endmodule


module cpu_testbench();
	logic clk, reset;
		
	parameter ClockDelay = 1000;
		
	cpu dut (.clk, .reset);

	// Force %t's to print in a nice format.
	initial $timeformat(-9, 2, " ns", 10);

	initial begin // Set up the clock
		clk <= 0;
		forever #(ClockDelay/2) clk <= ~clk;
	end
	
	initial begin
		reset <= 1; @(posedge clk);
		reset <= 0; @(posedge clk);
		
		for(int i=0; i<1000; i++) begin
			@(posedge clk);
		end
		$stop;
	end

endmodule
