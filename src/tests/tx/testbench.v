`include "ProbadorTX.v"
`include "TX_FINAL.v"

module Tx_tb;

wire Clock;
wire Reset;
wire[15:0] TRANSMIT;
wire[7:0] TRANSMIT_HEADER_LOW;
wire[7:0] TRANSMIT_HEADER_HIGH;
wire[223:0] TRANSMIT_DATA_OBJECTS;
wire MessageSentToPhy;
wire GoodCRCResponse;
wire[7:0] nRetryCount;
wire[7:0] TX_BUF_HEADER_BYTE_1;
wire[7:0] RX_BUF_HEADER_BYTE_1;
wire[7:0] RX_BUF_FRAME_TYPE;
wire DFP, UFP;
wire Alert_MessageSuccessful;
wire Alert_MessageFailed;
wire[239:0] TRANSMIT_DATA_OUTPUT;

TX T1(
	.Clock(Clock),
	.Reset(Reset),
	.TRANSMIT(TRANSMIT),
	.TRANSMIT_HEADER_LOW(TRANSMIT_HEADER_LOW),
	.TRANSMIT_HEADER_HIGH(TRANSMIT_HEADER_HIGH),
	.TRANSMIT_DATA_OBJECTS(TRANSMIT_DATA_OBJECTS),
	.MessageSentToPhy(MessageSentToPhy),
	.GoodCRCResponse(GoodCRCResponse),
	.nRetryCount(nRetryCount),
	.TX_BUF_HEADER_BYTE_1(TX_BUF_HEADER_BYTE_1),
	.RX_BUF_HEADER_BYTE_1(RX_BUF_HEADER_BYTE_1),
	.RX_BUF_FRAME_TYPE(RX_BUF_FRAME_TYPE),
	.DFP(DFP),
	.UFP(UFP),
	.Alert_MessageSuccessful(Alert_MessageSuccessful),
	.Alert_MessageFailed(Alert_MessageFailed),
	.TRANSMIT_DATA_OUTPUT(TRANSMIT_DATA_OUTPUT)
);

ProbadorTX P1(
	.Clock(Clock),
	.Reset(Reset),
	.TRANSMIT(TRANSMIT),
	.TRANSMIT_HEADER_LOW(TRANSMIT_HEADER_LOW),
	.TRANSMIT_HEADER_HIGH(TRANSMIT_HEADER_HIGH),
	.TRANSMIT_DATA_OBJECTS(TRANSMIT_DATA_OBJECTS),
	.MessageSentToPhy(MessageSentToPhy),
	.GoodCRCResponse(GoodCRCResponse),
	.nRetryCount(nRetryCount),
	.TX_BUF_HEADER_BYTE_1(TX_BUF_HEADER_BYTE_1),
	.RX_BUF_HEADER_BYTE_1(RX_BUF_HEADER_BYTE_1),
	.RX_BUF_FRAME_TYPE(RX_BUF_FRAME_TYPE),
	.DFP(DFP),
	.UFP(UFP),
	.Alert_MessageSuccessful(Alert_MessageSuccessful),
	.Alert_MessageFailed(Alert_MessageFailed),
	.TRANSMIT_DATA_OUTPUT(TRANSMIT_DATA_OUTPUT)
);

    //-- Proceso al inicio
initial begin

  //-- Fichero donde almacenar los resultados
  $dumpfile("pruebaTx.vcd");
  $dumpvars();

  # 100 $display("FIN TestBench");
  $finish;
end


endmodule