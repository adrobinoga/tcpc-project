module rx ( 
		 
		input wire 	 clk, 
		input wire 	 hard_reset, 
		input wire 	 cable_reset, 
		input wire 	 tx_state_machine_active, 
		input wire [7:0] DataBusIn, 
		input wire [7:0] MESSAGE_HEADER_INFO_IN, // Registro de información de header 
		input wire [7:0] RECEIVE_DETECT_IN, // Registro de notificación de mensaje
		input wire [7:0] TX_BUF_HEADER_BYTE_1, // Header del mensaje en TX
		input wire [7:0] TX_BUF_HEADER_BYTE_0, // Header del mensaje en TX
		input wire [7:0] RX_BUF_HEADER_BYTE_1, // Rx buffer header byte 1
		input wire [7:0] RX_BUF_HEADER_BYTE_0, // Rx buffer header byte 0
		input wire 	 GoodCRC_Message_Discarded,
		input wire 	 GoodCRC_Transmission_Complete,
                input wire 	 rx_goodcrc,               
                output reg 	 rx_tx_message_discard, 
		output reg [7:0] DirBus, // Bus de direcciones proveniente del I2C
		output reg [7:0] DataBusOut, // Datos de salida de los registros.
		output reg 	 memory_request,
		output reg 	 RNW,
		output wire 	 idle, 
		output reg [7:0] RECEIVE_BYTE_COUNT_OUT,	
                output reg [7:0] ALERT_Register,
                output reg [7:0] RX_BUF_FRAME_TYPE,
		output reg [7:0] RECEIVE_DETECT_OUT 
		);
   reg [3:0] 		   state; 
   reg [3:0] 		   nextState; 
   reg 			   RxBufferFull;
   reg [3:0] 		   WriteGoodCRC_counter; 
 		   

   wire 		   MessageRecivedFromPHY;

   
//Estados de la máquina
   localparam PRL_Rx_Wait_For_PHY_Message = 4'b0001;
   localparam PRL_Rx_Message_Discard      = 4'b0010; 
   localparam PRL_Rx_Send_GoodCRC         = 4'b1000; 
   localparam PRL_Rx_Report_SOP           = 4'b0100; 

//Contadores de mensajes
   localparam ControlMessageSize          = 4'b0101;

//Los siguientes parámetros son valores dados por el estándar del USB Tipo C de Noviembre del 2016.
//Alertas y Notificaciones

   localparam ALERT_DIR_0                   = 8'h10; 
   localparam ALERT_DIR_1                   = 8'h11; 
   
//Direcciones del buffer para ser leídas
   localparam HEADER_0                    = 82;
   localparam HEADER_1                    = 83;
   localparam BYTE_COUNT                  = 81;
   localparam BUF_FRAME_TYPE              = 49;   

//Direcciones del buffer para ser escritas

   assign MessageRecivedFromPHY = RECEIVE_DETECT_IN[0] | RECEIVE_DETECT_IN[1] | RECEIVE_DETECT_IN[2] | RECEIVE_DETECT_IN[3] | RECEIVE_DETECT_IN[4] ; //Recibe mensajes
   assign MessageType = RX_BUF_HEADER_BYTE_0[3:0]; // Tipo de mensaje recibido    
   assign idle = state[0];   
   
//Bloque de Flip Flops
   always @ (posedge(clk))
     begin
	if (hard_reset == 1'b1 || cable_reset == 1'b1)
	  begin
	     state <= PRL_Rx_Wait_For_PHY_Message; // Se regresa al estado incial	     
	  end
	else
	  begin
	     state <= nextState; //cambio de estado	     	     
	  end

	if (state == PRL_Rx_Send_GoodCRC )
	  begin
	     WriteGoodCRC_counter<=WriteGoodCRC_counter + 4'b0001; // counter+1
	  end
	else
	  begin
	     WriteGoodCRC_counter<= 4'b0000; // counter=0
	  end
	
     end

//Lógica de Próximo Estado
   always @ (*)
     begin
	case (state)	  
	  PRL_Rx_Wait_For_PHY_Message:	    
	    begin	 	       	   	       
	       if ( ~RxBufferFull || MessageRecivedFromPHY )
		 begin
		    nextState <= PRL_Rx_Message_Discard;
		 end
	       else
		 begin
		    nextState<=state;		    
		 end
	    end
	  PRL_Rx_Message_Discard:
	    begin	 	       	       
	       if (rx_goodcrc)
		 begin  	       
		    if (RX_BUF_HEADER_BYTE_0[3:0] == 4'b0001 )
		      begin
			 nextState <= PRL_Rx_Report_SOP;
		      end
		    else
		      begin
			 nextState <= PRL_Rx_Send_GoodCRC;
		      end
		 end
	       else
		 begin
		    nextState <= PRL_Rx_Wait_For_PHY_Message; //Volver a estado inicial	   		    
		 end
	    end
	  PRL_Rx_Send_GoodCRC:
	    begin	 	       	       
	       if (WriteGoodCRC_counter == ControlMessageSize) // Se cumplieron las 4 escrituras en memoria
		 begin
		    if (GoodCRC_Message_Discarded || GoodCRC_Transmission_Complete)
		      begin  	       
			 nextState <= PRL_Rx_Report_SOP;
		      end
		    else
		      begin
			 nextState <= state; //Se queda en el mismo estado
		      end
		 end // if (WriteGoodCRC_counter == ControlMessageSize)	       
	       else
		 begin		    
		    nextState <= state; // Permanece en el mismo estado
		 end
	    end
	  PRL_Rx_Report_SOP:
	    begin	       	       
	       nextState <= PRL_Rx_Wait_For_PHY_Message;	       
	    end
	  default:
	    begin	       
	       nextState <= state;	       
	    end
	endcase
     end

//Lógica de Salida
   always @ (*)
     begin
	case (state)

	  PRL_Rx_Wait_For_PHY_Message:
	    begin
	       memory_request = 0;
	       RNW = 1;
	       
	       DirBus<=8'h00; // Valor por defecto del bus de direcciones
	       DataBusOut<=8'b00000000; // Valor por defecto del bus de datos
	    end
	  PRL_Rx_Message_Discard: // En este estado se realiza la tarea correspondiente a cada mensaje
	    begin	 
	       memory_request = 0;
	       RNW = 0;
      
	       DirBus<=8'h00; // Valor por defecto del bus de direcciones
	       DataBusOut<=8'b00000000; // Valor por defecto del bus de datos
	    end
	  PRL_Rx_Send_GoodCRC:
	    begin
	       memory_request = 1;
	       RNW = 0;
	       case (WriteGoodCRC_counter)
		 4'b0000: // Se escribe la cabecera alta
		   begin
		      DirBus<=HEADER_1;		      
		      DataBusOut<={8'b0000,RX_BUF_HEADER_BYTE_1[3:1],MESSAGE_HEADER_INFO_IN[0]};	       
		   end
		 4'b0001: // Se escribe la cabecera baja
		   begin
		      DirBus<=HEADER_0;		      
		      DataBusOut<={MESSAGE_HEADER_INFO_IN[2:1],6'b000001};
		   end
		 4'b0010: // Se escribe la cabecera baja
		   begin
		      DirBus<=BYTE_COUNT;		      
		      DataBusOut<=8'b00000011; // NÃºmero de bytes en el mensaje
		   end
		 4'b0011: // Se escribe el tipo de mensaje
		   begin
		      DirBus<=BUF_FRAME_TYPE;
		      DataBusOut<=8'b00000000; //SOP Message
		   end
		 4'b0100: // Se levanta la alerta para que el master lea
		   begin
		      DirBus<=ALERT_DIR_0; // Dir_reg_alerta
		      DataBusOut<=8'b00000100; // Alerta
		   end
		 4'b0101: // Se levanta la alerta para que el master lea
		   begin
		      DirBus<=ALERT_DIR_1; // Dir_reg_alerta
		      DataBusOut<=8'b00000000; // Alerta
		   end
		 default:
		   begin		      
		      DirBus<=8'h00;
		      DataBusOut<=8'b00000000;
		   end
	       endcase
	    end
	  PRL_Rx_Report_SOP:
	    begin
	       memory_request = 1;
	       RNW = 0;
	       
	       DirBus<=47;
	       DataBusOut<=8'b00000000;	       
	    end
	  default: //No haga nada
	    begin
	       memory_request = 0;
	       RNW = 1;
	       
	       DirBus<=8'h00;
	       DataBusOut<=8'b00000000;	
	    end
	endcase	
     end
   
endmodule
