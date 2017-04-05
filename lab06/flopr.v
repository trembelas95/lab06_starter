module flopr  (
    input             clk, reset,
    input             loadEn,
    input      [31:0] d, 
    output reg [31:0] q
);

  always @(posedge clk, posedge reset)
    if (reset) 
        q <= #10 0;
    else if (loadEn)
        q <= #10 d;
endmodule
