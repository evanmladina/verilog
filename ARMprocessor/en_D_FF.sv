`timescale 1ns/10ps

module en_D_FF (q, d, enable, clk);
		output logic q;
		input logic d, enable, clk;
		
		logic muxOut;
		
		logic clk_enable;
		
		//Add mux to D_FF to ensure new value d is only written
		//if enable is 1, otherwise output send old value to d of D_FF.
		mux2_1 m (.out(muxOut), .in({d,q}), .sel(enable));
		D_FF d_ff (.q, .d(muxOut), .reset(1'b0), .clk);
		
endmodule

module en_D_FF_testbench();
		logic q, d, enable, clk;
		
		en_D_FF dut (.q, .d, .enable, .clk);
		
		initial begin
				d=1; enable=0; clk=0; #10;
				               clk=1; #10;
				     enable=1; clk=0; #10;
				               clk=1; #10;
				               clk=0; #10;
				d=0;           clk=1; #10;
				               clk=0; #10;
				     enable=0; clk=1; #10;
		end
		
endmodule