module tx(	
	output reg PassBytes,
	input [7:0] TRANSMIT,
	input [7:0] TX_BUF_HEADER_BYTE_1,
	input [7:0] RX_BUF_HEADER_BYTE_1,
	input [7:0] RX_BUF_FRAME_TYPE,
	input MessageSenToPhy,
	input GoodCRCResponse,
	input CRC_RT_Timeout,
	input MessageDiscardedBusIdle,
	input reset,
	input clk
	);

//cantidad de bits por cantidad de estados que se tiene
localparam Tx_Wait_for_Transmit_Request = 	8'b00000001;
localparam Tx_Reset_RetryCounter = 		8'b00000010;
localparam Tx_Check_RetryCounter = 		8'b00000100;
localparam Tx_Construct_Message = 		8'b00001000;
localparam Tx_Wait_for_PHY_response = 		8'b00010000;
localparam Tx_Report_Failure = 			8'b00100000;
localparam Tx_Report_Success = 			8'b01000000;
localparam Tx_Match_MessageID = 		8'b10000000;

reg[7:0] current_state;
reg[7:0] next_state;

/*
reg MID_Match;
reg CRC_RT_Timeout;
reg MessageDiscardedBusIdle;
reg RetryCounter;
reg nRetryCount;
reg GoodCRCMessageID;
reg SOPmatch;
reg TX_BUF_HEADER_BYTE_1;
reg RX_BUF_HEADER_BYTE_1;
reg[2:0] RX_BUF_FRAME_TYPE;

input wire DFP, UFP;
input wire MessageIDCounter;
input wire MessageID;

output reg InitCRCReceiveTimer;
output reg Alert_MessageSuccessful;
output reg Alert_MessageFailed;
*/


// logica de proximo estado
always@(*) 
	begin
	next_state = current_state;
	case (current_state)

	Tx_Wait_for_Transmit_Request: 
		begin
		if(TRANSMIT[2:0] < 3'b101) 
			next_state = Tx_Reset_RetryCounter;
		else 
			next_state = Tx_Wait_for_Transmit_Request;
		end
		
	Tx_Reset_RetryCounter: 
		begin
		next_state =  Tx_Construct_Message;
		end
	
	Tx_Construct_Message: 
		begin
		if (MessageSentToPhy) 
			next_state = Tx_Wait_for_PHY_response;
		else 
			next_state = Tx_Construct_Message;
		end
		
	Tx_Wait_for_PHY_response: 
		begin
		if (GoodCRCResponse) 
			next_state = Tx_Match_MessageID;
		else 
			if (CRC_RT_Timeout | MessageDiscardedBusIdle) 
				next_state =  Tx_Check_RetryCounter;
		end
		
	Tx_Check_RetryCounter: 
		begin
		if (RetryCounter > nRetryCount) 
			next_state = Tx_Report_Failure;
		else 
			next_state = Tx_Construct_Message;
		end
	
	Tx_Report_Failure: 
		begin
		next_state = Tx_Wait_for_Transmit_Request;
		end
	
	Tx_Match_MessageID: 
		begin
		if ((TX_BUF_HEADER_BYTE_1 != RX_BUF_HEADER_BYTE_1) |
			 (TRANSMIT[2:0] != RX_BUF_FRAME_TYPE)) 
			next_state = Tx_Check_RetryCounter;
		else 
			if (GoodCRCMessageID & SOPmatch) 
				next_state = Tx_Report_Success;
		end
		
	Tx_Report_Success: 
		begin
		next_state = Tx_Wait_for_Transmit_Request;
		end
		
	default: next_state = current_state;
	
	endcase
	end


// logica de salidas
always@ (*) begin
	case (current_state)
		Tx_Wait_for_Transmit_Request: 
			begin
			
			end
			
		Tx_Reset_RetryCounter: 
			begin
			RetryCounter = 0;
			end
		
		Tx_Construct_Message: 
			begin
			PassBytes = 1'b1;
			end
		
		Tx_Wait_for_PHY_response: 
			begin
			InitCRCReceiveTimer = 1'b1;
			end

		Tx_Report_Success: 
			begin
			Alert_MessageSuccessful = 1'b1;
			end

		Tx_Report_Failure: 
			begin
			Alert_MessageFailed = 1'b1;
			end

		Tx_Check_RetryCounter: 
			begin
			if((DFP == 1'b1) | (UFP == 1'b1))
				RetryCounter = RetryCounter + 1;
			else RetryCounter = RetryCounter;
			end
			
		Tx_Match_MessageID: 
			begin
			if(MessageIDCounter == MessageID) MID_Match = 1'b1;
			else MID_Match = 1'b0;
			end
	endcase
end

// memoria de estado
always @(posedge clk) 
	begin
	if (reset)
		current_state <= Tx_Wait_for_Transmit_Request;
	else 
		current_state <= next_state;
	end
	
endmodule
