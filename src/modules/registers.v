module registers(
	input CLK,
	input RNW,			//indica si es read o write
	input REQUEST,			//solicitud para hacer una transferencia
	input [7:0] ADDR,		//direccion del registro
	input [7:0] WR_DATA,		// 16 bits de entrada
	output reg [7:0] RD_DATA,	//registro salida que va a leer a un registro
 	output reg ACK,

	//---------------------------REGISTROS-----------------------------------------//

	output reg [15:0] DEVICE_ID,      			//R              
	output reg [15:0] USBTYPEC_REV,				//R	    	
	output reg [15:0] USBPD_REV_VER,			//R    		
	output reg [15:0] PD_INTERFACE_REV,			//R  
	 		
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
	output reg [7:0] COMMAND,				//W		    		
	output reg [15:0] DEVICE_CAPABILITIES_1, 		//R 	  		
	output reg [15:0] DEVICE_CAPABILITIES_2, 		//R   		
	output reg [7:0] STANDARD_INPUT_CAPABILITIES, 		//R  	
	output reg [7:0] STANDARD_OUTPUT_CAPABILITIES, 	//R  		
				
	output reg [7:0] MESSAGE_HEADER_INFO, 			//RW		
	output reg [7:0] RECEIVE_DETECT, 			//RW		
	output reg [7:0] RECEIVE_BYTE_COUNT, 			//R 	
		
	output reg [7:0] RX_BUF_FRAME_TYPE, 			//R	
	output reg [7:0] RX_BUF_HEADER_BYTE_0, 			//R 		
	output reg [7:0] RX_BUF_HEADER_BYTE_1,			//R  	
	
	output reg [7:0] RX_BUF_OBJ1_BYTE_0,
	output reg [7:0] RX_BUF_OBJ1_BYTE_1,
	output reg [7:0] RX_BUF_OBJ1_BYTE_2,
	output reg [7:0] RX_BUF_OBJ1_BYTE_3,
	output reg [7:0] RX_BUF_OBJ2_BYTE_0,
	output reg [7:0] RX_BUF_OBJ2_BYTE_1,
	output reg [7:0] RX_BUF_OBJ2_BYTE_2,
	output reg [7:0] RX_BUF_OBJ2_BYTE_3,
	
	output reg [7:0] TRANSMIT,				//RW	
	output reg [7:0] TRANSMIT_BYTE_COUNT, 			//RW	
	output reg [7:0] TX_BUF_HEADER_BYTE_0, 			//RW
	output reg [7:0] TX_BUF_HEADER_BYTE_1, 			//RW	

	output reg [7:0] TX_BUF_OBJ1_BYTE_0,
	output reg [7:0] TX_BUF_OBJ1_BYTE_1,
	output reg [7:0] TX_BUF_OBJ1_BYTE_2,
	output reg [7:0] TX_BUF_OBJ1_BYTE_3,
	output reg [7:0] TX_BUF_OBJ2_BYTE_0,
	output reg [7:0] TX_BUF_OBJ2_BYTE_1,
	output reg [7:0] TX_BUF_OBJ2_BYTE_2,
	output reg [7:0] TX_BUF_OBJ2_BYTE_3,

	output reg [15:0] VBUS_VOLTAGE	 			//R 	
);

//el request debe estar en 1 para que se realice un write o un read, si esta en 0 no pasa nada
//se hace un case entre los que son de lectura y escritura. Si RNW=1---> lectura, si RNW=0--> escritura
//el case lo que busca es el address de cada registro
//TODAS las direcciones son de 8 bits, 
//with its 8 Least Significant bits stored in the first (lower address) byte and
// its 8 Most Significant bits stored in the second (higher address) byte
always @(posedge CLK)
 	begin
	ACK <= 0 ;  //el ack solo dure un ciclo
	if (REQUEST)	
		begin
		if (RNW)
			begin 	//si se trata de una lectura
			case(ADDR) //direccion: RD_DATA <= nombre del registro
				
				8'h04: 
					begin				
					RD_DATA <= DEVICE_ID[7:0]; 
					ACK <= 1;
					end
				8'h05: 
					begin				
					RD_DATA <= DEVICE_ID[15:8]; 
					ACK <= 1;
					end		
				8'h06: 
					begin
					RD_DATA <= USBTYPEC_REV[7:0];
					ACK <= 1;
					end
				8'h07: 
					begin
					RD_DATA <= USBTYPEC_REV[15:8];
					ACK <= 1;
					end

				8'h08: 
					begin
					RD_DATA <= USBPD_REV_VER[7:0];
       					ACK <= 1;	
					end
				8'h09: 
					begin
					RD_DATA <= USBPD_REV_VER[15:8];
       					ACK <= 1;	
					end
				8'h0A: 
					begin
					RD_DATA <= PD_INTERFACE_REV[7:0];
					ACK <= 1;	
					end
				8'h0B: 
					begin
					RD_DATA <= PD_INTERFACE_REV[15:8];
					ACK <= 1;	
					end
				8'h10: 
					begin
					RD_DATA <= ALERT[7:0];
					ACK <= 1;
					end
				8'h11: 
					begin
					RD_DATA <= ALERT[15:8];
					ACK <= 1;
					end
				8'h12: 
					begin
					RD_DATA <= ALERT_MASK[7:0];
	                                ACK <= 1;
					end
				8'h13: 
					begin
					RD_DATA <= ALERT_MASK[15:8];
	                                ACK <= 1;
					end
				8'h14: 
					begin
					RD_DATA <= POWER_STATUS_MASK;
					ACK <= 1;
					end
				8'h15: 
					begin
					RD_DATA <= FAULT_STATUS_MASK;
					ACK <= 1;
				        end
				8'h19:
					begin
					RD_DATA <= TCPC_CONTROL;
					ACK <= 1;
				        end
				8'h1A:
					begin
					RD_DATA <= ROLE_CONTROL;
					ACK <= 1;
					end
				8'h1B:
					begin
					RD_DATA <= FAULT_CONTROL;
					ACK <= 1;
					end
				8'h1C: 
					begin	
					RD_DATA <= POWER_CONTROL;
					ACK <= 1;
					end
				8'h1D:
					begin
					RD_DATA <= CC_STATUS;
					ACK <= 1;
					end
				8'h1E:
					begin
					RD_DATA <= POWER_STATUS;
					ACK <= 1;
					end
				8'h1F: 
					begin
					RD_DATA <= FAULT_STATUS;
					ACK <= 1;
					end
				8'h24:
					begin	
					RD_DATA <= DEVICE_CAPABILITIES_1[7:0];
					ACK <= 1;		
					end
				8'h25:
					begin	
					RD_DATA <= DEVICE_CAPABILITIES_1[15:8];
					ACK <= 1;		
					end
				8'h26: 
					begin
					RD_DATA <= DEVICE_CAPABILITIES_2[7:0];
					ACK <= 1;
					end
				8'h27: 
					begin
					RD_DATA <= DEVICE_CAPABILITIES_2[15:8];
					ACK <= 1;
					end
				8'h28: 
					begin 
					RD_DATA <= STANDARD_INPUT_CAPABILITIES;
					ACK <= 1;
					end
				8'h29: 
					begin
					RD_DATA <= STANDARD_OUTPUT_CAPABILITIES;
					ACK <= 1;
					end
				8'h2E: 
					begin
					RD_DATA <= MESSAGE_HEADER_INFO;
					ACK <= 1;
					end
				8'h2F: 
					begin
					RD_DATA <= RECEIVE_DETECT;
					ACK <= 1;
					end
				8'h30: 
					begin
					RD_DATA <= RECEIVE_BYTE_COUNT;
					ACK <= 1;
					end
				8'h31: 
					begin
					RD_DATA <= RX_BUF_FRAME_TYPE;
					ACK <= 1;
					  end
				8'h32: 
					begin
					RD_DATA <= RX_BUF_HEADER_BYTE_0;
					ACK <= 1;
					end
				8'h33: 
					begin
					RD_DATA <= RX_BUF_HEADER_BYTE_1;
					ACK <= 1;
					end
				// RX Buffer
				8'h34:
					begin
					RD_DATA <= RX_BUF_OBJ1_BYTE_0;
					ACK <= 1;
					end

				8'h35:
					begin
					RD_DATA <= RX_BUF_OBJ1_BYTE_1;
					ACK <= 1;
					end

				8'h36:
					begin
					RD_DATA <= RX_BUF_OBJ1_BYTE_2;
					ACK <= 1;
					end

				8'h37:
					begin
					RD_DATA <= RX_BUF_OBJ1_BYTE_3;
					ACK <= 1;
					end

				8'h38:
					begin
					RD_DATA <= RX_BUF_OBJ2_BYTE_0;
					ACK <= 1;
					end

				8'h39:
					begin
					RD_DATA <= RX_BUF_OBJ2_BYTE_1;
					ACK <= 1;
					end

				8'h3a:
					begin
					RD_DATA <= RX_BUF_OBJ2_BYTE_2;
					ACK <= 1;
					end
					
				8'h3b:
					begin
					RD_DATA <= RX_BUF_OBJ2_BYTE_3;
					ACK <= 1;
					end
				// end of RX Buffer
				8'h50: 
					begin
					RD_DATA <= TRANSMIT;			//50
					ACK <= 1;
					end
				8'h51: 
					begin
					RD_DATA <= TRANSMIT_BYTE_COUNT;   	//51
					ACK <= 1;
					end
				8'h52: 
					begin
					RD_DATA <= TX_BUF_HEADER_BYTE_0;
					ACK <= 1;
					end
				8'h53: 
					begin
					RD_DATA <= TX_BUF_HEADER_BYTE_1;
					ACK <= 1;
					end
				// TX Buffer
				8'h54:
					begin
					RD_DATA <= TX_BUF_OBJ1_BYTE_0;
					ACK <= 1;
					end

				8'h55:
					begin
					RD_DATA <= TX_BUF_OBJ1_BYTE_1;
					ACK <= 1;
					end

				8'h56:
					begin
					RD_DATA <= TX_BUF_OBJ1_BYTE_2;
					ACK <= 1;
					end

				8'h57:
					begin
					RD_DATA <= TX_BUF_OBJ1_BYTE_3;
					ACK <= 1;
					end

				8'h58:
					begin
					RD_DATA <= TX_BUF_OBJ2_BYTE_0;
					ACK <= 1;
					end

				8'h59:
					begin
					RD_DATA <= TX_BUF_OBJ2_BYTE_1;
					ACK <= 1;
					end

				8'h5a:
					begin
					RD_DATA <= TX_BUF_OBJ2_BYTE_2;
					ACK <= 1;
					end

				8'h5b:
					begin
					RD_DATA <= TX_BUF_OBJ2_BYTE_3;
					ACK <= 1;
					end
				// end of TX Buffer		
				8'h70:
					begin
					RD_DATA <= VBUS_VOLTAGE[7:0];
					ACK <= 1;
					end
				8'h71:
					begin
					RD_DATA <= VBUS_VOLTAGE[15:8];
					ACK <= 1;
					end
			endcase
			end	//end if(RNW)
		else		
		begin		
			case (ADDR) //si se trata de una escritura
				8'h10: 
					begin
					ALERT[7:0] <= WR_DATA;
					ACK <= 1;	
					end
				8'h11: 
					begin
					ALERT[15:8] <= WR_DATA;
					ACK <= 1;	
					end
				8'h12: 
					begin	
					ALERT_MASK[7:0] <= WR_DATA;
					ACK <= 1;
					end
				8'h13: 
					begin	
					ALERT_MASK[15:8] <= WR_DATA;
					ACK <= 1;
					end
				8'h14: 
					begin
					POWER_STATUS_MASK <= WR_DATA;
					ACK <= 1;
					end
				8'h15: 
					begin
					FAULT_STATUS_MASK <= WR_DATA;
					ACK <= 1;
					end
				8'h19:  
					begin
					TCPC_CONTROL <= WR_DATA;
					ACK <= 1;
					end
				8'h1A: 
					begin
					ROLE_CONTROL <= WR_DATA;
					ACK <= 1;
					end
				8'h1B: 
					begin
					FAULT_CONTROL <= WR_DATA;
					ACK <= 1;
					end
				8'h1C:	
					begin
					POWER_CONTROL <= WR_DATA;
					ACK <= 1;
					end
				8'h1F: 
					begin
					FAULT_STATUS <= WR_DATA;
					ACK <= 1;
					end
				8'h23: 
					begin
					COMMAND <= WR_DATA;
					ACK <= 1;
					end
				8'h2E: 
					begin
					MESSAGE_HEADER_INFO <= WR_DATA;
					ACK <= 1;
					end
				8'h2F:	
					begin
					RECEIVE_DETECT <= WR_DATA;
					ACK <= 1;
					end				
				8'h50: 
					begin
					TRANSMIT <= WR_DATA;
					ACK <= 1;
					end
				8'h51: 
					begin				//51h 
					TRANSMIT_BYTE_COUNT <= WR_DATA;
					ACK <= 1;
					end
				8'h52: 
					begin
					TX_BUF_HEADER_BYTE_0 <= WR_DATA;
 					ACK <= 1;	
					end
				8'h53: 
					begin
					TX_BUF_HEADER_BYTE_1 <= WR_DATA;
 					ACK <= 1;	
					end
				// TX Buffer
				8'h54:
					begin
					TX_BUF_OBJ1_BYTE_0 <= WR_DATA;
					ACK <= 1;
					end

				8'h55:
					begin
					TX_BUF_OBJ1_BYTE_1 <= WR_DATA;
					ACK <= 1;
					end

				8'h56:
					begin
					TX_BUF_OBJ1_BYTE_2 <= WR_DATA;
					ACK <= 1;
					end

				8'h57:
					begin
					TX_BUF_OBJ1_BYTE_3 <= WR_DATA;
					ACK <= 1;
					end

				8'h58:
					begin
					TX_BUF_OBJ2_BYTE_0 <= WR_DATA;
					ACK <= 1;
					end

				8'h59:
					begin
					TX_BUF_OBJ2_BYTE_1 <= WR_DATA;
					ACK <= 1;
					end

				8'h5a:
					begin
					TX_BUF_OBJ2_BYTE_2 <= WR_DATA;
					ACK <= 1;
					end

				8'h5b:
					begin
					TX_BUF_OBJ2_BYTE_3 <= WR_DATA;
					ACK <= 1;
					end
			endcase
			end 	//end else
		end	//end if(request
	end	//end always
endmodule
