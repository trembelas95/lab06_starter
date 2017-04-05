module pr_ex_mem(
    input             clk, reset,
    input      [31:0] ex_aluOut,
    input      [31:0] ex_src2,    
    // control signals for MEM stage
    input             ex_isLoad,
    input             ex_memWrite,
    input             ex_ldstBypass,
    // control signals for WB stage
    input             ex_memToReg,
    input       [4:0] ex_rd,
    input             ex_regWrite,
    // Data outputs
    output reg [31:0] mem_aluOut,
    output reg [31:0] mem_src2,
    // control signals for MEM stage
    output reg        mem_isLoad,
    output reg        mem_memWrite,
    output reg        mem_ldstBypass,
    // control signals for WB stage
    output reg        mem_memToReg,
    output reg  [4:0] mem_rd,
    output reg        mem_regWrite
);

always @(posedge clk, posedge reset)
    if (reset) begin
        // I don't care about the data signals, memToReg, mem_ldstBypass.
        //  Leave them unknown - x
        mem_rd       <= 5'h0;  // Destination register is $zero
        mem_regWrite <= 1'b0;  // Don't write any registers
        mem_memWrite <= 1'b0;  // Don't write to Data memory
    end else begin
        mem_src2       <= #10 ex_src2;
        mem_aluOut     <= #10 ex_aluOut;
        mem_memWrite   <= #10 ex_memWrite;
        mem_isLoad     <= #10 ex_isLoad;
        mem_ldstBypass <= #10 ex_ldstBypass;
        mem_memToReg   <= #10 ex_memToReg;
        mem_rd         <= #10 ex_rd;
        mem_regWrite   <= #10 ex_regWrite;
    end
endmodule
