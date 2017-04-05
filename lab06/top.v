module top;

reg clk;
reg reset;

integer cycle_counter;

mips duv(
  .clk(clk),
  .reset(reset)
);

initial begin
    cycle_counter = 1;
    clk = 0;
    reset = 1;
    #100   reset = 0;
    #900000 $finish;   // catch infinite loops!
end

always 
   #200 clk = ~clk;

always @(posedge clk)
    cycle_counter = cycle_counter + 1;

endmodule
