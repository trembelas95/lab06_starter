module pr_mem_wb(
    input             clk, reset,
    input      [31:0] mem_aluOut,
    input      [31:0] mem_mo,    
    input             mem_memToReg,
    input       [4:0] mem_rd,
    input             mem_regWrite,
    output reg [31:0] wb_aluOut,
    output reg [31:0] wb_mo,
    output reg        wb_memToReg,
    output reg  [4:0] wb_rd,
    output reg        wb_regWrite
);

always @(posedge clk, posedge reset)
    if (reset) begin
        // I don't care about the data signals and memToReg. Leave them x
        wb_rd       <= 5'h0;
        wb_regWrite <= 1'b0;
    end else begin
        wb_mo       <= #10 mem_mo;
        wb_aluOut   <= #10 mem_aluOut;
        wb_memToReg <= #10 mem_memToReg;
        wb_rd       <= #10 mem_rd;
        wb_regWrite <= #10 mem_regWrite;
    end
endmodule
