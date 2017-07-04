module tx(	
	output reg PassBytes,
	input reset,
	input clk
	);

//cantidad de bits por cantidad de estados que se tiene

localparam Tx_Wait_for_Transmit_Request = 8'b00000000;
localparam Tx_Reset_RetryCounter = 8'b00000010;
localparam Tx_Check_RetryCounter = 8'b00000100;
localparam Tx_Construct_Message = 8'b00001000;
localparam Tx_Wait_for_PHY_response = 8'b00010000;
localparam Tx_Report_Failure = 8'b00100000;
localparam Tx_Report_Success = 8'b01000000;
localparam Tx_Match_MessageID = 8'b10000000;

//ff(clock)
//logica prox estado(*)
//logica salida always(*)

reg MID_Match;
reg MessageSentToPhy;
reg GoodCRCResponse;
reg CRC_RT_Timeout;
reg MessageDiscardedBusIdle;
reg RetryCounter;
reg nRetryCount;
reg GoodCRCMessageID;
reg SOPmatch;
reg TX_BUF_HEADER_BYTE_1;
reg RX_BUF_HEADER_BYTE_1;
reg[2:0] RX_BUF_FRAME_TYPE;

reg[2:0] CurrentState;
reg[2:0] NextState;
reg[2:0] TRANSMIT;

input wire DFP, UFP;
input wire MessageIDCounter;
input wire MessageID;

output reg InitCRCReceiveTimer;
output reg Alert_MessageSuccessful;
output reg Alert_MessageFailed;

always@(*) begin
  NextState = CurrentState;
  case (CurrentState)
    default: NextState = CurrentState;
    Tx_Wait_for_Transmit_Request: begin
      if(TRANSMIT < 3'b101) NextState = Tx_Reset_RetryCounter;
      else NextState = Tx_Wait_for_Transmit_Request;
      end
    Tx_Reset_RetryCounter: begin
      NextState =  Tx_Construct_Message;
      end
    Tx_Check_RetryCounter: begin
        if (RetryCounter > nRetryCount) NextState = Tx_Report_Failure;
        else NextState = Tx_Construct_Message;
      end
    Tx_Construct_Message: begin
        if (MessageSentToPhy) NextState = Tx_Wait_for_PHY_response;
        else NextState = Tx_Construct_Message;
      end
    Tx_Wait_for_PHY_response: begin
        if (GoodCRCResponse) NextState = Tx_Match_MessageID;
        else if (CRC_RT_Timeout | MessageDiscardedBusIdle) NextState =  Tx_Check_RetryCounter;
      end
    Tx_Report_Failure: begin
        NextState = Tx_Wait_for_Transmit_Request;
      end
    Tx_Report_Success: begin
      NextState = Tx_Wait_for_Transmit_Request;
      end
    Tx_Match_MessageID: begin
      if ((TX_BUF_HEADER_BYTE_1 != RX_BUF_HEADER_BYTE_1) | (TRANSMIT != RX_BUF_FRAME_TYPE)) NextState = Tx_Check_RetryCounter;
      else if (GoodCRCMessageID & SOPmatch) NextState = Tx_Report_Success;
      end
  endcase
end


always@ (*) begin
	case (CurrentState)
		Tx_Reset_RetryCounter: begin
			RetryCounter = 0;
		end
		Tx_Construct_Message: begin
			PassBytes = 1'b1;
		end
		Tx_Wait_for_PHY_response: begin
			InitCRCReceiveTimer = 1'b1;
		end
		Tx_Report_Success: begin
			Alert_MessageSuccessful = 1'b1;
		end
		Tx_Report_Failure: begin
			Alert_MessageFailed = 1'b1;
		end
		Tx_Check_RetryCounter: begin
			if((DFP == 1'b1) | (UFP == 1'b1))
				RetryCounter = RetryCounter + 1;
			else RetryCounter = RetryCounter;
		end
		Tx_Match_MessageID: begin
			if(MessageIDCounter == MessageID) MID_Match = 1'b1;
			else MID_Match = 1'b0;
		end
	endcase
end


always @(posedge clk) 
	begin
	if (reset)
		CurrentState <= Tx_Wait_for_Transmit_Request;
	else 
		CurrentState <= NextState;
	end
	
endmodule
