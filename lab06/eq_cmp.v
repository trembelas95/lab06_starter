module eq_cmp(
    input  [31:0] rA,
    input  [31:0] rB,
    output        eq
);
    assign #10 eq = (rA === rB);
endmodule
