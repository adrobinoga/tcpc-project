module registros(
	input CLK,
	input RNW,			//indica si es read o write
	//separamos el write de entrada en 2 bytes porque hay algunos registros de 16 bits y otros de 8.
	input [15:0] WR_DATA,		// 16 bits de entrada
	// primeros 8 bits (izquierda) que van a escribir en un registro
	// segundos 8 bits (derecha) que va a escribir en un registro
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
			
				00000100: 
					begin 
					RD_DATA <= DEVICE_ID;
					ACK <= 1;	
					end	
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
				00000111: 
					begin
					RD_DATA <= USBTYPEC_REV;
					ACK <= 1;	
					end
				00001000: 
					begin 
					RD_DATA <= USBPD_REV_VER;
					ACK <= 1;
					end
				00001001: 
					begin
					RD_DATA <= USBPD_REV_VER;
       					ACK <= 1;	
					end
				00001010: 
					begin
					RD_DATA <= PD_INTERFACE_REV;
					ACK <= 1;	
					end
				00001011: 
					begin
					RD_DATA <= PD_INTERFACE_REV;
					ACK <= 1;	
					end
				00010000: RD_DATA <= ALERT;
				00010001: RD_DATA <= ALERT;

				00010010: RD_DATA <= ALERT_MASK;
				00010011: RD_DATA <= ALERT_MASK;

				00010100: RD_DATA <= POWER_STATUS_MASK;
				00010101: RD_DATA <= FAULT_STATUS_MASK;

				00011001: RD_DATA <= TCPC_CONTROL;

				00011010: RD_DATA <= ROLE_CONTROL;
				00011011: RD_DATA <= FAULT_CONTROL;
				00011100: RD_DATA <= POWER_CONTROL;
				00011101: RD_DATA <= CC_STATUS;
				00011110: RD_DATA <= POWER_STATUS;
				00011111: RD_DATA <= FAULT_STATUS;

				00100100: RD_DATA <= DEVICE_CAPABILITIES_1;
				00100101: RD_DATA <= DEVICE_CAPABILITIES_1;

				00100110: RD_DATA <= DEVICE_CAPABILITIES_2;
				00100111: RD_DATA <= DEVICE_CAPABILITIES_2;

				00101000: RD_DATA <= STANDARD_INPUT_CAPABILITIES;
				00101001: RD_DATA <= STANDARD_OUTPUT_CAPABILITIES;

				00101110: RD_DATA <= MESSAGE_HEADER_INFO;
				00101111: RD_DATA <= RECEIVE_DETECT;
				00110000: RD_DATA <= RECEIVE_BYTE_COUNT;
				00110001: RD_DATA <= RX_BUF_FRAME_TYPE;
				00110010: RD_DATA <= RX_BUF_HEADER_BYTE_0;
				00110011: RD_DATA <= RX_BUF_HEADER_BYTE_1;
				00110100: RD_DATA <= RX_BUF_OBJ1_BYTE_0;
				00110101: RD_DATA <= RX_BUF_OBJ1_BYTE_1;
				00110110: RD_DATA <= RX_BUF_OBJ1_BYTE_2;
				00110111: RD_DATA <= RX_BUF_OBJ1_BYTE_3;
				00111000: RD_DATA <= RX_BUF_OBJ2_BYTE_0;
				//XXXXXXXX: RD_DATA <= RX_BUF_OBJn_BYTE_m;
				01001111: RD_DATA <= RX_BUF_OBJ7_BYTE_3;
				01010000: RD_DATA <= TRANSMIT;			//50
				8'h51: 
					begin
					RD_DATA <= TRANSMIT_BYTE_COUNT;   	//51
					ACK <= 1;
					end
				01010010: RD_DATA <= TX_BUF_HEADER_BYTE_0;
				01010011: RD_DATA <= TX_BUF_HEADER_BYTE_1;
				01010100: RD_DATA <= TX_BUF_OBJ1_BYTE_0;
				//XXXXXXXX: RD_DATA <= TX_BUF_OBJn_BYTE_m;
				01101111: RD_DATA <= TX_BUF_OBJ7_BYTE_3;
				
				01110000: RD_DATA <= VBUS_VOLTAGE;
				01110001: RD_DATA <= VBUS_VOLTAGE;

				01110010: RD_DATA <= VBUS_SINK_DISCONNECT_THRESHOLD;
				01110011: RD_DATA <= VBUS_SINK_DISCONNECT_THRESHOLD;

				01110100: RD_DATA <= VBUS_STOP_DISCHARGE_THRESHOLD;
				01110101: RD_DATA <= VBUS_STOP_DISCHARGE_THRESHOLD;

				01110110: RD_DATA <= VBUS_VOLTAGE_ALARM_HI_CFG;
				01110111: RD_DATA <= VBUS_VOLTAGE_ALARM_HI_CFG;

				01111000: RD_DATA <= VBUS_VOLTAGE_ALARM_LO_CFG;
				01111001: RD_DATA <= VBUS_VOLTAGE_ALARM_LO_CFG;
			endcase
			end	//end if(RNW)
		else		
		begin		
			case (ADDR) //si se trata de una escritura
		
				00010000: begin
					 ALERT <= WR_DATA;
					 ACK <= 1;	
					  end
				00010001: ALERT <= WR_DATA;

				00010010: ALERT_MASK <= WR_DATA;
				00010011: ALERT_MASK <= WR_DATA;

				00010100: POWER_STATUS_MASK <= WR_DATA;
				00010101: FAULT_STATUS_MASK <= WR_DATA;

				8'h19: TCPC_CONTROL <= WR_DATA;
				00011010: ROLE_CONTROL <= WR_DATA;
				00011011: FAULT_CONTROL <= WR_DATA;
				00011100: POWER_CONTROL <= WR_DATA;
				00011111: FAULT_STATUS <= WR_DATA;
				00100011: COMMAND <= WR_DATA;
				00101110: MESSAGE_HEADER_INFO <= WR_DATA;
				00101111: RECEIVE_DETECT <= WR_DATA;				
				01010000: TRANSMIT <= WR_DATA;
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
				01101111: TX_BUF_OBJ7_BYTE_3 <= WR_DATA;
				
				01110010: VBUS_SINK_DISCONNECT_THRESHOLD <= WR_DATA;
				01110011: VBUS_SINK_DISCONNECT_THRESHOLD <= WR_DATA;

				01110100: VBUS_STOP_DISCHARGE_THRESHOLD <= WR_DATA;
				01110101: VBUS_STOP_DISCHARGE_THRESHOLD <= WR_DATA;

				01110110: VBUS_VOLTAGE_ALARM_HI_CFG <= WR_DATA;
				01110111: VBUS_VOLTAGE_ALARM_HI_CFG <= WR_DATA;
	
				01111000: VBUS_VOLTAGE_ALARM_LO_CFG <= WR_DATA;
				01111001: VBUS_VOLTAGE_ALARM_LO_CFG <= WR_DATA;
			endcase
			end 	//end else
		end	//end if(request
	end	//end always
endmodule