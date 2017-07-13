`timescale 1ns/1ps

module testbench;

reg CLK;
wire RESET;
wire SCL;
wand SDA;
assign SDA = 1 ;

// unidad bajo prueba
tcpc uut (
	.CLK(CLK),
	.RESET(RESET),
	.SCL(SCL),
	.SDA(SDA)
);

// instancia probador
tester t (
	.SDA(SDA),
	.SCL(SCL),
	.ENB(ENB),
	.RESET(RESET)		
);

initial 
	begin
	$dumpfile("testbench.vcd");
	$dumpvars(0, testbench);
	CLK = 0;
	end

always #5 CLK=~CLK;

initial #100000 $finish;

endmodule
