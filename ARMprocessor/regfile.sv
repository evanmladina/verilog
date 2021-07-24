module regfile(ReadData1, ReadData2, WriteData, ReadRegister1, ReadRegister2, WriteRegister, RegWrite, clk);

		output logic [63:0] ReadData1, ReadData2;
		input logic [4:0] ReadRegister1, ReadRegister2, WriteRegister;
		input logic [63:0] WriteData;
		input logic RegWrite, clk;
		
		logic [31:0]      regAddress;
		logic [31:0][63:0] regOutput;
		logic  [63:0][31:0] muxInput;
		
		//Create 5 to 32 decoder.
		en_decode5_32 enable_decoder (.out(regAddress), .in(WriteRegister), .enable(RegWrite));

		genvar i;
		
		//Set register 31 to 0.
		en_DFF_VAR reg_64b_31 (.q(regOutput[31]), .d(64'b0), .enable(1'b1), .clk);

		//Create the rest of the registers (from 64 bit enable D flip flops).
		generate
			for(i=0; i<31; i++) begin : eachRegister
				en_DFF_VAR reg_64b (.q(regOutput[i]), .d(WriteData), .enable(regAddress[i]), .clk);

			end
		endgenerate
		
		genvar n, m;
		
		generate
			for(n=0; n<64; n++) begin : eachMux
				for(m=0; m<32; m++) begin : eachReg
					//Connect mux inputs to register outputs.
					assign muxInput[n][m] = regOutput[m][n];
				end
				//Create 64 bit 32 by 1 mux's.
				mux32_1 m1 (.out(ReadData1[n]), .in(muxInput[n]), .sel(ReadRegister1));
				mux32_1 m2 (.out(ReadData2[n]), .in(muxInput[n]), .sel(ReadRegister2));
			end
		endgenerate
				
endmodule