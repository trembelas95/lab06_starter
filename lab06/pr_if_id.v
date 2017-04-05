module pr_if_id(
    input             clk, reset,
    input             loadEn,
    input      [31:0] pcf,
    input      [31:0] if_instr,
    output reg [31:0] pcSeq,
    output reg [31:0] id_instr
);

  always @(posedge clk or posedge reset) begin
      if (reset)
          // No need to reset PC. Instruction is nop anyway.
          id_instr <= 32'h0;  // Nop instruction : sll $zero, $zero, $zero
      else if (loadEn)
          id_instr <= #10 if_instr;
  end

  always @(posedge clk) begin
      if (loadEn)
          pcSeq    <= #10 pcf;
  end
endmodule
