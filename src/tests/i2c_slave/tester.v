module tester(
	output reg [7:0] Q,
	output reg SDA,
	output reg SCL,
	output reg ENB,
	output reg RESET
);

integer PLAN;

initial
	begin
	PLAN = 2;
	case (PLAN)
	1:
	begin
	#20
	RESET = 1;
	#20
	RESET = 0;
	Q=8'b10101001;
	ENB = 1;
	SCL = 1;
	SDA = 1;
	#20
	SDA = 0;
	#20
	SCL = 0;
	
	#7
	SDA = 1;
	#10
	SCL = 1; //b7
	#10
	SCL = 0;
	#10 
	SCL = 1; //b6
	#10
	SCL = 0;
	
	#10
	SDA = 0;
	#10
	SCL = 0;
	#10
	SCL = 1; //b5
	#10
	SCL = 0;
	#10 
	SCL = 1; //b4
	#10
	SCL = 0;
	#10
	SCL = 1; //b3
	#10
	SCL = 0;	
	#10
	SCL = 1; //b2
	#10
	SCL = 0;
	#10 
	SCL = 1; //b1
	#10
	SCL = 0;
	#10
	SCL = 1; //b0 RW
	#10
	SCL = 0;
	#10
	SCL = 0;
	#10
	SCL = 1; //ACK
	#10
	SCL = 0;
	
	// writes 10111000
	#10
	SDA = 1;
	#10
	SCL = 1; //b7
	#10
	SCL = 0;
	#10 
	SDA = 0;
	#10
	SCL = 1; //b6
	#10
	SCL = 0;
	#10
	SDA = 1;
	#10
	SCL = 0;
	#10
	SCL = 1; //b5
	#10
	SCL = 0;
	#10 
	SCL = 1; //b4
	#10
	SCL = 0;
	#10
	SCL = 1; //b3
	#10
	SCL = 0;
	#10
	SDA = 0;	
	#10
	SCL = 1; //b2
	#10
	SCL = 0;
	#10 
	SCL = 1; //b1
	#10
	SCL = 0;
	#20
	SDA = 1;
	#10
	SCL = 1; //b0 
	#10
	SCL = 0;
	#10
	SDA = 0;
	#10
	SCL = 1; //ACK
	#10
	SCL = 0;
	
	#20
	SCL = 1;
	#5
	SDA = 0;
	#5
	SDA = 1;
	end
	
	2:
	begin
	#20
	RESET = 1;
	#20
	RESET = 0;
	Q=8'b10111110;
	ENB = 1;
	SCL = 1;
	SDA = 1;
	#20
	SDA = 0;
	#20
	SCL = 0;
	
	#7
	SDA = 1;
	#10
	SCL = 1; //b7
	#10
	SCL = 0;
	#10 
	SCL = 1; //b6
	#10
	SCL = 0;
	
	#10
	SDA = 0;
	#10
	SCL = 0;
	#10
	SCL = 1; //b5
	#10
	SCL = 0;
	#10 
	SCL = 1; //b4
	#10
	SCL = 0;
	#10
	SCL = 1; //b3
	#10
	SCL = 0;	
	#10
	SCL = 1; //b2
	#10
	SCL = 0;
	#10 
	SCL = 1; //b1
	#10
	SCL = 0;
	#10
	SDA = 1;
	#10
	SCL = 1; //b0 RW
	#10
	SCL = 0;
	#10
	SDA = 0;
	#10
	SCL = 0;
	#10
	SCL = 1; //ACK
	#10
	SCL = 0;
	#5
	
	// reads Q
	#10
	SDA = 1'hz;
	#10
	SCL = 1; //b7
	#10
	SCL = 0;
	#10 
	SCL = 1; //b6
	#10
	SCL = 0;
	#10
	SCL = 0;
	#10
	SCL = 1; //b5
	#10
	SCL = 0;
	#10 
	SCL = 1; //b4
	#10
	SCL = 0;
	#10
	SCL = 1; //b3
	#10
	SCL = 0;	
	#10
	SCL = 1; //b2
	#10
	SCL = 0;
	#10 
	SCL = 1; //b1
	#10
	SCL = 0;
	#10
	SCL = 1; //b0 
	#10
	SCL = 0;
	#10
	SDA = 0;
	#10
	SCL = 1; //ACK
	#10
	SCL = 0;
	#5
	SDA = 1'hz;
	
	#20
	SCL = 1;
	#5
	SDA = 0;
	#20
	SDA = 1;
	end
	
	endcase
	
	end
endmodule
