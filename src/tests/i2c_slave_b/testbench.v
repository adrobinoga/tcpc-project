`timescale 1ns/1ps

module testbench;

reg CLK;
wire [7:0] D;
wire SDA;
wire SCL;
wire ENB;
wire RESET;
wire D_ready;
wire [7:0] Q;

// i2c slave
i2c_slave uut (	.D(D),
		.D_ready(D_ready),
		.SDA(SDA),
		.SCL(SCL),
		.Q(Q),
		.CLK(CLK),
		.ENB(ENB),
		.RESET(RESET)
		);

// instancia probador
tester t (	.Q(Q),
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

always #1 CLK=~CLK;

initial #5000 $finish;

endmodule
