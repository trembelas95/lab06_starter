module maindec(
    input      [5:0] op,    // opcode field of instruction [31:26]
    input      [5:0] funct, // funct field of R-type instructions [5:0]
    output reg       branch,
    output reg       jump,
    output reg       lui,
    output reg       isLoad,
    output reg       isStore,
    output reg       isNop,   // this is all 0s and it is sll $zero, $zero, $zero.
    output reg       readsRs, // the instruction reads 1st source register (rs). Used for stall detection
    output reg       readsRt, // the instruction reads 2nd source register (rt). Used for stall detection
    output reg       memwrite,
    output reg       regwrite,
    output reg       memtoreg,
    output reg       regdst,
    output reg [2:0] alucontrol,
    output reg       alusrc
);

  // Implemented instructions:
  // lw, sw
  // beq, j
  // addi, addiu,
  // ori,
  // lui,
  // add, sub, and, or, slt, 
  always @(*) begin
    // default values for signals:
    branch     = 1'b0;
    jump       = 1'b0;
    lui        = 1'b0;
    isLoad     = 1'b0;
    isStore    = 1'b0;
    isNop      = 1'b0;
    readsRs    = 1'b1; // Most instructions read rs. Will be cleared later if not read
    readsRt    = 1'b0;
    memwrite   = 1'b0; // Don't write to data memory
    regwrite   = 1'b0; // Don't write result to register file
    memtoreg   = 1'bx; // Result mux: don't care
    regdst     = 1'b0;   // destination register: don't care, but set to 0
                         //   for simplicity
    alucontrol = 3'bxxx; // ALU op: don't care!
    alusrc     = 1'bx;   // 2nd ALU src: don't care
    case(op)
      6'b000000: begin  // ------- RTYPE ----------------------
          regwrite  = 1'b1;  // all implemented R-type instructions store result
          regdst   = 1'b1;  // rd is destination register
          memtoreg = 1'b0;  // AluOut to be stored to regFile
          alusrc   = 1'b0;  // 2nd ALU src is register value
          readsRt  = 1'b1;
          case(funct) 
          6'b100000: alucontrol = 3'b010; // ADD
          6'b100010: alucontrol = 3'b110; // SUB
          6'b100100: alucontrol = 3'b000; // AND
          6'b100101: alucontrol = 3'b001; // OR
          6'b101010: alucontrol = 3'b111; // SLT
          6'b000000: begin 
                       isNop = 1'b1; // SLL - I assume this is a nop even
                                   //   if rs, rt, rd are not $zero !!!!!!
                                   // Used as nop after pipe flushing
                       regwrite = 1'b0;
                     end
          default:   alucontrol = 3'bxxx; // ???
          endcase
      end
      6'b100011: begin // ---------- LW -----------------------
          isLoad     = 1'b1;
          regwrite    = 1'b1;   // write result to register file
          regdst     = 1'b0;   // rt is destination register
          memtoreg   = 1'b1;   // wire result is mem output
          alusrc     = 1'b1;   // 2nd ALU src is immediate
          alucontrol = 3'b010; // ALU add
      end
      6'b101011: begin // ---------- SW -----------------------
          isStore    = 1'b1;
          memwrite   = 1'b1;   // Write to data memory
          alusrc     = 1'b1;   // 2nd ALU src is immediate
          alucontrol = 3'b010; // ALU add
          readsRt    = 1'b1;
      end
      6'b000100: begin // ---------- BEQ ----------------------
          branch  = 1'b1;
          readsRt = 1'b1;
      end
      6'b001000, 6'b001001: begin // ---- ADDI, ADDIU  ------ 
                                  //  same as addi - ignore overflows
          regwrite    = 1'b1;   // write result to register file
          regdst     = 1'b0;   // rt is destination register
          memtoreg   = 1'b0;   // wire result is ALU output
          alusrc     = 1'b1;   // 2nd ALU src is immediate
          alucontrol = 3'b010; // ALU add
      end
      6'b000010: begin // ----------- J -----------------------
          jump    = 1'b1;
          readsRs = 1'b0;   // Does not read rs
      end
      6'b001111: begin // ---------- LUI ----------------------
          lui        = 1'b1;
          regwrite    = 1'b1;   // write result to register file
          regdst     = 1'b0;   // rt is destination register
          memtoreg   = 1'b0;   // wire result is ALU output
          alusrc     = 1'b1;   // 2nd ALU src is immediate
          alucontrol = 3'b001; // ALU op: OR - could do add also
          readsRs    = 1'b0;   // Does not read rs
      end
      6'b001101: begin // ----------- ORI ---------------------
          regwrite    = 1'b1;   // write result to register file
          regdst     = 1'b0;   // rt is destination register
          memtoreg   = 1'b0;   // wire result is ALU output
          alusrc     = 1'b1;   // 2nd ALU src is immediate
          alucontrol = 3'b001; // ALU op: OR
      end
      // default case is covered by default values at the top of the always block
    endcase
  end
endmodule
