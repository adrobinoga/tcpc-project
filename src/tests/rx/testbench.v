module testbench();

   wire clk;
   wire hard_reset;
   wire [7:0] MESSAGE_HEADER_INFO;
   wire [7:0] TX_BUF_HEADER_BYTE_0;
   wire [7:0] TX_BUF_HEADER_BYTE_1;
   wire [7:0] RECEIVE_DETECT;
   wire       phy_rx_goodcrc;
   wire       GoodCRC_Transmission_Complete;
   wire       RECEIVE_DETECT_retro;

   
   tester t(clk,hard_reset,MESSAGE_HEADER_INFO,TX_BUF_HEADER_BYTE_0,TX_BUF_HEADER_BYTE_1,RECEIVE_DETECT,phy_rx_goodcrc,GoodCRC_Transmission_Complete,RECEIVE_DETECT_retro);   
   rx uut(clk,hard_reset,,,,MESSAGE_HEADER_INFO,RECEIVE_DETECT,TX_BUF_HEADER_BYTE_1,TX_BUF_HEADER_BYTE_0,,,,GoodCRC_Transmission_Complete,phy_rx_goodcrc,,,,,,,,,,RECEIVE_DETECT_retro);

    initial
     
     begin
	$dumpfile("simulacion_Rx.vcd");
	$dumpvars;
	$display ("Simulación");
	$monitor ($time,,"clk = %b", clk);
	#2000 $finish;
     end
endmodule  
