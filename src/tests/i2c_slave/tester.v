
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
	PLAN = 1;
	case (PLAN)
	1:
		begin
		#20
		RESET = 1;
		SDA = 0;
		SCL = 0;
		ENB = 0;
		Q=8'b10101001;
		#20
		RESET = 1;
		#20
		RESET = 0;
	
		I2C.WRITE( c0,31 43  ff , 20)
		I2C.WRITE( a0, 4 , 20)
		I2C.WRITE( c0, 6 , 20)
		end
	
	2:
		begin
		#20
		RESET = 1;
		SDA = 0;
		SCL = 0;
		ENB = 0;
		Q=8'b10101001;
		#20
		RESET = 1;
		#20
		RESET = 0;
		
		I2C.READ(C0, 2, 20)
		end
	
	endcase
	
	end
endmodule
