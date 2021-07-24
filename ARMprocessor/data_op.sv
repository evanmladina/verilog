`timescale 1ns/10ps

module data_op #(parameter WIDTH = 64) (flags, Reg_B_Tests, instr, cntrl, clk, store_flags);
		output logic [3:0] flags;
		output logic [1:0] Reg_B_Tests;
		input logic [31:0] instr;
		input logic [19:0] cntrl;
		input logic clk;
		input logic [3:0] store_flags;
		
		parameter delay = 0.05;
		
		logic [63:0] WR_Dw;
		
		//Datapath logic
		logic [WIDTH-1:0] Da, Db, Dw;
		logic [4:0] Rn, Rm, Rd, R_m_d;
		logic [10:0] opcode;
		logic [8:0] Daddr9;
		logic [11:0] Imm12;
		logic [WIDTH-1:0] se_dAddr9, se_Imm12, dAddr9_Imm12, dAddr9_Imm12_Db;
		logic [WIDTH-1:0] ALU_res;
		logic negative, zero, overflow, carry_out;
		logic [WIDTH-1:0] Dout, Dout_LDURB, Dout_LDUR_LDURB;
		logic [WIDTH-1:0] se_Imm16, le_Imm16;
		logic [WIDTH-1:0] movk_0, movk_1, movk_2, movk_3, movz_0, movz_1, movz_2, movz_3;
		logic [WIDTH-1:0] MemALU;
		logic [1:0] LSL;
		logic [15:0] Imm16;
		logic [WIDTH-1:0] MovZ, MovK, MovZK;
		logic Reg_B_Test_Zero, Reg_B_Test_LT;
		
		//Flag parse
		always_comb begin
			flags[3:0] = {negative, zero, overflow, carry_out};
		end
		
		//Reg_B_Test parse
		always_comb begin
			Reg_B_Tests[1:0] = {Reg_B_Test_Zero, Reg_B_Test_LT};
		end
		
		//Control logic
		logic Reg2Loc, ALUSrc, MemToReg, RegWrite, MemWrite, ReadEnable, dAddr9_Imm12_Sel, LDURB_ext, MovZKSelect, MemALU_MOV_Select;
		logic [2:0] ALUOp;
		logic [3:0] xfer_size;
		
		//Control logic Execute stage
		logic [19:0] EX_cntrl;
		logic EX_Reg2Loc, EX_ALUSrc, EX_MemToReg, EX_RegWrite, EX_MemWrite, EX_ReadEnable, EX_dAddr9_Imm12_Sel, EX_LDURB_ext, EX_MovZKSelect, EX_MemALU_MOV_Select;
		logic [2:0] EX_ALUOp;
		logic [3:0] EX_xfer_size;
		
		//Control logic Mem stage
		logic [19:0] MEM_cntrl;
		logic MEM_Reg2Loc, MEM_ALUSrc, MEM_MemToReg, MEM_RegWrite, MEM_MemWrite, MEM_ReadEnable, MEM_dAddr9_Imm12_Sel, MEM_LDURB_ext, MEM_MovZKSelect, MEM_MemALU_MOV_Select;
		logic [2:0] MEM_ALUOp;
		logic [3:0] MEM_xfer_size;
		
		//Control logic Write stage
		logic [19:0] WR_cntrl;
		logic WR_Reg2Loc, WR_ALUSrc, WR_MemToReg, WR_RegWrite, WR_MemWrite, WR_ReadEnable, WR_dAddr9_Imm12_Sel, WR_LDURB_ext, WR_MovZKSelect, WR_MemALU_MOV_Select;
		logic [2:0] WR_ALUOp;
		logic [3:0] WR_xfer_size;

		DFF_VAR #(.WIDTH(20)) EX_cntrl_DFF (.q(EX_cntrl), .d(cntrl), .reset(1'b0), .clk);
		DFF_VAR #(.WIDTH(20)) MEM_cntrl_DFF (.q(MEM_cntrl), .d(EX_cntrl), .reset(1'b0), .clk);
		DFF_VAR #(.WIDTH(20)) WR_cntrl_DFF (.q(WR_cntrl), .d(MEM_cntrl), .reset(1'b0), .clk);
		
		//Contrl parse
		always_comb begin
			xfer_size = cntrl[3:0];
			ALUOp = cntrl[6:4]; //Done
			ReadEnable = cntrl[7];
			MemWrite = cntrl[10]; //Done
			RegWrite = cntrl[11]; //Done
			MemToReg = cntrl[12]; //Done
			ALUSrc = cntrl[13];
			Reg2Loc = cntrl[14];
			dAddr9_Imm12_Sel = cntrl[16];
			LDURB_ext = cntrl[17];
			MovZKSelect = cntrl[18];
			MemALU_MOV_Select = cntrl[19];
		end
		
		//Contrl parse for execute stage
		always_comb begin
			EX_xfer_size = EX_cntrl[3:0];
			EX_ALUOp = EX_cntrl[6:4];
			EX_ReadEnable = EX_cntrl[7];
			EX_MemWrite = EX_cntrl[10];
			EX_RegWrite = EX_cntrl[11];
			EX_MemToReg = EX_cntrl[12];
			EX_ALUSrc = EX_cntrl[13];
			EX_Reg2Loc = EX_cntrl[14];
			EX_dAddr9_Imm12_Sel = EX_cntrl[16];
			EX_LDURB_ext = EX_cntrl[17];
			EX_MovZKSelect = EX_cntrl[18];
			EX_MemALU_MOV_Select = EX_cntrl[19];
		end
		
		//Contrl parse for Mem stage
		always_comb begin
			MEM_xfer_size = MEM_cntrl[3:0];
			MEM_ALUOp = MEM_cntrl[6:4];
			MEM_ReadEnable = MEM_cntrl[7];
			MEM_MemWrite = MEM_cntrl[10];
			MEM_RegWrite = MEM_cntrl[11];
			MEM_MemToReg = MEM_cntrl[12];
			MEM_ALUSrc = MEM_cntrl[13];
			MEM_Reg2Loc = MEM_cntrl[14];
			MEM_dAddr9_Imm12_Sel = MEM_cntrl[16];
			MEM_LDURB_ext = MEM_cntrl[17];
			MEM_MovZKSelect = MEM_cntrl[18];
			MEM_MemALU_MOV_Select = MEM_cntrl[19];
		end

		//Contrl parse for Write stage
		always_comb begin
			WR_xfer_size = WR_cntrl[3:0];
			WR_ALUOp = WR_cntrl[6:4];
			WR_ReadEnable = WR_cntrl[7];
			WR_MemWrite = WR_cntrl[10];
			WR_RegWrite = WR_cntrl[11];
			WR_MemToReg = WR_cntrl[12];
			WR_ALUSrc = WR_cntrl[13];
			WR_Reg2Loc = WR_cntrl[14];
			WR_dAddr9_Imm12_Sel = WR_cntrl[16];
			WR_LDURB_ext = WR_cntrl[17];
			WR_MovZKSelect = WR_cntrl[18];
			WR_MemALU_MOV_Select = WR_cntrl[19];
		end
		
		//Execute stage instruction codes
		logic [31:0] EX_instr;
		logic [4:0] EX_Rn, EX_Rm, EX_Rd;
		logic [10:0] EX_opcode;
		logic [8:0] EX_Daddr9;
		logic [11:0] EX_Imm12;
		logic [1:0] EX_LSL;
		logic [15:0] EX_Imm16;
		
		//Memory stage instruction codes
		logic [31:0] MEM_instr;
		logic [4:0] MEM_Rn, MEM_Rm, MEM_Rd;
		logic [10:0] MEM_opcode;
		logic [8:0] MEM_Daddr9;
		logic [11:0] MEM_Imm12;
		logic [1:0] MEM_LSL;
		logic [15:0] MEM_Imm16;
		
		//Write back stage instruction codes
		logic [31:0] WR_instr;
		logic [4:0] WR_Rn, WR_Rm, WR_Rd;
		logic [10:0] WR_opcode;
		logic [8:0] WR_Daddr9;
		logic [11:0] WR_Imm12;
		logic [1:0] WR_LSL;
		logic [15:0] WR_Imm16;
		
		//Instruction flip flops
		DFF_VAR #(.WIDTH(32)) EX_instr_DFF (.q(EX_instr), .d(instr), .reset(1'b0), .clk);
		DFF_VAR #(.WIDTH(32)) MEM_instr_DFF (.q(MEM_instr), .d(EX_instr), .reset(1'b0), .clk);
		DFF_VAR #(.WIDTH(32)) WR_instr_DFF (.q(WR_instr), .d(MEM_instr), .reset(1'b0), .clk);
		
		//Instruction parse
		always_comb begin
			Rn = instr[9:5];
			Rm = instr[20:16];
			Rd = instr[4:0];
			Daddr9 = instr[20:12];
			Imm12 = instr[21:10];
			opcode = instr[31:21];
			LSL = instr[22:21];
			Imm16 = instr[20:5];
		end
		
		//Instruction parse Execute stage
		always_comb begin
			EX_Rn = EX_instr[9:5];
			EX_Rm = EX_instr[20:16];
			//EX_Rd = EX_instr[4:0];
			EX_Daddr9 = EX_instr[20:12];
			EX_Imm12 = EX_instr[21:10];
			EX_opcode = EX_instr[31:21];
			EX_LSL = EX_instr[22:21];
			EX_Imm16 = EX_instr[20:5];
		end
		
		//Instruction parse Mem stage
		always_comb begin
			MEM_Rn = MEM_instr[9:5];
			MEM_Rm = MEM_instr[20:16];
			//MEM_Rd = MEM_instr[4:0];
			MEM_Daddr9 = MEM_instr[20:12];
			MEM_Imm12 = MEM_instr[21:10];
			MEM_opcode = MEM_instr[31:21];
			MEM_LSL = MEM_instr[22:21];
			MEM_Imm16 = MEM_instr[20:5];
		end
		
		//Instruction parse Write back stage
		always_comb begin
			WR_Rn = WR_instr[9:5];
			WR_Rm = WR_instr[20:16];
			//WR_Rd = WR_instr[4:0];
			WR_Daddr9 = WR_instr[20:12];
			WR_Imm12 = WR_instr[21:10];
			WR_opcode = WR_instr[31:21];
			WR_LSL = WR_instr[22:21];
			WR_Imm16 = WR_instr[20:5];
		end
		
		//Regfile with Muxed input to ReadRegister2
		mux2_1_VARb #(.WIDTH(5)) regMux (.out(R_m_d), .in({Rm, Rd}), .sel(Reg2Loc));
		
		//HACK ALERT
		logic invert_clk;
		not #delay (invert_clk, clk);
		
		regfile rf (.ReadData1(Da), .ReadData2(Db), .WriteData(WR_Dw), .ReadRegister1(Rn), .ReadRegister2(R_m_d), .WriteRegister(WR_Rd), .RegWrite(WR_RegWrite), .clk(invert_clk));

		//Execute stage flip flops
		logic [63:0] EX_Da;
		logic [63:0] EX_Db;
		logic [63:0] EX_dAddr9_Imm12_Db;
		//logic [4:0] EX_Rd;


		//forwarding_unit f_u (.RF_Da_Sel, .RF_Db_Sel, .AaRF(Rn), .AbRF(R_m_d), .AwEX(EX_Rd), .AwMEM(MEM_Rd), .opcode, .EX_opcode, .MEM_opcode);
		
		logic [2:0] RF_Da_Sel, RF_Db_Sel;
		//forwarding_unit f_u (.RF_Da_Sel, .RF_Db_Sel, .AaRF(Rn), .AbRF(R_m_d), .AwEX(EX_Rd), .AwMEM(MEM_Rd), .opcode, .EX_opcode, .MEM_opcode);

		//Forwarding logic
		always_comb begin
			if(Rn == EX_Rd) begin
				if(Rn == 5'b11111)
					RF_Da_Sel = 3'b001;
				else if(EX_opcode[10:2] == 9'b110100101 || EX_opcode[10:2] == 9'b111100101)
					RF_Da_Sel = 3'b100;
				else
					RF_Da_Sel = 3'b010;
			end else if (Rn == MEM_Rd) begin
				if(Rn == 5'b11111)
					RF_Da_Sel = 3'b001;
				else if(MEM_opcode[10:2] == 9'b110100101 || MEM_opcode[10:2] == 9'b111100101)
					RF_Da_Sel = 3'b101;
				else
					RF_Da_Sel = 3'b011;
			end else
				RF_Da_Sel = 3'b001;
				
			if(R_m_d == EX_Rd) begin
				if(R_m_d == 5'b11111)
					RF_Db_Sel = 3'b001;
				else if(EX_opcode[10:2] == 9'b110100101 || EX_opcode[10:2] == 9'b111100101)
					RF_Db_Sel = 3'b100;
				else
					RF_Db_Sel = 2'b010;
			end else if (R_m_d == MEM_Rd) begin
				if(R_m_d == 5'b11111)
					RF_Db_Sel = 3'b001;
				if(MEM_opcode[10:2] == 9'b110100101 || MEM_opcode[10:2] == 9'b111100101)
					RF_Db_Sel = 3'b101;
				else
					RF_Db_Sel = 3'b011;
			end else
				RF_Db_Sel = 3'b001;
				
				
			//Case where STUR/STURB/LDUR/LDURB is followed by STUR/STURB/LDUR/LDURB
			if((opcode == 11'b11111000000 || opcode == 11'b00111000000 || opcode == 11'b11111000010 || opcode == 11'b00111000010) && (EX_opcode == 11'b11111000000 || EX_opcode == 11'b00111000000 || EX_opcode == 11'b11111000010 || EX_opcode == 11'b00111000010)) begin
			    if (R_m_d == MEM_Rd)
				    RF_Db_Sel = 2'b011;
			end else if(EX_opcode == 11'b11111000000 || EX_opcode == 11'b00111000000) begin
				 if (Rn == EX_Rd)
				    RF_Da_Sel = 2'b001;
			    if (R_m_d == EX_Rd)
				    RF_Db_Sel = 2'b001;
			end
			
		end		
		
		
		//Da = 01, ALU_res = 10, Dw = 11
		logic [63:0] Da_mux, Db_mux;
		logic [63:0] EX_MovZK, MEM_MovZK;	
		//mux4_1_VARb #(.WIDTH(64)) DaMux (.out(Da_mux), .in({Dw, ALU_res, Da, 64'b0}), .sel(RF_Da_Sel));
		//mux4_1_VARb #(.WIDTH(64)) DbMux (.out(Db_mux), .in({Dw, ALU_res, Db, 64'b0}), .sel(RF_Db_Sel));
		
		mux8_1_VARb #(.WIDTH(64)) DaMux (.out(Da_mux), .in({64'b0, 64'b0, MEM_MovZK, EX_MovZK, Dw, ALU_res, Da, 64'b0}), .sel(RF_Da_Sel));
		mux8_1_VARb #(.WIDTH(64)) DbMux (.out(Db_mux), .in({64'b0, 64'b0, MEM_MovZK, EX_MovZK, Dw, ALU_res, Db, 64'b0}), .sel(RF_Db_Sel));
		
		//CBZ Giant Nor test
		giant_nor zeroNor (.zero(Reg_B_Test_Zero), .result(Db_mux));
		
		logic BLT_xor, BLT_store_xor;
		xor #delay (BLT_xor, negative, overflow);
		xor #delay (BLT_store_xor, store_flags[3], store_flags[1]);
		
		always_comb begin
			if(opcode[10:3] == 8'b01010100 && Rd == 5'b01011 && EX_cntrl[15] == 1'b1)
				Reg_B_Test_LT = BLT_xor;
			else
				Reg_B_Test_LT = BLT_store_xor;
		end
		
		//Execute stage flip flops
		DFF_VAR #(.WIDTH(64)) EX_Da_DFF (.q(EX_Da), .d(Da_mux), .reset(1'b0), .clk);
		DFF_VAR #(.WIDTH(64)) EX_Db_DFF (.q(EX_Db), .d(Db_mux), .reset(1'b0), .clk);
		DFF_VAR #(.WIDTH(64)) EX_ALU_B_DFF (.q(EX_dAddr9_Imm12_Db), .d(dAddr9_Imm12_Db), .reset(1'b0), .clk);
		DFF_VAR #(.WIDTH(5)) EX_Rd_DFF (.q(EX_Rd), .d(Rd), .reset(1'b0), .clk);
		
		//Sign Extension of dAddr9, muxed with ReadData2
		//////////#############CHECK THESE IF THERE IS AN ERROR###########
		sign_extend #(.WIDTH_IN(9), .WIDTH_OUT(WIDTH)) seDAddr9 (.out(se_dAddr9), .in(Daddr9), .sign(1'b1));
		sign_extend #(.WIDTH_IN(12), .WIDTH_OUT(WIDTH)) seImm12 (.out(se_Imm12), .in(Imm12), .sign(1'b0));
		mux2_1_VARb muxDaddr9_Imm12 (.out(dAddr9_Imm12), .in({se_dAddr9, se_Imm12}), .sel(dAddr9_Imm12_Sel));
		
		mux2_1_VARb muxALUSrc (.out(dAddr9_Imm12_Db), .in({dAddr9_Imm12, Db_mux}), .sel(ALUSrc));
		
		//ALU
		alu ALU (.result(ALU_res), .negative, .zero, .overflow, .carry_out, .A(EX_Da), .B(EX_dAddr9_Imm12_Db), .cntrl(EX_ALUOp));
		
		//MEM stage flip flops
		//logic [5:0] MEM_Rd;
		logic [63:0] MEM_Db;
		logic [63:0] MEM_dAddr9_Imm12_Db;
		logic [63:0] MEM_ALU_res;
		DFF_VAR #(.WIDTH(5)) MEM_Rd_DFF (.q(MEM_Rd), .d(EX_Rd), .reset(1'b0), .clk);
		DFF_VAR #(.WIDTH(64)) MEM_Db_DFF (.q(MEM_Db), .d(EX_Db), .reset(1'b0), .clk);
		DFF_VAR #(.WIDTH(64)) MEM_ALU_B_DFF (.q(MEM_dAddr9_Imm12_Db), .d(EX_dAddr9_Imm12_Db), .reset(1'b0), .clk);
		DFF_VAR #(.WIDTH(64)) MEM_ALU_res_DFF (.q(MEM_ALU_res), .d(ALU_res), .reset(1'b0), .clk);
		
		//Data Memory
		datamem DataMem (.address(MEM_ALU_res), .write_enable(MEM_MemWrite), .read_enable(MEM_ReadEnable), .write_data(MEM_Db), .clk, .xfer_size(MEM_xfer_size), .read_data(Dout));

		//LDUR or LDURB
		always_comb begin
			Dout_LDURB = {56'b0, Dout[7:0]};
			end

		mux2_1_VARb LDURBExt (.out(Dout_LDUR_LDURB), .in({Dout_LDURB, Dout}), .sel(MEM_LDURB_ext));
		
		//Memory or ALU op to register file
		mux2_1_VARb muxDout (.out(MemALU), .in({Dout_LDUR_LDURB, MEM_ALU_res}), .sel(MEM_MemToReg));
		
		//MOVZ MOVK
		always_comb begin
			movk_0 = {Db_mux[63:16], Imm16};
			movk_1 = {Db_mux[63:32], Imm16, Db_mux[15:0]};
			movk_2 = {Db_mux[63:48], Imm16, Db_mux[31:0]};
			movk_3 = {Imm16, Db_mux[47:0]};
		end
		
		always_comb begin
			movz_0 = {48'b0, Imm16};
			movz_1 = {32'b0, Imm16, 16'b0};
			movz_2 = {16'b0, Imm16, 32'b0};
			movz_3 = {Imm16, 48'b0};
		end
		
		mux4_1_VARb muxMovZ (.out(MovZ), .in({movz_3, movz_2, movz_1, movz_0}), .sel(LSL));
		mux4_1_VARb muxMovK (.out(MovK), .in({movk_3, movk_2, movk_1, movk_0}), .sel(LSL));
		
		mux2_1_VARb muxMovZK (.out(MovZK), .in({MovZ, MovK}), .sel(MovZKSelect));
		
		
		DFF_VAR #(.WIDTH(64)) EX_MovZK_DFF (.q(EX_MovZK), .d(MovZK), .reset(1'b0), .clk);
		DFF_VAR #(.WIDTH(64)) MEM_MovZK_DFF (.q(MEM_MovZK), .d(EX_MovZK), .reset(1'b0), .clk);
		
		//Mem/ALUop or MOVZ/MOVK to register file
		mux2_1_VARb muxDw (.out(Dw), .in({MemALU, MEM_MovZK}), .sel(MEM_MemALU_MOV_Select));
		//mux2_1_VARb muxDw (.out(Dw), .in({MemALU, MEM_Db}), .sel(MEM_MemALU_MOV_Select));
		
		//Write stage flip flops
		//logic [63:0] WR_Rd;
		//logic [63:0] WR_Dw;
		DFF_VAR #(.WIDTH(5)) WR_Rd_DFF (.q(WR_Rd), .d(MEM_Rd), .reset(1'b0), .clk);
		DFF_VAR #(.WIDTH(64)) WR_Dw_DFF (.q(WR_Dw), .d(Dw), .reset(1'b0), .clk);
		
		
endmodule


module data_op_testbench();
		parameter WIDTH = 6;
		parameter SHIFT_AMT = 2;
		logic [WIDTH-1:0] out, in;
		
		left_shift #(.WIDTH(WIDTH), .SHIFT_AMT(SHIFT_AMT)) dut (.out, .in);
		
		initial begin
				in = 6; #10;
				in = 4; #10;
				in = 2; #10;
				in = -2; #10;
				
		end
endmodule