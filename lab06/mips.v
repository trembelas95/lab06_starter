// Copyright (C) 1991-2013 Altera Corporation
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, Altera MegaCore Function License 
// Agreement, or other applicable license agreement, including, 
// without limitation, that your use is for the sole purpose of 
// programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the 
// applicable agreement for further details.

// PROGRAM		"Quartus II 64-Bit"
// VERSION		"Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition"
// CREATED		"Thu Mar 30 12:26:02 2017"

module mips(
	clk,
	reset
);


input wire	clk;
input wire	reset;

wire	[31:0] a;
wire	[31:0] b;
wire	branch;
wire	brTaken;
wire	[31:0] brTarget;
wire	[31:0] dmem_in;
wire	eq;
wire	[31:0] eqA;
wire	[31:0] eqB;
wire	[2:0] ex_alucont;
wire	[31:0] ex_aluOut;
wire	ex_aluSrc;
wire	[1:0] ex_forwardA;
wire	[1:0] ex_forwardB;
wire	[31:0] ex_imm;
wire	ex_isLoad;
wire	ex_ldstBypass;
wire	ex_memToReg;
wire	ex_memWrite;
wire	[4:0] ex_rd;
wire	[31:0] ex_rdA;
wire	[31:0] ex_rdB;
wire	ex_regWrite;
wire	[31:0] ex_src2;
wire	flowChange;
wire	flush;
wire	[2:0] id_alucont;
wire	id_aluSrc;
wire	id_eqFwdA;
wire	id_eqFwdB;
wire	[1:0] id_forwardA;
wire	[1:0] id_forwardB;
wire	[31:0] id_imm;
wire	id_isLoad;
wire	id_ldstBypass;
wire	id_memToReg;
wire	id_memWrite;
wire	id_mw_q;
wire	[31:0] id_rdA;
wire	[31:0] id_rdB;
wire	id_regWrite;
wire	id_rg_q;
wire	[31:0] if_instr;
wire	[31:0] imem_out;
wire	[31:0] immed;
wire	[31:0] imSh2;
wire	[31:0] instruction;
wire	isNop;
wire	isStore;
wire	[31:0] jmpTarget;
wire	jump;
wire	lui;
wire	[31:0] mem_aluOut;
wire	mem_isLoad;
wire	mem_ldstBypass;
wire	mem_memToReg;
wire	mem_memWrite;
wire	[31:0] mem_mo;
wire	[4:0] mem_rd;
wire	mem_regWrite;
wire	[31:0] mem_src2;
wire	[31:0] npc;
wire	[31:0] pc;
wire	[31:0] pcf;
wire	[31:0] pcSeq;
wire	[31:0] pcTarget;
wire	readsRs;
wire	readsRt;
wire	regDst;
wire	stall;
wire	[31:0] uimmed;
wire	[31:0] wb_aluOut;
wire	wb_memToReg;
wire	[31:0] wb_mo;
wire	[4:0] wb_rd;
wire	wb_regWrite;
wire	[31:0] wb_writeData;
wire	[4:0] wr;
wire	SYNTHESIZED_WIRE_0;
wire	SYNTHESIZED_WIRE_6;
wire	[31:0] SYNTHESIZED_WIRE_3;
wire	[31:0] SYNTHESIZED_WIRE_4;
wire	SYNTHESIZED_WIRE_5;





alu	b2v_alu(
	.a(a),
	.alucont(ex_alucont),
	.b(b),
	
	.result(ex_aluOut));


mux2_32	b2v_alusrc_mux(
	.s(ex_aluSrc),
	.d0(ex_src2),
	.d1(ex_imm),
	.y(b));


adder	b2v_br_adder(
	.a(pcSeq),
	.b(imSh2),
	.y(brTarget));


sl2_32	b2v_br_shift(
	.a(immed),
	.y(imSh2));


maindec	b2v_dec(
	.funct(instruction[5:0]),
	.op(instruction[31:26]),
	.branch(branch),
	.jump(jump),
	.lui(lui),
	.isLoad(id_isLoad),
	.isStore(isStore),
	.isNop(isNop),
	.readsRs(readsRs),
	.readsRt(readsRt),
	.memwrite(id_memWrite),
	.regwrite(id_regWrite),
	.memtoreg(id_memToReg),
	.regdst(regDst),
	.alusrc(id_aluSrc),
	.alucontrol(id_alucont));


dmem	b2v_dmem(
	.clk(clk),
	.we(mem_memWrite),
	.a(mem_aluOut),
	.wd(dmem_in),
	.rd(mem_mo));


mux2_5	b2v_dst_mux14(
	.s(regDst),
	.d0(instruction[20:16]),
	.d1(instruction[15:11]),
	.y(wr));


eq_cmp	b2v_eq_cmp(
	.rA(eqA),
	.rB(eqB),
	.eq(eq));


pr_ex_mem	b2v_ex_mem_pipe_reg(
	.clk(clk),
	.reset(reset),
	.ex_memWrite(ex_memWrite),
	.ex_isLoad(ex_isLoad),
	.ex_ldstBypass(ex_ldstBypass),
	.ex_memToReg(ex_memToReg),
	.ex_regWrite(ex_regWrite),
	.ex_aluOut(ex_aluOut),
	.ex_rd(ex_rd),
	.ex_src2(ex_src2),
	.mem_isLoad(mem_isLoad),
	.mem_memWrite(mem_memWrite),
	.mem_ldstBypass(mem_ldstBypass),
	.mem_memToReg(mem_memToReg),
	.mem_regWrite(mem_regWrite),
	.mem_aluOut(mem_aluOut),
	.mem_rd(mem_rd),
	.mem_src2(mem_src2));


pr_id_ex	b2v_id_ex_pipe_reg(
	.clk(clk),
	.reset(reset),
	.id_isLoad(id_isLoad),
	.id_aluSrc(id_aluSrc),
	.id_memWrite(id_mw_q),
	.id_ldstBypass(id_ldstBypass),
	.id_memToReg(id_memToReg),
	.id_regWrite(id_rg_q),
	.id_alucont(id_alucont),
	.id_forwardA(id_forwardA),
	.id_forwardB(id_forwardB),
	.id_imm(id_imm),
	.id_rd(wr),
	.id_rdA(id_rdA),
	.id_rdB(id_rdB),
	.ex_isLoad(ex_isLoad),
	.ex_aluSrc(ex_aluSrc),
	.ex_memWrite(ex_memWrite),
	.ex_ldstBypass(ex_ldstBypass),
	.ex_memToReg(ex_memToReg),
	.ex_regWrite(ex_regWrite),
	.ex_alucont(ex_alucont),
	.ex_forwardA(ex_forwardA),
	.ex_forwardB(ex_forwardB),
	.ex_imm(ex_imm),
	.ex_rd(ex_rd),
	.ex_rdA(ex_rdA),
	.ex_rdB(ex_rdB));


mux2_32	b2v_idSrcABypassMux(
	.s(id_eqFwdA),
	.d0(id_rdA),
	.d1(mem_aluOut),
	.y(eqA));


mux2_32	b2v_idSrcBBypassMux(
	.s(id_eqFwdB),
	.d0(id_rdB),
	.d1(mem_aluOut),
	.y(eqB));


pr_if_id	b2v_if_id_pipe_reg(
	.clk(clk),
	.reset(reset),
	.loadEn(SYNTHESIZED_WIRE_0),
	.if_instr(if_instr),
	.pcf(pcf),
	.id_instr(instruction),
	.pcSeq(pcSeq));


imem	b2v_imem(
	.a(pc),
	.rd(imem_out));


mux2_32	b2v_imm_mux(
	.s(lui),
	.d0(immed),
	.d1(uimmed),
	.y(id_imm));


signext	b2v_imm_signext(
	.a(instruction[15:0]),
	.y(immed));


lpm_constant0	b2v_inst1(
	.result(SYNTHESIZED_WIRE_3));

assign	id_mw_q = id_memWrite & SYNTHESIZED_WIRE_6;

assign	id_rg_q = id_regWrite & SYNTHESIZED_WIRE_6;

assign	SYNTHESIZED_WIRE_6 =  ~stall;

assign	SYNTHESIZED_WIRE_0 =  ~stall;

assign	SYNTHESIZED_WIRE_5 =  ~stall;

assign	brTaken = branch & eq;

assign	jmpTarget[30] = pcSeq[30];


assign	jmpTarget[29] = pcSeq[29];


assign	jmpTarget[31] = pcSeq[31];


assign	jmpTarget[28] = pcSeq[28];



lpm_constant4	b2v_inst27(
	.result(SYNTHESIZED_WIRE_4));


mux2_32	b2v_instr_mux(
	.s(flush),
	.d0(imem_out),
	.d1(SYNTHESIZED_WIRE_3),
	.y(if_instr));


sl2_26	b2v_jump_shft(
	.a(instruction[25:0]),
	.y(jmpTarget[27:0]));


mux2_32	b2v_ldstbypass_mux(
	.s(mem_ldstBypass),
	.d0(mem_src2),
	.d1(wb_writeData),
	.y(dmem_in));


pr_mem_wb	b2v_mem_wb_pipe_reg(
	.clk(clk),
	.reset(reset),
	.mem_memToReg(mem_memToReg),
	.mem_regWrite(mem_regWrite),
	.mem_aluOut(mem_aluOut),
	.mem_mo(mem_mo),
	.mem_rd(mem_rd),
	.wb_memToReg(wb_memToReg),
	.wb_regWrite(wb_regWrite),
	.wb_aluOut(wb_aluOut),
	.wb_mo(wb_mo),
	.wb_rd(wb_rd));


mux2_32	b2v_npc_mux(
	.s(flowChange),
	.d0(pcf),
	.d1(pcTarget),
	.y(npc));


adder	b2v_pc_adder(
	.a(SYNTHESIZED_WIRE_4),
	.b(pc),
	.y(pcf));


flopr	b2v_pc_reg(
	.clk(clk),
	.reset(reset),
	.loadEn(SYNTHESIZED_WIRE_5),
	.d(npc),
	.q(pc));


mux2_32	b2v_pcTarg_mux(
	.s(jump),
	.d0(brTarget),
	.d1(jmpTarget),
	.y(pcTarget));


pipe_ctrl	b2v_pipeline_control(
	.isStore(isStore),
	.isNop(isNop),
	.readsRs(readsRs),
	.readsRt(readsRt),
	.branch(branch),
	.jump(jump),
	.brTaken(brTaken),
	.ex_regWrite(ex_regWrite),
	.ex_isLoad(ex_isLoad),
	.mem_regWrite(mem_regWrite),
	.mem_isLoad(mem_isLoad),
	.ex_rd(ex_rd),
	.mem_rd(mem_rd),
	.rs(instruction[25:21]),
	.rt(instruction[20:16]),
	.flush(flush),
	.flowChange(flowChange),
	.stall(stall),
	.id_eqFwdA(id_eqFwdA),
	.id_eqFwdB(id_eqFwdB),
	.id_ldstBypass(id_ldstBypass),
	.id_forwardA(id_forwardA),
	.id_forwardB(id_forwardB));


regfile	b2v_regfile(
	.clk(clk),
	.we3(wb_regWrite),
	.ra1(instruction[25:21]),
	.ra2(instruction[20:16]),
	.wa3(wb_rd),
	.wd3(wb_writeData),
	.rd1(id_rdA),
	.rd2(id_rdB));


mux3_32	b2v_src1Bypass_mux(
	.d0(ex_rdA),
	.d1(wb_writeData),
	.d2(mem_aluOut),
	.s(ex_forwardA),
	.y(a));


mux3_32	b2v_src2Bypass_mux(
	.d0(ex_rdB),
	.d1(wb_writeData),
	.d2(mem_aluOut),
	.s(ex_forwardB),
	.y(ex_src2));


sl16_32	b2v_upper_imm(
	.a(instruction[15:0]),
	.y(uimmed));


mux2_32	b2v_wd_mux(
	.s(wb_memToReg),
	.d0(wb_aluOut),
	.d1(wb_mo),
	.y(wb_writeData));


endmodule
