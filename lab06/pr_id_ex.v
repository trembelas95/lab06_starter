module pr_id_ex(
    input             clk, reset,
    input      [31:0] id_rdA,
    input      [31:0] id_rdB,
    input      [31:0] id_imm,    
    // control signals for EX stage
    input             id_isLoad,
    input       [2:0] id_alucont,
    input             id_aluSrc,
    input       [1:0] id_forwardA,
    input       [1:0] id_forwardB,
    // control signals for MEM stage
    input             id_memWrite,
    input             id_ldstBypass,
    // control signals for WB stage
    input             id_memToReg,
    input       [4:0] id_rd,
    input             id_regWrite,
    // Data outputs
    output reg [31:0] ex_rdA,
    output reg [31:0] ex_rdB,
    output reg [31:0] ex_imm,
    // control signals for EX stage
    output reg        ex_isLoad,
    output reg  [2:0] ex_alucont,
    output reg        ex_aluSrc,
    output reg  [1:0] ex_forwardA,
    output reg  [1:0] ex_forwardB,
    // control signals for MEM stage
    output reg        ex_memWrite,
    output reg        ex_ldstBypass,
    // control signals for WB stage
    output reg        ex_memToReg,
    output reg  [4:0] ex_rd,
    output reg        ex_regWrite
);

always @(posedge clk, posedge reset)
    if (reset) begin
        // I don't care about any other signals
        //  Leave them unknown - x
        ex_rd       <= 5'h0;  // Destination register is $zero
        ex_regWrite <= 1'b0;  // Don't write any registers
        ex_memWrite <= 1'b0;  // Don't write to Data memory
    end else begin
        ex_rdA        <= #10 id_rdA;
        ex_rdB        <= #10 id_rdB;
        ex_imm        <= #10 id_imm;
        // --- for EX ---
        ex_isLoad     <= #10 id_isLoad;
        ex_alucont    <= #10 id_alucont;
        ex_aluSrc     <= #10 id_aluSrc;
        ex_forwardA   <= #10 id_forwardA;
        ex_forwardB   <= #10 id_forwardB;
        // --- for MEM ---
        ex_memWrite   <= #10 id_memWrite;
        ex_ldstBypass <= #10 id_ldstBypass;
        // --- for WB ---
        ex_memToReg   <= #10 id_memToReg;
        ex_rd         <= #10 id_rd;
        ex_regWrite   <= #10 id_regWrite;
    end
endmodule
