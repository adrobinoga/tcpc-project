module registers(
	input CLK,
	input RNW,			//indica si es read o write
	input [15:0] WR_DATA,		// 16 bits de entrada
	output reg [15:0] RD_DATA,	//registro salida que va a leer a un registro
	input REQUEST,			//solicitud para hacer una transferencia
	input [7:0] ADDR,		//direccion del registro
 	output reg ACK,

	//---------------------------REGISTROS-----------------------------------------//

	output reg [15:0] DEVICE_ID,      			//R              		
	output reg [15:0] USBTYPEC_REV,				//R	    			
	output reg [15:0] USBPD_REV_VER,			//R    		
	output reg [15:0] PD_INTERFACE_REV,			//R   		

	//output reg [15:0] Reserved,				no dice de que tipo		    	
	output reg [15:0] ALERT,				//RW    		
	output reg [15:0] ALERT_MASK,				//RW    		
	output reg [7:0] POWER_STATUS_MASK,			//RW    	
	output reg [7:0] FAULT_STATUS_MASK,			//RW    	
	  		
	output reg [7:0] TCPC_CONTROL,				//RW    		
	output reg [7:0] ROLE_CONTROL,				//RW    		
	output reg [7:0] FAULT_CONTROL,				//RW    		
	output reg [7:0] POWER_CONTROL,				//RW    		
	output reg [7:0] CC_STATUS,				//R    		
	output reg [7:0] POWER_STATUS,				//R    		
	output reg [7:0] FAULT_STATUS,				//RW    		

	output reg [15:0] Reserved,				//R 		    		
	output reg [7:0] COMMAND,				//W		    		
	output reg [15:0] DEVICE_CAPABILITIES_1, 		//R 	  		
	output reg [15:0] DEVICE_CAPABILITIES_2, 		//R   		
	output reg [7:0] STANDARD_INPUT_CAPABILITIES, 		//R  	
	output reg [15:0] STANDARD_OUTPUT_CAPABILITIES, 	//R  		
				
	output reg [7:0] MESSAGE_HEADER_INFO, 			//RW		
	output reg [7:0] RECEIVE_DETECT, 			//RW		
	output reg [7:0] RECEIVE_BYTE_COUNT, 			//R 		
	output reg [7:0] RX_BUF_FRAME_TYPE, 			//R	
	output reg [7:0] RX_BUF_HEADER_BYTE_0, 			//R 		
	output reg [7:0] RX_BUF_HEADER_BYTE_1,			//R  	
	output reg [7:0] RX_BUF_OBJ1_BYTE_0, 			//R 		
	output reg [7:0] RX_BUF_OBJ1_BYTE_1,			//R  		
	output reg [7:0] RX_BUF_OBJ1_BYTE_2, 			//R 		
	output reg [7:0] RX_BUF_OBJ1_BYTE_3,			//R 	
	output reg [7:0] RX_BUF_OBJ2_BYTE_0, 			//R 		
	output reg [15:0] RX_BUF_OBJn_BYTE_m,			//R  		
	output reg [7:0] RX_BUF_OBJ7_BYTE_3, 			//R 		

	output reg [7:0] TRANSMIT,				//RW	
	output reg [7:0] TRANSMIT_BYTE_COUNT, 			//RW	
	output reg [7:0] TX_BUF_HEADER_BYTE_0, 			//RW
	output reg [7:0] TX_BUF_HEADER_BYTE_1, 			//RW	
	output reg [7:0] TX_BUF_OBJ1_BYTE_0, 			//RW	
	output reg [15:0] TX_BUF_OBJn_BYTE_m, 			//RW		
	output reg [7:0] TX_BUF_OBJ7_BYTE_3,  			//RW		

	output reg [15:0] VBUS_VOLTAGE, 			//R 			
	output reg [15:0] VBUS_SINK_DISCONNECT_THRESHOLD, 	//RW 	
	output reg [15:0] VBUS_STOP_DISCHARGE_THRESHOLD,
	output reg [15:0] VBUS_SINK_DISCHARGE_THRESHOLD, 	//RW
	output reg [15:0] VBUS_VOLTAGE_ALARM_HI_CFG,		//RW
	output reg [15:0] VBUS_VOLTAGE_ALARM_LO_CFG); 		//RW
				

//el request debe estar en 1 para que se realice un write o un read, si esta en 0 no pasa nada
//se hace un case entre los que son de lectura y escritura. Si RNW=1---> lectura, si RNW=0--> escritura
//el case lo que busca es el address de cada registro
//TODAS las direcciones son de 8 bits, 

always @(posedge CLK)
 	begin
	ACK <= 0 ;  //el ack solo dure un ciclo
	if (REQUEST)	
		begin
		if (RNW)
			begin 	//si se trata de una lectura
			case(ADDR) //direccion: RD_DATA <= nombre del registro
				
				00000101: 
					begin				
					RD_DATA <= DEVICE_ID; 
					ACK <= 1;
					end		
				00000110: 
					begin
					RD_DATA <= USBTYPEC_REV;
					ACK <= 1;
					end

				00001001: begin
					RD_DATA <= USBPD_REV_VER;
       					ACK <= 1;	
					  end
				00001011: 
					  begin
					RD_DATA <= PD_INTERFACE_REV;
					ACK <= 1;	
					  end
				00010001: begin
					RD_DATA <= ALERT;
					ACK <= 1;
					  end
				00010011: begin
					RD_DATA <= ALERT_MASK;
	                                ACK <= 1;
					  end
				00010100: begin
					RD_DATA <= POWER_STATUS_MASK;
					ACK <= 1;
					  end
				00010101: begin
					RD_DATA <= FAULT_STATUS_MASK;
					ACK <= 1;
				          end
				00011001: begin
					RD_DATA <= TCPC_CONTROL;
					ACK <= 1;
				           end
				00011010: begin
					RD_DATA <= ROLE_CONTROL;
					ACK <= 1;
					  end
				00011011: begin
					RD_DATA <= FAULT_CONTROL;
					ACK <= 1;
					  end
				00011100: begin	
					RD_DATA <= POWER_CONTROL;
					ACK <= 1;
					  end
				00011101: begin
					RD_DATA <= CC_STATUS;
					ACK <= 1;
					  end
				00011110: begin
					RD_DATA <= POWER_STATUS;
					ACK <= 1;
					  end
				00011111: begin
					RD_DATA <= FAULT_STATUS;
					ACK <= 1;
					  end
				00100101: begin	
					RD_DATA <= DEVICE_CAPABILITIES_1;
					ACK <= 1;		
					  end
				00100111: begin
					RD_DATA <= DEVICE_CAPABILITIES_2;
					ACK <= 1;
					  end
				00101000: begin 
					RD_DATA <= STANDARD_INPUT_CAPABILITIES;
					ACK <= 1;
					  end
				00101001: begin
					RD_DATA <= STANDARD_OUTPUT_CAPABILITIES;
					ACK <= 1;
					  end
				00101110: begin
					RD_DATA <= MESSAGE_HEADER_INFO;
					ACK <= 1;
					  end
				00101111: begin
					RD_DATA <= RECEIVE_DETECT;
					ACK <= 1;
					  end
				00110000: begin
					RD_DATA <= RECEIVE_BYTE_COUNT;
					ACK <= 1;
					  end
				00110001: begin
					RD_DATA <= RX_BUF_FRAME_TYPE;
					ACK <= 1;
					  end
				00110010: begin
					RD_DATA <= RX_BUF_HEADER_BYTE_0;
					ACK <= 1;
					  end
				00110011: begin
					RD_DATA <= RX_BUF_HEADER_BYTE_1;
					ACK <= 1;
					  end
				00110100: begin
					RD_DATA <= RX_BUF_OBJ1_BYTE_0;
					ACK <= 1;
					  end
				00110101: begin
					RD_DATA <= RX_BUF_OBJ1_BYTE_1;
					ACK <= 1;
					  end
				00110110: begin
					RD_DATA <= RX_BUF_OBJ1_BYTE_2;
					ACK <= 1;
				          end
				00110111: begin
					RD_DATA <= RX_BUF_OBJ1_BYTE_3;
					ACK <= 1;
					  end
				00111000: begin 
					RD_DATA <= RX_BUF_OBJ2_BYTE_0;
					ACK <= 1;
					  end
				//XXXXXXXX: RD_DATA <= RX_BUF_OBJn_BYTE_m;
				01001111: begin
					RD_DATA <= RX_BUF_OBJ7_BYTE_3;
					ACK <= 1;
					  end
				01010000: begin
					RD_DATA <= TRANSMIT;			//50
					ACK <= 1;
					  end
				8'h51: 
					begin
					RD_DATA <= TRANSMIT_BYTE_COUNT;   	//51
					ACK <= 1;
					end
				01010010: begin
					RD_DATA <= TX_BUF_HEADER_BYTE_0;
					ACK <= 1;
					  end
				01010011: begin
					RD_DATA <= TX_BUF_HEADER_BYTE_1;
					ACK <= 1;
					  end
				01010100: begin
					RD_DATA <= TX_BUF_OBJ1_BYTE_0;
					ACK <= 1;
					  end
				//XXXXXXXX: RD_DATA <= TX_BUF_OBJn_BYTE_m;
				01101111: begin
					RD_DATA <= TX_BUF_OBJ7_BYTE_3;
					ACK <= 1;
					  end			
				01110000: begin
					RD_DATA <= VBUS_VOLTAGE;
					ACK <= 1;
					  end
				01110001: begin
					RD_DATA <= VBUS_VOLTAGE;
					ACK <= 1;
					  end
				01110011: begin
					RD_DATA <= VBUS_SINK_DISCONNECT_THRESHOLD;
					ACK <= 1;	
					  end
				01110101: begin
					RD_DATA <= VBUS_STOP_DISCHARGE_THRESHOLD;
					ACK <= 1;
					  end
				01110111: begin	
					RD_DATA <= VBUS_VOLTAGE_ALARM_HI_CFG;
					ACK <= 1;
					  end
				01111001: begin
					RD_DATA <= VBUS_VOLTAGE_ALARM_LO_CFG;
					ACK <= 1;
					  end
			endcase
			end	//end if(RNW)
		else		
		begin		
			case (ADDR) //si se trata de una escritura
				00010001: begin
					 ALERT <= WR_DATA;
					 ACK <= 1;	
					  end

				00010011: begin	
					ALERT_MASK <= WR_DATA;
					ACK <= 1;
					  end
				00010100: begin
					POWER_STATUS_MASK <= WR_DATA;
					ACK <= 1;
					  end
				00010101: begin
					FAULT_STATUS_MASK <= WR_DATA;
					ACK <= 1;
					  end
				8'h19:    begin
					TCPC_CONTROL <= WR_DATA;
					ACK <= 1;
					  end
				00011010: begin
					ROLE_CONTROL <= WR_DATA;
					ACK <= 1;
					  end
				00011011: begin
					FAULT_CONTROL <= WR_DATA;
					ACK <= 1;
					  end
				00011100: begin
					POWER_CONTROL <= WR_DATA;
					ACK <= 1;
					  end
				00011111: begin
					FAULT_STATUS <= WR_DATA;
					ACK <= 1;
					  end
				00100011: begin
					COMMAND <= WR_DATA;
					ACK <= 1;
					  end
				00101110: begin
					MESSAGE_HEADER_INFO <= WR_DATA;
					ACK <= 1;
					  end
				00101111: begin
					RECEIVE_DETECT <= WR_DATA;
					ACK <= 1;
					  end				
				01010000: begin
					TRANSMIT <= WR_DATA;
					ACK <= 1;
					  end
				16'h51: begin				//51h 
					TRANSMIT_BYTE_COUNT <= WR_DATA;
					ACK <= 1;
					end
				01010010: begin
					TX_BUF_HEADER_BYTE_0 <= WR_DATA;
 					ACK <= 1;	
					  end
				01010011: begin
					TX_BUF_HEADER_BYTE_1 <= WR_DATA;
 					ACK <= 1;	
					  end
				01010100: begin
					TX_BUF_OBJ1_BYTE_0 <= WR_DATA;
 					ACK <= 1;	
					  end
				//XXXXXXXX: TX_BUF_OBJn_BYTE_m <= WR_DATA;
				01101111: begin 
					TX_BUF_OBJ7_BYTE_3 <= WR_DATA;
					ACK <= 1;				
					  end
				01110011: begin
					VBUS_SINK_DISCONNECT_THRESHOLD <= WR_DATA;
					ACK <= 1;
					  end
				01110101: begin
					VBUS_STOP_DISCHARGE_THRESHOLD <= WR_DATA;
				        ACK <= 1;
					  end
				01110111: begin
					VBUS_VOLTAGE_ALARM_HI_CFG <= WR_DATA;
				        ACK <= 1;
					  end
				01111001: begin
					VBUS_VOLTAGE_ALARM_LO_CFG <= WR_DATA;
					ACK <= 1;	
					  end
			endcase
			end 	//end else
		end	//end if(request
	end	//end always
endmodule
