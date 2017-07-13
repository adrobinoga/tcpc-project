module ProbadorTX(
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
output reg Clock;
output reg Reset;
output reg[15:0] TRANSMIT;
output reg[7:0] TRANSMIT_HEADER_LOW;
output reg[7:0] TRANSMIT_HEADER_HIGH;
output reg[223:0] TRANSMIT_DATA_OBJECTS;
output reg MessageSentToPhy;
output reg GoodCRCResponse;
output reg[7:0] nRetryCount;
output reg[7:0] TX_BUF_HEADER_BYTE_1;
output reg[7:0] RX_BUF_HEADER_BYTE_1;
output reg[7:0] RX_BUF_FRAME_TYPE;
output reg DFP, UFP;

//---------SALIDAS-------------
input Alert_MessageSuccessful;
input Alert_MessageFailed;
input [239:0] TRANSMIT_DATA_OUTPUT;

initial 
begin
	Clock = 0;
	Reset = 1;
	TRANSMIT = 10;
	TRANSMIT_HEADER_LOW = 123;
	TRANSMIT_HEADER_HIGH = 123;
	TRANSMIT_DATA_OBJECTS = 123;
	MessageSentToPhy = 1;
	GoodCRCResponse = 1;
	nRetryCount = 3;
	TX_BUF_HEADER_BYTE_1 = 222;
	RX_BUF_HEADER_BYTE_1 = 222;
	RX_BUF_FRAME_TYPE = 101;
	DFP = 1;
	UFP = 1;
	
	#10 Reset = 0;
	#50 TRANSMIT = 2;
end

always #5 Clock=~Clock;

endmodule