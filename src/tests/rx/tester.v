module tester (
		 output reg 	  clk,
		 output reg 	  hard_reset,
		 output reg [7:0] MESSAGE_HEADER_INFO,
		 output reg [7:0] TX_BUF_HEADER_BYTE_0,
		 output reg [7:0] TX_BUF_HEADER_BYTE_1,
		 output reg [7:0] RECEIVE_DETECT,
		 output reg 	  phy_rx_goodcrc,
		 output reg 	  GoodCRC_Transmission_Complete,
		 input wire 	  RECEIVE_DETECT_IN
		 );

   initial
     begin
	MESSAGE_HEADER_INFO=8'b00011010;       
	clk=0;
	hard_reset=1;
	#15 hard_reset=0;
	#30 TX_BUF_HEADER_BYTE_0=8'b01001011;
	TX_BUF_HEADER_BYTE_1=8'b00100111;
	#10 RECEIVE_DETECT=8'b00000001;
	phy_rx_goodcrc=1;
	#40 GoodCRC_Transmission_Complete=1;
	
	
	

	
     end

   always
     begin
	#10 clk = ~clk;	
	
     end

   always @ (RECEIVE_DETECT_IN)
     begin
	RECEIVE_DETECT<=RECEIVE_DETECT_IN;
	
     end
endmodule
