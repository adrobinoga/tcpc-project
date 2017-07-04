module Banco_Pruebas_Rx(
output reg clk,
output reg reset_L,
output reg tx,
output reg Unexpected_GoodCRC_received,
output reg GoodCRC_Message_discarded_bus_Idle,
output reg GoodCRC_Transmission_complete
);


  initial
    begin

      clk=0;
      reset_L<=0;
      tx<=0;
      Unexpected_GoodCRC_received<=0;
      GoodCRC_Message_discarded_bus_Idle<=0;
      GoodCRC_Transmission_complete<=0;


      #5 reset_L <= 1;
      #7 tx <= 1;
      #8 Unexpected_GoodCRC_received <= 1;
      #9 GoodCRC_Message_discarded_bus_Idle<= 0;
      #10 GoodCRC_Transmission_complete<= 1;


      $finish;
    end


//-- Generador de reloj. Periodo 2 unidades
always 
	begin
  # 1 clk <= ~clk;
    	end

endmodule
