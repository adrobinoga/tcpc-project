module testbench;

reg clk;

tester t (

);

tx uut (

);

initial begin
    
  //-- Fichero donde almacenar los resultados
  $dumpfile("testbench.vcd");
  $dumpvars(0, testbench);
  
  clk = 0;  
  # 100 $display("FIN TestBench");
  $finish;
end

always #5 clk = ~clk;

endmodule

