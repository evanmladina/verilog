`timescale 1ns/10ps

module processor_cntrl (cntrl, opcode, ALU_flags, store_flags, instr, Reg_B_Tests);
		output logic [19:0] cntrl;
		input  logic [10:0] opcode;
		input logic [3:0] ALU_flags, store_flags;
		input logic [31:0] instr;
		input logic [1:0] Reg_B_Tests;
		
		logic Reg2Loc, ALUSrc, MemToReg, RegWrite, MemWrite, BrTaken, UncondBr, ReadEnable, FlagEnable, dAddr9_Imm12_Sel, LDURB_ext, MovZKSelect, MemALU_MOV_Select;
		logic [2:0] ALUOp;
		logic [3:0] xfer_size;
		
		logic [4:0] condCode;
		logic ALU_negative, ALU_zero, ALU_overflow, ALU_carry_out;
		logic store_negative, store_zero, store_overflow, store_carry_out;
		logic BLT_tt;
		
		parameter ALU_PASS_B=3'b000, ALU_ADD=3'b010, ALU_SUBTRACT=3'b011, ALU_AND=3'b100, ALU_OR=3'b101, ALU_XOR=3'b110;
		parameter op_ADD = 11'b10001011000, op_SUB = 11'b11001011000, op_LDUR = 11'b11111000010;
		parameter op_STUR = 11'b11111000000, op_B = 6'b000101, op_CBZ = 8'b10110100;
		parameter op_ADDI = 10'b1001000100, op_ADDS = 11'b10101011000, op_SUBS = 11'b11101011000;
		parameter op_B_COND = 8'b01010100, cond_LT = 5'b01011;
		parameter op_LDURB = 11'b00111000010, op_STURB = 11'b00111000000;
		parameter op_MOVZ = 9'b110100101, op_MOVK = 9'b111100101;
		
		//Parse control logic
		always_comb begin
			cntrl[19:0] = {MemALU_MOV_Select, MovZKSelect, LDURB_ext, dAddr9_Imm12_Sel, FlagEnable, Reg2Loc, ALUSrc, MemToReg, RegWrite, MemWrite, BrTaken, UncondBr, ReadEnable, ALUOp, xfer_size};
		end
		
		//Parse flags
		always_comb begin
			ALU_negative = ALU_flags[3];
			ALU_zero = ALU_flags[2];
			ALU_overflow = ALU_flags[1];
			ALU_carry_out = ALU_flags[0];
		end
		always_comb begin
			store_negative = store_flags[3];
			store_zero = store_flags[2];
			store_overflow = store_flags[1];
			store_carry_out = store_flags[0];
		end
		
		parameter delay = 0.05;
		xor #delay (BLT_tt, store_negative, store_overflow);
		
		//Parse instruction
		always_comb begin
			condCode = instr[4:0];
		end
		
		always_comb begin
			casez(opcode)
				op_ADD           : begin
					MemALU_MOV_Select=1; Reg2Loc=1; ALUSrc=0; MemToReg=0; RegWrite=1; MemWrite=0; BrTaken=0; ALUOp=ALU_ADD; ReadEnable=0; FlagEnable=0;
					end
				{op_ADDI, 1'b?}  : begin
					MemALU_MOV_Select=1; ALUSrc=1; dAddr9_Imm12_Sel=0; MemToReg=0; RegWrite=1; MemWrite=0; BrTaken=0; ALUOp=ALU_ADD; ReadEnable=0; FlagEnable=0;
					end
				op_ADDS          : begin
					MemALU_MOV_Select=1; Reg2Loc=1; ALUSrc=0; MemToReg=0; RegWrite=1; MemWrite=0; BrTaken=0; ALUOp=ALU_ADD; ReadEnable=0; FlagEnable=1;
					end
				op_SUB           : begin
					MemALU_MOV_Select=1; Reg2Loc=1; ALUSrc=0; MemToReg=0; RegWrite=1; MemWrite=0; BrTaken=0; ALUOp=ALU_SUBTRACT; ReadEnable=0; FlagEnable=0;
					end
				op_SUBS          : begin
					MemALU_MOV_Select=1; Reg2Loc=1; ALUSrc=0; MemToReg=0; RegWrite=1; MemWrite=0; BrTaken=0; ALUOp=ALU_SUBTRACT; ReadEnable=0; FlagEnable=1;
					end
				op_LDUR          : begin
					MemALU_MOV_Select=1; ALUSrc=1; dAddr9_Imm12_Sel=1; MemToReg=1; RegWrite=1; MemWrite=0; BrTaken=0; ALUOp=ALU_ADD; xfer_size=4'b1000; ReadEnable=1; FlagEnable=0; LDURB_ext=0;
					end
				op_STUR          : begin
					Reg2Loc=0; ALUSrc=1; dAddr9_Imm12_Sel=1; RegWrite=0; MemWrite=1; BrTaken=0; ALUOp=ALU_ADD; xfer_size=4'b1000; ReadEnable=0; FlagEnable=0;
					end
				op_LDURB         : begin
					MemALU_MOV_Select=1; ALUSrc=1; dAddr9_Imm12_Sel=1; MemToReg=1; RegWrite=1; MemWrite=0; BrTaken=0; ALUOp=ALU_ADD; xfer_size=4'b0001; ReadEnable=1; FlagEnable=0; LDURB_ext=1;
					end
				op_STURB         : begin
					Reg2Loc=0; ALUSrc=1; dAddr9_Imm12_Sel=1; RegWrite=0; MemWrite=1; BrTaken=0; ALUOp=ALU_ADD; xfer_size=4'b0001; ReadEnable=0; FlagEnable=0;
					end
				{op_B, 5'b?????} : begin 
					RegWrite=0; MemWrite=0; BrTaken=1; UncondBr=1; ReadEnable=0; FlagEnable=0;
					end
				{op_CBZ, 3'b???} : begin
					//Reg2Loc=0; ALUSrc=0; RegWrite=0; MemWrite=0; BrTaken=ALU_zero; UncondBr=0; ALUOp=ALU_PASS_B; ReadEnable=0; FlagEnable=0;
					Reg2Loc=0; ALUSrc=0; RegWrite=0; MemWrite=0; BrTaken=Reg_B_Tests[1]; UncondBr=0; ALUOp=ALU_PASS_B; ReadEnable=0; FlagEnable=0;
					end
				{op_B_COND, 3'b???} : begin
					case(condCode)
						cond_LT : begin
							//Reg2Loc=0; ALUSrc=0; RegWrite=0; MemWrite=0; BrTaken=BLT_tt; UncondBr=0; ALUOp=ALU_PASS_B; ReadEnable=0; FlagEnable=0;
							Reg2Loc=0; ALUSrc=0; RegWrite=0; MemWrite=0; BrTaken=Reg_B_Tests[0]; UncondBr=0; ALUOp=ALU_PASS_B; ReadEnable=0; FlagEnable=0;
							end
						default : begin
							Reg2Loc=0; FlagEnable=0;
							end
					endcase
					end	
				{op_MOVK, 2'b??} : begin
					MovZKSelect=0; MemALU_MOV_Select=0; Reg2Loc=0; RegWrite=1; MemWrite=0; BrTaken=0; ReadEnable=0; FlagEnable=0;
					end
				{op_MOVZ, 2'b??} : begin
					MovZKSelect=1; MemALU_MOV_Select=0; Reg2Loc=0; RegWrite=1; MemWrite=0; BrTaken=0; ReadEnable=0; FlagEnable=0;
					end
				default          : begin
					Reg2Loc=0; FlagEnable=0; BrTaken=0;
					end
			endcase

		end

endmodule

module processor_cntrl_testbench();
		logic [19:0] cntrl;
		logic [10:0] opcode;
		logic [3:0] ALU_flags, store_flags;
		logic [31:0] instr;
		
		parameter op_ADD = 11'b10001011000, op_SUB = 11'b11001011000, op_LDUR = 11'b11111000010;
		parameter op_STUR = 11'b11111000000, op_B = 6'b000101, op_CBZ = 8'b10110100;

		processor_cntrl dut (.cntrl, .opcode, .ALU_flags, .store_flags, .instr);
		
		initial begin
				opcode = op_ADD; #10;
				opcode = op_SUB; #10;
				opcode = op_LDUR; ALU_flags = 4'b1000; #10;
				opcode = op_STUR; #10;
				opcode = {op_B, 5'b00000}; #10;
				opcode = {op_CBZ, 3'b000}; #10;

		end
endmodule