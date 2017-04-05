module pipe_ctrl(
    input      [4:0] rs,
    input      [4:0] rt,
    input            isStore,
    input            isNop, // nop is sll r0, r0, 0
    input            readsRs,
    input            readsRt,
    input            branch,
    input            jump,
    input            brTaken,
    //  --- from EX ---
    input      [4:0] ex_rd,
    input            ex_regWrite,
    input            ex_isLoad,
    //  --- from MEM ---
    input      [4:0] mem_rd,
    input            mem_regWrite,
    input            mem_isLoad,
    // Outputs:
    output           flush,
    output           flowChange,
    output reg       stall,
    output reg [1:0] id_forwardA,
    output reg [1:0] id_forwardB,
	 output reg       id_eqFwdA,
	 output reg       id_eqFwdB,
    output reg       id_ldstBypass
);

assign flush = (branch && brTaken && ~stall) | jump;

assign flowChange = flush;

// No bypassing:
initial begin
    id_forwardA = 2'b00;  // select register from reg file
    id_forwardB = 2'b00;  // select register from reg file
    id_eqFwdA = 0;
    id_eqFwdB = 0;
    id_ldstBypass = 0;
end

/*
// Forwarding control for operand A (rs)
// 2'b00 - reg file
// 2'b10 - from mem to ex
// 2'b01 - from wb  to ex
// Note: forwarding will happen at next cycle

always @(*) begin
    id_forwardA = 2'b00;  // select register from reg file
    
    if (   ex_regWrite    // Valid instruction producing result at EX
        && (ex_rd === rs) // EX target is our source
        && readsRs        // this is not a j
        && (rs != 5'h0))  // not reading $zero
        id_forwardA = 2'b10;
    else if (   mem_regWrite    // Valid instruction producing result at MEM
             && (mem_rd === rs) // MEM target is our source
             && readsRs         // this is not a j
             && (rs != 5'h0))   // not reading $zero
        id_forwardA = 2'b01;
end

//  This is only needed for R-types or SW.
//  However, as the immediate mux is after the bypass mux,
//   we don't care about forwardB when rt is not used as a source (e.g. addi, lw)
always @(*) begin
    id_forwardB = 2'b00;  // select register from reg file

    if (   ex_regWrite    // Valid instruction producing result at EX
        && (ex_rd === rt) // EX target is our source
        && readsRt        // we do read rt (e.g. this is not a lui)
        && (rt != 5'h0))  // not reading $zero
        id_forwardB = 2'b10;
    else if (   mem_regWrite    // Valid instruction producing result at MEM
             && (mem_rd === rt) // MEM target is our source
             && readsRt        // we do read rt (e.g. this is not a lui)
             && (rt != 5'h0))   // not reading $zero
        id_forwardB = 2'b01;
end

// Forwarding logic to equality comparator of ID  (input A)
always @(*) begin

    id_eqFwdA = ((rs === mem_rd)   // MEM target is our source
	      && (rs != 5'h0)       // not $zero
	      && !mem_isLoad        // not a load -- can't bypass, will stall
              && mem_regWrite);      // valid instruction at MEM

end

// Forwarding logic to equality comparator of ID  (input B)
always @(*) begin
    id_eqFwdB = ((rt === mem_rd)   // MEM target is our source
	      && (rt != 5'h0)       // not $zero
	      && !mem_isLoad        // not a load -- can't bypass, will stall
              && mem_regWrite);      // valid instruction at MEM
end

// Forward just loaded value to subsequent store
// E.g.
// lw $t0, 0($s0)
// sw $t0, 0($s1)
always @(*) begin
    id_ldstBypass = isStore         // SW at ID
                 && ex_isLoad       // LW at EX
                 && ex_regWrite     // LW at EX is valid
                 && (rt === ex_rd)  // SW reg is the same as prev. LW destination reg
                 && (rt != 5'h0);   // SW reg is not $zero
end
*/

always @(*) begin
    stall = 1'b0;  // Normally, there's no stalling.


    // Conservative stalling. NO BYPASSING, except internally in register file


    // Stalls for data dependence on rs:
    if (
         (   (   ex_regWrite     // Valid instruction at EX
              && (rs === ex_rd))  // Same register
          || (   mem_regWrite     // Valid instruction at MEM
              && (rs === mem_rd)) // Same register
         )
        && (rs != 5'h0)    // rs is not $zero
        && readsRs         // rs is actually read. Not: lui, j, or nop
        && !isNop)  // Not a nop (flushed instruction)
        stall = 1'b1;

    // Stalls for data dependence on rt:
    if (
         (   (   ex_regWrite     // Valid instruction at EX
              && (rt === ex_rd))  // Same register
          || (   mem_regWrite     // Valid instruction at MEM
              && (rt === mem_rd)) // Same register
         )
        && (rt != 5'h0)    // rs is not $zero
        && readsRt         // rt is actually read. Not: lui, j, or nop
        && !isNop)  // Not a nop (flushed instruction)
        stall = 1'b1;

    // No Extra stalls for branch @ stage ID. It is covered from the code above.
    //  if there is dependence on instruction @ stage WB, the value is forwarded automatically
    //  inside the register file.


/*
// Normal stall with passing:
    // branch sources not ready. beq too close to producer of rs or rt
    if (branch && !isNop) begin
        // -- rs
        if (rs != 5'h0   // Not $zero
            && (   ((rs === ex_rd)  && ex_regWrite)   // rs comes from prev instruction
                || ((rs === mem_rd) && mem_isLoad && mem_regWrite)  // rs comes from instruction -2 which is a load
               ) // instr -3 is at WB, so it bypassed new value through regFile
           )
            stall = 1'b1;
        // -- rt
        if (rt != 5'h0   // Not $zero
            && (   ((rt === ex_rd)  && ex_regWrite)   // rt comes from prev instruction
                || ((rt === mem_rd) && mem_isLoad && mem_regWrite)  // rt comes from instruction -2 which is a load
               ) // instr -3 is at WB, so it bypassed new value through regFile
           )
            stall = 1'b1;
    end

    // --------- load-use stall
    // Consumer is rs
    if (   ex_isLoad
        && ex_regWrite  // Valid load at EX  (might not be required...)
        && (rs === ex_rd)  // Same register
        && (rs != 5'h0)    // rs is not $zero
           // rs is actually read. Not: lui, j, or nop
        && readsRs
        && !isNop)  // Not a nop (flushed instruction)
        stall = 1'b1;
    // Consumer is rt
    if (   ex_isLoad
        && ex_regWrite  // Valid load at EX  (might not be required...)
        && (rt === ex_rd)  // Same register
        && (rt != 5'h0)    // rs is not $zero
           // rt is actually used! Not: lui, j, addi, addiu, ori, lw,  nop
        && readsRt  // the instruction does read rt 
        && !isStore //   ***** except for sw, which can bypass it!
        && !isNop)  // Not a nop (flushed instruction)
        stall = 1'b1;
*/
end

endmodule
