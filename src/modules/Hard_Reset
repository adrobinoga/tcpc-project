module HardResetTransmission(
		clk, hard_reset_L, cable_reset_L, max_reset_timer, phy_response,

		transmit, phy_request, ALERT_TransmitSuccessful, ALERT_TransmitSOPMessageFailed );

input		clk;
input		hard_reset_L;
input		cable_reset_L;
input	[31:0]  max_reset_timer;
input		phy_response;

output reg [2:0] transmit;
output reg phy_request;

output reg ALERT_TransmitSuccessful;
output reg ALERT_TransmitSOPMessageFailed;	//SOP*
//output reg [15:0] ALERT;



reg [31:0]	hard_reset_complete_timer;

reg [4:0]	state;
reg [4:0]	next_state;  //el profe dijo que era wire

reg [2:0] 	next_transmit;	//el profe dijo que era wire	
wire 		pu_reset_L;
reg [31:0]	next_hard_reset_complete_timer;  //el profe dijo que wire

reg fallo;
reg exito;

///////////////////////////////////////////////////////////////////
//
// Local Wires and Registers
//

localparam	HR_WAIT_FOR_HARD_RESET_REQUEST = 5'b00001;
localparam	HR_CONSTRUCT_MESSAGE = 5'b00010;		
localparam	HR_FAILURE = 5'b00100;
localparam	HR_SUCCESS = 5'b01000;
localparam	HR_REPORT = 5'b10000;

assign expired_timer = ~| hard_reset_complete_timer;
assign pu_reset_L = ~cable_reset_L || ~hard_reset_L ;
///////////////////////////////////////////////////////////////////

//FLIP-FLOPS, ya esta listo


always @(posedge clk) begin

	if(~pu_reset_L) begin

		state <= HR_WAIT_FOR_HARD_RESET_REQUEST;	//si el reset es 0, quedese en el primer estado y transmit=0
		transmit <= 3'b000;
		hard_reset_complete_timer <= max_reset_timer;

			end
	else	begin			//si el reset es 1, pasa al siguiente estado

		state <= next_state;
		transmit <= next_transmit;
		hard_reset_complete_timer <= next_hard_reset_complete_timer;					
		
	     	end

			end

//proximo estado, ya esta listo

always @(*) 	begin
	case(state)	
	   HR_WAIT_FOR_HARD_RESET_REQUEST:				//estado 1 esperar pedido de reset
			if(pu_reset_L) //creo que hay que cambiarlo a que cuando sea 1
			   begin
				next_state = HR_CONSTRUCT_MESSAGE;
			   end
			else begin
				next_state = HR_WAIT_FOR_HARD_RESET_REQUEST;
			     end

	   HR_CONSTRUCT_MESSAGE:				//estado 2 construir mensaje
			if(phy_response)
			   begin
				next_state = HR_SUCCESS;
			   end
			else if(expired_timer) 
			   begin
				next_state = HR_FAILURE;
                           end
			else 
				next_state = HR_CONSTRUCT_MESSAGE;

	   HR_FAILURE:						//estado 3 fallo
			   begin
				next_state = HR_REPORT;
			   end
	   HR_SUCCESS:						//estado 4 éxito
			   begin
				next_state = HR_REPORT;
			   end		
	   HR_REPORT:						//estado 5 mandar reporte

			   begin
				next_state = HR_WAIT_FOR_HARD_RESET_REQUEST;
			   end	
	endcase
   		end

//LOGICA DE SALIDAS

always @(*) 	begin

ALERT_TransmitSOPMessageFailed	<= 0;
ALERT_TransmitSuccessful <= 0;

	case(state)	
	   HR_WAIT_FOR_HARD_RESET_REQUEST:				
			if(~hard_reset_L)
			   begin
				next_transmit = 3'b101;
			   end

			else if(~cable_reset_L)
			   begin
				next_transmit = 3'b110;
			   end

	   HR_CONSTRUCT_MESSAGE:
			begin
			next_hard_reset_complete_timer = hard_reset_complete_timer - 1; //start hard reset complete timer
			phy_request = 1'b1;	//request phy to send hard or cable reset
			end

	   HR_FAILURE:	 
				begin //si el contador llego a 0
			phy_request = 1'b0;	//decirle al phy que deje de enviar hard o cable reset	
			fallo = 1;		//fallo1, exito0
			exito = 0;				
 				end
	   HR_SUCCESS:		
			 	begin		
			hard_reset_complete_timer = 32'b1;	//parar el contador, pone el contador en 1	
			fallo = 0;		//fallo0, exito1
			exito = 1;	
				end
	   HR_REPORT:	
			if (~fallo && ~exito)
					begin
			ALERT_TransmitSOPMessageFailed	<= 1'b0;	//no hay fallo
			ALERT_TransmitSuccessful <= 1'b0;        //no hay exito
					end

			else if (~fallo && exito)
					begin
			ALERT_TransmitSOPMessageFailed	<= 1'b1;	//mensaje de fallo
			ALERT_TransmitSuccessful <= 1'b0; //mensaje de exito
					end

			else if (fallo && ~exito)
					begin
			ALERT_TransmitSOPMessageFailed	<= 1'b0;	//mensaje de fallo
			ALERT_TransmitSuccessful <= 1'b1; //mensaje de exito
					end
	endcase
   		end

endmodule
