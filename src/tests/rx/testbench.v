module Rx_tb;

input wire clk;

output wire ALERT_TxMessageDiscarded;
output wire Send_GoodCRC_message_to_PHY;
output wire ALERT_ReceiveSOPStatusAsserted;	
output wire idle;
output wire message_received_from_phy;

Banco_Pruebas_Rx t (
.clk(clk), 
.reset_L(hard_reset_L), 
.tx(tx), 
.Unexpected_GoodCRC_received(Unexpected_GoodCRC_received), 
.GoodCRC_Message_discarded_bus_Idle(GoodCRC_Message_discarded_bus_Idle),
.GoodCRC_Transmission_complete(GoodCRC_Transmission_complete)
);

rx uut (
.clk(clk), 
.reset_L(reset_L), 
.tx(tx), 
.Unexpected_GoodCRC_received(Unexpected_GoodCRC_received),
.message_received_from_phy(message_received_from_phy), 
.GoodCRC_Message_discarded_bus_Idle(GoodCRC_Message_discarded_bus_Idle), 
.GoodCRC_Transmission_complete(GoodCRC_Transmission_complete), 
.ALERT_TxMessageDiscarded(ALERT_TxMessageDiscarded), 
.Send_GoodCRC_message_to_PHY(Send_GoodCRC_message_to_PHY),
.idle(idle),
.ALERT_ReceiveSOPStatusAsserted(ALERT_ReceiveSOPStatusAsserted)
);

    //-- Proceso al inicio
initial begin
    
  //-- Fichero donde almacenar los resultados
  $dumpfile("testbench.vcd");
  $dumpvars(0, Rx_tb);
    
  # 100 $display("FIN TestBench");
  $finish;
end


endmodule

