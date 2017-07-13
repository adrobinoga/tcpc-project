module regs_writer(
	input CLK,

	// entradas de control de los clientes
	input REQ_Tx,
	input REQ_Rx,
	input REQ_HReset,
	input REQ_tcpm,
	
	input RWN_Tx,
	input RWN_Rx,
	input RWN_HReset,
	input RWN_tcpm,
	
	input [7:0] ADDR_Tx,
	input [7:0] ADDR_Rx,
	input [7:0] ADDR_HReset,
	input [7:0] ADDR_tcpm,
	
	input [15:0] WR_DATA_Tx,
	input [15:0] WR_DATA_Rx,
	input [15:0] WR_DATA_HReset,
	input [15:0] WR_DATA_tcpm,
	
	input [15:0] RD_DATA_Tx,
	input [15:0] RD_DATA_Rx,
	input [15:0] RD_DATA_HReset,
	input [15:0] RD_DATA_tcpm,
	
	input ACK,
	
	output ACK_Tx, 
	output ACK_Rx,
	output ACK_HReset,
	output ACK_tcpm,	
		
	// control del los registros
	output reg [15:0] WR_DATA,
	output reg [7:0] ADDR,
	output reg REQUEST,
	output reg RWN,
	
	
);




/*

	input CLK,
	input RNW,			//indica si es read o write
	input REQUEST,			//solicitud para hacer una transferencia
	input [7:0] ADDR,		//direccion del registro
	input [15:0] WR_DATA,		// 16 bits de entrada
	output reg [15:0] RD_DATA,	//registro salida que va a leer a un registro
 	output reg ACK,

*/

