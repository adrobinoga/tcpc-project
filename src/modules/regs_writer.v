module regs_writer(
	// entradas de control de los clientes
	input REQ_Tx,
	input REQ_Rx,
	input REQ_HReset,
	input REQ_tcpm,
	
	input RNW_Tx,
	input RNW_Rx,
	input RNW_HReset,
	input RNW_tcpm,
	
	input [7:0] ADDR_Tx,
	input [7:0] ADDR_Rx,
	input [7:0] ADDR_HReset,
	input [7:0] ADDR_tcpm,
	
	input [7:0] WR_DATA_Tx,
	input [7:0] WR_DATA_Rx,
	input [7:0] WR_DATA_HReset,
	input [7:0] WR_DATA_tcpm,
	
	// salidas para los clientes
	output reg [7:0] RD_DATA_Tx,
	output reg [7:0] RD_DATA_Rx,
	output reg [7:0] RD_DATA_HReset,
	output reg [7:0] RD_DATA_tcpm,
	
	output reg ACK_Tx, 
	output reg ACK_Rx,
	output reg ACK_HReset,
	output reg ACK_tcpm,	
		
	// control del los registros
	output reg [7:0] WR_DATA,
	output reg [7:0] ADDR,
	output reg REQUEST,
	output reg RNW,
	
	// retorno de los registros
	input ACK,
	input [7:0] RD_DATA	
);


always @(*)
	begin
	
	WR_DATA = 8'b0;
	ADDR = 8'b0;
	REQUEST = 1'b0;
	RNW = 1'b0;

	ACK_tcpm = 1'b0;
	ACK_HReset = 1'b0;
	ACK_Rx = 1'b0;
	ACK_Tx = 1'b0;
	
	RD_DATA_tcpm = 8'b0;
	RD_DATA_HReset = 8'b0;
	RD_DATA_Rx = 8'b0;
	RD_DATA_Tx = 8'b0;
	
	if (REQ_tcpm)
		begin
		// solicitud manager
		WR_DATA = WR_DATA_tcpm;
		ADDR = ADDR_tcpm;
		REQUEST = 1'b1;
		RNW = RNW_tcpm;
		
		// respuesta
		ACK_tcpm = ACK;
		RD_DATA_tcpm = RD_DATA;
		end
	else
		begin
		if (REQ_HReset)
			begin
			// solicitud HReset
			WR_DATA = WR_DATA_HReset;
			ADDR = ADDR_HReset;
			REQUEST = 1'b1;
			RNW = RNW_HReset;
		
			// respuesta
			ACK_HReset = ACK;
			RD_DATA_HReset = RD_DATA;
			end
		else
			begin
			if (REQ_Rx)
				begin
				// solicitud Rx
				WR_DATA = WR_DATA_Rx;
				ADDR = ADDR_Rx;
				REQUEST = 1'b1;
				RNW = RNW_Rx;
		
				// respuesta
				ACK_Rx = ACK;
				RD_DATA_Rx = RD_DATA;
				end
			else
				begin
				if (REQ_Tx)
					begin
					// solicitud Tx
					WR_DATA = WR_DATA_Tx;
					ADDR = ADDR_Tx;
					REQUEST = 1'b1;
					RNW = RNW_Tx;
		
					// respuesta
					ACK_Tx = ACK;
					RD_DATA_Tx = RD_DATA;
					end
				end
			end
		end
	end

endmodule
