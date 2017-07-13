module TX(
Clock,
Reset,
TRANSMIT,
TRANSMIT_HEADER_LOW,
TRANSMIT_HEADER_HIGH,
TRANSMIT_DATA_OBJECTS,
MessageSentToPhy,
GoodCRCResponse,
nRetryCount,
TX_BUF_HEADER_BYTE_1,
RX_BUF_HEADER_BYTE_1,
RX_BUF_FRAME_TYPE,
DFP,
UFP,
Alert_MessageSuccessful,
Alert_MessageFailed,
TRANSMIT_DATA_OUTPUT
);

//---------ENTRADAS-------------
input Clock;
input Reset;
input[15:0] TRANSMIT;
input[7:0] TRANSMIT_HEADER_LOW;
input[7:0] TRANSMIT_HEADER_HIGH;
input[223:0] TRANSMIT_DATA_OBJECTS;
input MessageSentToPhy;
input GoodCRCResponse;
input[7:0] nRetryCount;
input[7:0] TX_BUF_HEADER_BYTE_1;
input[7:0] RX_BUF_HEADER_BYTE_1;
input[7:0] RX_BUF_FRAME_TYPE;
input DFP, UFP;

//---------SALIDAS-------------
output reg Alert_MessageSuccessful;
output reg Alert_MessageFailed;
localparam T_SIZE = 239;
output reg [T_SIZE:0] TRANSMIT_DATA_OUTPUT;

//---------REGISTROS INTERNOS-------
reg[7:0] CurrentState;
reg[7:0] NextState;
reg[7:0] RetryCounter;
reg InitCRCReceiveTimer;
reg[1:0] CRCReceiveTimer;

//---------ESTADOS-----------------
localparam Tx_Wait_for_Transmit_Request = 8'b00000001;
localparam Tx_Reset_RetryCounter = 8'b00000010;
localparam Tx_Check_RetryCounter = 8'b00000100;
localparam Tx_Construct_Message = 8'b00001000;
localparam Tx_Wait_for_PHY_response = 8'b00010000;
localparam Tx_Report_Failure = 8'b00100000;
localparam Tx_Report_Success = 8'b01000000;
localparam Tx_Match_MessageID = 8'b10000000;

//---------CONDICIONES INICIALES-------
initial begin
	CurrentState = 8'b1;
	NextState = 8'b1;
	RetryCounter = 8'b0;
	InitCRCReceiveTimer = 1'b0;
	Alert_MessageSuccessful = 1'b0;
	Alert_MessageFailed = 1'b0;
	CRCReceiveTimer = 2'b0;
end

//-------------------------------------------------------------------
//------------------Lógica de próximo estado ------------------------
//-------------------------------------------------------------------
always@(*) begin
	NextState = CurrentState;
	
	case (CurrentState)
		default: NextState = CurrentState;
	
		Tx_Wait_for_Transmit_Request:
			begin
			if (TRANSMIT[2:0] <= 3'b101) NextState = Tx_Reset_RetryCounter;
			else NextState = Tx_Wait_for_Transmit_Request;
			end
			
		Tx_Reset_RetryCounter:
			begin
			NextState =  Tx_Construct_Message;
			end
			
		Tx_Check_RetryCounter: 
			begin
			if (RetryCounter > nRetryCount) NextState = Tx_Report_Failure;
			else NextState = Tx_Construct_Message;
			end
			
		Tx_Construct_Message:
			begin
			if (MessageSentToPhy) NextState = Tx_Wait_for_PHY_response;
			else NextState = Tx_Construct_Message;
			end
			
		Tx_Wait_for_PHY_response: 
			begin
			if (CRCReceiveTimer == 'b11) NextState =  Tx_Check_RetryCounter;
			else
				begin
				if (GoodCRCResponse) NextState = Tx_Match_MessageID;
				else NextState = Tx_Wait_for_PHY_response;
				end
			end
			
		Tx_Report_Failure: 
			begin
			NextState = Tx_Wait_for_Transmit_Request;
			end
			
		Tx_Report_Success: 
			begin
			NextState = Tx_Wait_for_Transmit_Request;
			end
		  
		Tx_Match_MessageID:
			begin
			if ((TX_BUF_HEADER_BYTE_1 != RX_BUF_HEADER_BYTE_1) || (TRANSMIT[2:0] != RX_BUF_FRAME_TYPE)) 
				begin
				NextState = Tx_Check_RetryCounter;
				end
			else NextState = Tx_Report_Success;
			end
	endcase
end

//-------------------------------------------------------------------
//------------------Lógica de acciones-------------------------------
//-------------------------------------------------------------------
always@ (*) begin
	case (CurrentState)

		Tx_Reset_RetryCounter: 
			begin
			RetryCounter = 2'b00;
			end
			
		Tx_Construct_Message: 
			begin
			TRANSMIT_DATA_OUTPUT [239:232] = TRANSMIT_HEADER_HIGH;
			TRANSMIT_DATA_OUTPUT [231:224] = TRANSMIT_HEADER_LOW;
			TRANSMIT_DATA_OUTPUT [223:0] = TRANSMIT_DATA_OBJECTS;
			end
			
		Tx_Wait_for_PHY_response: 
			begin
			if (CRCReceiveTimer < 2'b11) InitCRCReceiveTimer = 1'b1;
			else InitCRCReceiveTimer = 1'b0;
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
			if((DFP == 1'b1) || (UFP == 1'b1)) 
				begin 
				RetryCounter = RetryCounter + 1;
				end
			else 
				begin
				RetryCounter = RetryCounter;
				end
			end
			
		Tx_Match_MessageID: 
			begin
			InitCRCReceiveTimer = 1'b0;
			end
			
	endcase
end


always@(posedge Clock) begin
	
	if (Reset) CurrentState <= Tx_Wait_for_Transmit_Request;
	else CurrentState <= NextState;
	
	if (InitCRCReceiveTimer) CRCReceiveTimer <= CRCReceiveTimer + 1;
	else CRCReceiveTimer <= CRCReceiveTimer;
	
end

endmodule
