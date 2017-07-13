
module tester(
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
		#50
		RESET = 1;
		SDA = 0;
		SCL = 0;
		ENB = 0;
		#50
		RESET = 1;
		#50
		RESET = 0;
	
		// writing single byte registers test
		I2C.WRITE( C0, 1A 63, 50) //ROLE_CONTROL
		I2C.WRITE( A0, 1B 86, 50)
		I2C.WRITE( C0, 1B 91, 50) //FAULT_CONTROL
		
		// reading single byte registers test
		I2C.WRITE( C0, 1A, 50, NOSTOP) //ROLE_CONTROL
		I2C.READ(C1, 1, 50)
		
		I2C.WRITE( C0, 1B, 50, NOSTOP) //FAULT_CONTROL
		I2C.READ(C1, 1, 50)
		
		end
	
	2:
		begin
		#50
		RESET = 1;
		SDA = 0;
		SCL = 0;
		ENB = 0;
		#50
		RESET = 1;
		#50
		RESET = 0;
		
		// writing multiple bytes
		I2C.WRITE( C0, 10 36 71, 50) //ALERT 
		
		// reading multiple bytes
		I2C.WRITE( C0, 10, 50, NOSTOP)
		I2C.READ(C1, 2, 50)
		end
	
	endcase
	
	end
endmodule
