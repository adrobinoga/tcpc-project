module rx(
		clk, reset_L, tx, Unexpected_GoodCRC_received,message_received_from_phy, GoodCRC_Message_discarded_bus_Idle, GoodCRC_Transmission_complete, ALERT_TxMessageDiscarded, Send_GoodCRC_message_to_PHY, ALERT_ReceiveSOPStatusAsserted, idle  );

input reset_L;
input clk;
input tx;
input Unexpected_GoodCRC_received;
input GoodCRC_Message_discarded_bus_Idle;
input GoodCRC_Transmission_complete;
output reg ALERT_TxMessageDiscarded;
output reg Send_GoodCRC_message_to_PHY;
output reg ALERT_ReceiveSOPStatusAsserted;	
output reg idle;
output reg message_received_from_phy;
reg [3:0] state;
reg buffer;
reg [3:0] next_state;
reg next_idle;
reg next_Message_Discard;
reg Message_Discard;


// Estados de la Máquina
localparam RESET = 4'b0000;
localparam Rx_Wait_for_PHY_message = 4'b0001;
localparam Rx_Message_Discard = 4'b0010;
localparam Rx_Report_SOP = 4'b0011;
localparam Rx_Send_GoodCRC = 4'b0100;


always @(posedge clk) begin //Bloque de Flip Flops

	if(~reset_L) begin

		state <= RESET;			
		Message_Discard <= 1'b0;
		idle <= 1'b1;

			end
	else	begin			

		state <= next_state;
		Message_Discard <= next_Message_Discard;					
		idle <= next_idle;
	     	end

			end

always @(*)begin  //Lógica de Próximo Estado

	case(state)
	  RESET:       begin
			     next_state = Rx_Wait_for_PHY_message;
		       end

	  Rx_Wait_for_PHY_message: 
			if(~buffer && message_received_from_phy) begin
				next_state = Rx_Message_Discard;		
			end else begin 
				next_state = Rx_Wait_for_PHY_message;
			end

	  Rx_Message_Discard:
			if (Unexpected_GoodCRC_received) begin 
				next_state = Rx_Report_SOP;		
			end else begin 
				next_state = Rx_Send_GoodCRC;
			end
	  
	  Rx_Send_GoodCRC:
			if (GoodCRC_Message_discarded_bus_Idle) begin 
				next_state =Rx_Wait_for_PHY_message;		
			end else if(GoodCRC_Transmission_complete) begin 
				next_state = Rx_Report_SOP;
			end
 
	  Rx_Report_SOP: begin
			
				next_state = Rx_Wait_for_PHY_message;
			
			 end

	 default: next_state = state;
	endcase
end



always @(*)begin //Lógica de Salida
case(state)
	  RESET:       
		       begin
			     next_idle = 1'b1;
			     next_Message_Discard = 1'b0;
		       end

	  Rx_Wait_for_PHY_message: 
			begin
			     next_idle = 1'b1;
			     next_Message_Discard = 1'b0;
			end

	  Rx_Message_Discard:
			begin
			     next_idle = 1'b0;
			     next_Message_Discard = 1'b1;
			     buffer = 1'b0;
			     message_received_from_phy = 1'b1;
			if(tx) begin
			     ALERT_TxMessageDiscarded = 1'b1;    
			end else begin
			     ALERT_TxMessageDiscarded = 1'b0;
			end
			end 
	  
	  Rx_Send_GoodCRC:
			begin
			     next_idle = 1'b0;
			     Send_GoodCRC_message_to_PHY = 1'b1;
		        end
 
	  Rx_Report_SOP: begin
			     next_idle = 1'b0;
			     ALERT_ReceiveSOPStatusAsserted = 1'b1;
			
			 end

	endcase
end

endmodule
