`timescale 1ns/1ps

module testbench;

reg CLK;

// unidad bajo prueba
tcpc uut (	);

// instancia probador
tester t (	);	

initial 
	begin
	$dumpfile("testbench.vcd");
	$dumpvars(0, testbench);
	CLK = 0;
	end

always #5 CLK=~CLK;

initial #10000 $finish;

endmodule
