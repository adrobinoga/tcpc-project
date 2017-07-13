module tcpc(
	input CLK,
	input RESET,
	
	// bus I2C
	inout SDA,
	inout SCL
	
);



//------------------------------------------------------------
// Conexiones I2C
wire [7:0] D;
wire D_ready;
wire [3:0] bit_count;
wire start;
wire stop;
wire RW;
wire nack;
wire address_match;
wire [7:0] Q;
wire Q_done;

//------------------------------------------------------------
// Conexiones del modulo registers

wire RNW;
wire REQUEST;
wire [7:0] ADDR;
wire [7:0] WR_DATA;
wire [7:0] RD_DATA;
wire ACK;

// Conexiones clientes-registers
wire REQ_Tx;
wire REQ_Rx;
wire REQ_HReset;
wire REQ_tcpm;

wire RNW_Tx;
wire RNW_Rx;
wire RNW_HReset;
wire RNW_tcpm;

wire [7:0] ADDR_Tx;
wire [7:0] ADDR_Rx;
wire [7:0] ADDR_HReset;
wire [7:0] ADDR_tcpm;

wire [7:0] WR_DATA_Tx;
wire [7:0] WR_DATA_Rx;
wire [7:0] WR_DATA_HReset;
wire [7:0] WR_DATA_tcpm;

wire [7:0] RD_DATA_Tx;
wire [7:0] RD_DATA_Rx;
wire [7:0] RD_DATA_HReset;
wire [7:0] RD_DATA_tcpm;

wire ACK_Tx; 
wire ACK_Rx;
wire ACK_HReset;
wire ACK_tcpm;

//------------------------------------------------------------
// Registros

wire [15:0] DEVICE_ID;
wire [15:0] USBTYPEC_REV;
wire [15:0] USBPD_REV_VER;
wire [15:0] PD_INTERFACE_REV;

wire [15:0] ALERT;
wire [15:0] ALERT_MASK;
wire [7:0] POWER_STATUS_MASK;
wire [7:0] FAULT_STATUS_MASK;

wire [7:0] TCPC_CONTROL;
wire [7:0] ROLE_CONTROL;
wire [7:0] FAULT_CONTROL;
wire [7:0] POWER_CONTROL;

wire [7:0] CC_STATUS;
wire [7:0] POWER_STATUS;
wire [7:0] FAULT_STATUS;
wire [7:0] COMMAND;

wire [15:0] DEVICE_CAPABILITIES_1;
wire [15:0] DEVICE_CAPABILITIES_2;
wire [7:0] STANDARD_INPUT_CAPABILITIES;
wire [7:0] STANDARD_OUTPUT_CAPABILITIES;

wire [7:0] MESSAGE_HEADER_INFO;
wire [7:0] RECEIVE_DETECT;
wire [7:0] RECEIVE_BYTE_COUNT;

wire [7:0] RX_BUF_FRAME_TYPE;
wire [7:0] RX_BUF_HEADER_BYTE_0;
wire [7:0] RX_BUF_HEADER_BYTE_1;

wire [7:0] RX_BUF_OBJ1_BYTE_0;
wire [7:0] RX_BUF_OBJ1_BYTE_1;
wire [7:0] RX_BUF_OBJ1_BYTE_2;
wire [7:0] RX_BUF_OBJ1_BYTE_3;
wire [7:0] RX_BUF_OBJ2_BYTE_0;
wire [7:0] RX_BUF_OBJ2_BYTE_1;
wire [7:0] RX_BUF_OBJ2_BYTE_2;
wire [7:0] RX_BUF_OBJ2_BYTE_3;

wire [7:0] TRANSMIT;
wire [7:0] TRANSMIT_BYTE_COUNT;
wire [7:0] TX_BUF_HEADER_BYTE_0;	
wire [7:0] TX_BUF_HEADER_BYTE_1;

wire [7:0] TX_BUF_OBJ1_BYTE_0;
wire [7:0] TX_BUF_OBJ1_BYTE_1;
wire [7:0] TX_BUF_OBJ1_BYTE_2;
wire [7:0] TX_BUF_OBJ1_BYTE_3;
wire [7:0] TX_BUF_OBJ2_BYTE_0;
wire [7:0] TX_BUF_OBJ2_BYTE_1;
wire [7:0] TX_BUF_OBJ2_BYTE_2;
wire [7:0] TX_BUF_OBJ2_BYTE_3;

wire [15:0] VBUS_VOLTAGE;
//------------------------------------------------------------


//------------------------------------------------------------
// rx rxu();
//------------------------------------------------------------

//------------------------------------------------------------
// tx txu();
//------------------------------------------------------------



//------------------------------------------------------------
// Interfaz I2C
i2c_slave i2c_slave_u(
		.SDA(SDA),
		.SCL(SCL),
		
		// salidas hacia el manager de i2c
		.D(D),
		.D_ready(D_ready),
		.bit_count(bit_count),
		.start(start),
		.stop(stop),
		.RW(RW),
		.nack(nack),
		.Q_done(Q_done),
		.address_match(address_match),
		
		.Q(Q),
		.CLK(CLK),
		.ENB(1'b1),
		.RESET(RESET)
);
//------------------------------------------------------------



//------------------------------------------------------------
i2c_slave_mg i2c_slave_mg_u(
		.CLK(CLK),
		.RESET(RESET),
		
		// entradas provenientes del i2c_slave
		.D(D),
		.D_ready(D_ready),
		.bit_count(bit_count),
		.start(start),
		.stop(stop),
		.RW(RW),
		.nack(nack),
		.address_match(address_match),
		.Q_done(Q_done),
		
		// salidas hacia el i2c
		.Q(Q),
		
		// entradas provenientes de regs_writer
		.RD_DATA_tcpm(RD_DATA_tcpm),
		.ACK_tcpm(ACK_tcpm),
		
		// salidas hacia regs_writer
		.REQ_tcpm(REQ_tcpm),
		.RNW_tcpm(RNW_tcpm),
		.ADDR_tcpm(ADDR_tcpm),
		.WR_DATA_tcpm(WR_DATA_tcpm)
);
//------------------------------------------------------------



//------------------------------------------------------------
// Modulo gestor de acceso del modulo registros
regs_writer regs_writer_u(
	// puertos cliente
	.REQ_tcpm(REQ_tcpm),
	.REQ_HReset(REQ_HReset),
	.REQ_Rx(REQ_Rx),
	.REQ_Tx(REQ_Tx),
	
	.RNW_tcpm(RNW_tcpm),
	.RNW_HReset(RNW_HReset),
	.RNW_Rx(RNW_Rx),
	.RNW_Tx(RNW_Tx),
	
	.ADDR_tcpm(ADDR_tcpm),
	.ADDR_HReset(ADDR_HReset),
	.ADDR_Rx(ADDR_Rx),
	.ADDR_Tx(ADDR_Tx),
	
	.WR_DATA_tcpm(WR_DATA_tcpm),
	.WR_DATA_HReset(WR_DATA_HReset),
	.WR_DATA_Rx(WR_DATA_Rx),
	.WR_DATA_Tx(WR_DATA_Tx),
	
	.RD_DATA_tcpm(RD_DATA_tcpm),
	.RD_DATA_HReset(RD_DATA_HReset),
	.RD_DATA_Rx(RD_DATA_Rx),
	.RD_DATA_Tx(RD_DATA_Tx),
	
	.ACK_tcpm(ACK_tcpm),
	.ACK_HReset(ACK_HReset),
	.ACK_Rx(ACK_Rx),
	.ACK_Tx(ACK_Tx),
	
	// salidas para controlar el modulo registers
	.WR_DATA(WR_DATA),
	.ADDR(ADDR),
	.REQUEST(REQUEST),
	.RNW(RNW),	
	
	// salidas obtenidas del modulo registers 
	.ACK(ACK),
	.RD_DATA(RD_DATA)
);

//------------------------------------------------------------



//------------------------------------------------------------
// Modulo de registros
registers registers_u(
	.CLK(CLK),
	
	// entradas de control
	.RNW(RNW), 
	.REQUEST(REQUEST),
	.ADDR(ADDR),
	.WR_DATA(WR_DATA),
	
	// salidas de control
	.RD_DATA(RD_DATA), 
	.ACK(ACK),
	
	// registros de uso inmediato
	.DEVICE_ID(DEVICE_ID),      				              		
	.USBTYPEC_REV(USBTYPEC_REV),					    	
	.USBPD_REV_VER(USBPD_REV_VER),				    		
	.PD_INTERFACE_REV(PD_INTERFACE_REV),	
			   		
	.ALERT(ALERT),						    		
	.ALERT_MASK(ALERT_MASK),				    		
	.POWER_STATUS_MASK(POWER_STATUS_MASK),			    	
	.FAULT_STATUS_MASK(FAULT_STATUS_MASK),			    	  		
	
	.TCPC_CONTROL(TCPC_CONTROL),				    		
	.ROLE_CONTROL(ROLE_CONTROL),				    		
	.FAULT_CONTROL(FAULT_CONTROL),				    		
	.POWER_CONTROL(POWER_CONTROL),				    		
	
	.CC_STATUS(CC_STATUS),					    		
	.POWER_STATUS(POWER_STATUS),				    		
	.FAULT_STATUS(FAULT_STATUS),					 		    
	.COMMAND(COMMAND),							    	
	
	.DEVICE_CAPABILITIES_1(DEVICE_CAPABILITIES_1), 		 	  		
	.DEVICE_CAPABILITIES_2(DEVICE_CAPABILITIES_2), 		   		
	.STANDARD_INPUT_CAPABILITIES(STANDARD_INPUT_CAPABILITIES), 	  	
	.STANDARD_OUTPUT_CAPABILITIES(STANDARD_OUTPUT_CAPABILITIES), 	  		
	
	.MESSAGE_HEADER_INFO(MESSAGE_HEADER_INFO), 					
	.RECEIVE_DETECT(RECEIVE_DETECT), 						
	.RECEIVE_BYTE_COUNT(RECEIVE_BYTE_COUNT), 			 		

	.RX_BUF_FRAME_TYPE(RX_BUF_FRAME_TYPE), 					
	.RX_BUF_HEADER_BYTE_0(RX_BUF_HEADER_BYTE_0), 			 		
	.RX_BUF_HEADER_BYTE_1(RX_BUF_HEADER_BYTE_1),			  	
	
	.RX_BUF_OBJ1_BYTE_0(RX_BUF_OBJ1_BYTE_0), 			 		
	.RX_BUF_OBJ1_BYTE_1(RX_BUF_OBJ1_BYTE_1),			  		
	.RX_BUF_OBJ1_BYTE_2(RX_BUF_OBJ1_BYTE_2), 			 		
	.RX_BUF_OBJ1_BYTE_3(RX_BUF_OBJ1_BYTE_3),			 	
	.RX_BUF_OBJ2_BYTE_0(RX_BUF_OBJ2_BYTE_0),			 	
	.RX_BUF_OBJ2_BYTE_1(RX_BUF_OBJ2_BYTE_1),			 	
	.RX_BUF_OBJ2_BYTE_2(RX_BUF_OBJ2_BYTE_2),			 	
	.RX_BUF_OBJ2_BYTE_3(RX_BUF_OBJ2_BYTE_3), 			 		

	.TRANSMIT(TRANSMIT),							
	.TRANSMIT_BYTE_COUNT(TRANSMIT_BYTE_COUNT), 	
	.TX_BUF_HEADER_BYTE_0(TX_BUF_HEADER_BYTE_0), 			
	.TX_BUF_HEADER_BYTE_1(TX_BUF_HEADER_BYTE_1),
	 	
	.TX_BUF_OBJ1_BYTE_0(TX_BUF_OBJ1_BYTE_0), 			 		
	.TX_BUF_OBJ1_BYTE_1(TX_BUF_OBJ1_BYTE_1),			  		
	.TX_BUF_OBJ1_BYTE_2(TX_BUF_OBJ1_BYTE_2), 			 		
	.TX_BUF_OBJ1_BYTE_3(TX_BUF_OBJ1_BYTE_3),			 	
	.TX_BUF_OBJ2_BYTE_0(TX_BUF_OBJ2_BYTE_0),			 	
	.TX_BUF_OBJ2_BYTE_1(TX_BUF_OBJ2_BYTE_1),			 	
	.TX_BUF_OBJ2_BYTE_2(TX_BUF_OBJ2_BYTE_2),			 	
	.TX_BUF_OBJ2_BYTE_3(TX_BUF_OBJ2_BYTE_3),					
	
	.VBUS_VOLTAGE(VBUS_VOLTAGE)
); 	
//------------------------------------------------------------

endmodule
