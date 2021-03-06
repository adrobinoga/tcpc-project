// I2C Slave

module i2c_slave(
	output reg [7:0] D,	// registro donde escribe el master
	output reg D_ready,	// bandera para indicar dato listo
	output reg [3:0] bit_count, 	// contador de bit transmitidos/enviados
	output reg start,
	output reg stop,
	output reg RW,		// bit de escritura/lectura
	output reg nack,
	output reg Q_done,
	output address_match,
	
	inout SDA,		// linea de datos 
	inout SCL,		// linea del reloj i2c
	input [7:0] Q,		// registro a enviar al master
	input CLK,		// reloj
	input ENB,		// enable del modulo
	input RESET		// reset del modulo
);

localparam dev_addr = 7'h60;	// direccion del dispositivo

// declaracion de estados
localparam 	IDLE=		0,
		READ_ADDR=	1,
		SEND_ACK=	2, 
		WRITING=	3,
		READING=	4,
		WAIT_ACK1=	5,
		WAIT_ACK2=	6,
		WAIT_STOP=	7,
		WAIT_NEGSTART=  8
		;

// banderas
reg posedge_SCL;
reg negedge_SCL;

reg set_nack;

reg [3:0] state;	// Current state
reg [3:0] next_state; 	// Next state

reg SCL_d;	// valor de SCL retrasado
reg SDA_d;	// valor de SDA retrasado

reg inc_count;		// activa el contador de bits
reg rst_count;		// resetea el contador de bits
reg keep_reading;
reg next_keep_reading;
reg set_reading;

// registros intermedios para manejar los puertos bidireccionales
reg SDA_o;
reg SCL_o;
reg SDA_en;
reg SCL_en;

// manejo de los puertos bidireccionales
//assign SDA = SDA_en ? SDA_o : 1'bZ ;
//assign SCL = SCL_en ? SCL_o : 1'bZ ;

TRIBUF tri_sda (.IN(SDA_o), .OUT(SDA), .EN(SDA_en));
TRIBUF tri_scl (.IN(SCL_o), .OUT(SCL), .EN(SCL_en));

// compara direccion del dispositivo
wire address_match;
assign address_match = !(D[7:1]^dev_addr);

// retraso del valor de SDA y SCL
always @(posedge CLK)
	begin
	SDA_d <=  SDA;
	SCL_d <=  SCL;
	end

// activa las condiciones start/stop cuando se presentan

always @(*)
	begin
	start = 0;
	stop = 0;
	if (SCL)
		begin
		if (SDA && (!SDA_d))
			begin
			//posedge
			stop = 1;
			end
		if ((!SDA) && SDA_d)
			begin
			//negedge
			start = 1;
			end
		end
	end
	
// activa las banderas para los flancos de SCL
always @(posedge CLK)
	begin
	posedge_SCL <= 0;
	negedge_SCL <= 0;
	if (SCL & !SCL_d)
		//posedge
		posedge_SCL <= 1;
	if (!SCL & SCL_d)
		//negedge
		negedge_SCL <= 1;
		
	if (rst_count)
		bit_count <= 0;
	else
		begin
		if (negedge_SCL)
			if (inc_count)
				bit_count <= bit_count + 1;
		end
	
	// manejo de keep reading
	if (set_reading)
		keep_reading <= next_keep_reading;
	
	if (RESET) 
		begin
		bit_count <= 0;
		keep_reading <= 0;
		end
		
	if (set_nack)
		nack <= 1;
	else 
		nack <= 0;
		
	end

// Carga de proximo estado
always @(posedge CLK) 
	begin
	if (RESET) 
		begin
		state <= IDLE;
		end 
	else 
		begin
		state <= next_state;
		end
	end	
	
always @(posedge CLK)
	begin
	if (RESET)
		begin
		D <= 0;
		RW <= 0;
		end
	case (state)
		READ_ADDR:
			begin
			if (SCL)
				D[7-bit_count] <= SDA;
			if (bit_count == 7)
				RW <= SDA;
			end
		READING:
			begin
			end
			
		WRITING:
			begin
			if (SCL)
				D[7-bit_count] <= SDA;
			end
	endcase
	end
	
// Logica de proximo estado
always @(*)
	begin
	next_state = state;
	case (state)
		IDLE: // espera por una condicion START
			begin 
			if (start)
				next_state = WAIT_NEGSTART;
			else
				next_state = IDLE;
			end
			
		WAIT_NEGSTART:
			begin
			if (negedge_SCL)
				next_state = READ_ADDR;
			end
			
		READ_ADDR:
			begin
			if (address_match==1 & bit_count==7 & negedge_SCL)
				next_state = SEND_ACK;
			if (address_match==0 & bit_count==8 & negedge_SCL)
				next_state = IDLE;
			end
		
		SEND_ACK:
			begin
			if (negedge_SCL & !RW)
				next_state = WRITING;
			if (negedge_SCL & RW)
				next_state = READING;
			end
			
		WRITING:
			if (negedge_SCL & bit_count==7)
				next_state = SEND_ACK;
				
		READING:
			begin
			if (negedge_SCL & bit_count==7)
				next_state = WAIT_ACK1;
			end
		
		WAIT_ACK1:
			begin
			if (posedge_SCL)
				next_state = WAIT_ACK2;
			end
			
		WAIT_ACK2:
			begin
			if (negedge_SCL)
				begin
				if (keep_reading)
					begin
					if (RW)
						next_state = READING;
					else
						next_state = WRITING;
					end
				else
					begin
					next_state = WAIT_STOP;
					end
				end
			end
			
		WAIT_STOP:
			begin
			if (stop)
				next_state = IDLE;
			end
		default:
			next_state = IDLE;
	endcase
	
	if (stop)
		next_state = IDLE;
	if (start)
		next_state = WAIT_NEGSTART;
	end


				
// Logica de salidas
always @(*)
	begin
	
	case (state)
		IDLE:
			begin 
			inc_count = 		0;
			rst_count = 		1;
			D_ready = 		0;
			Q_done = 		0;
			SDA_en = 		0;
			SDA_o = 		0;
			SCL_en = 		0;
			SCL_o =			0;
			set_reading = 		1;
			next_keep_reading = 	0;
			set_nack =		0;
			end
			
		WAIT_NEGSTART:
			begin
			inc_count = 		0;
			rst_count = 		1;
			D_ready = 		0;
			Q_done = 		0;
			SDA_en = 		0;
			SDA_o = 		0;
			SCL_en = 		0;
			SCL_o =			0;
			set_reading = 		0;
			next_keep_reading = 	0;
			set_nack =		0;
			end
				
		READ_ADDR:
			begin
			inc_count = 		1;
			rst_count = 		0;
			D_ready = 		0;
			Q_done = 		0;
			SDA_en = 		0;
			SDA_o = 		0;
			SCL_en = 		0;
			SCL_o =			0;
			set_reading = 		0;
			next_keep_reading = 	0;
			set_nack =		0;
			end
		
		SEND_ACK:
			begin
			inc_count = 		0;
			rst_count = 		1;
			D_ready = 		0;
			Q_done = 		0;
			SDA_en = 		1;
			SDA_o = 		0;
			SCL_en = 		0;
			SCL_o =			0;
			set_reading = 		0;
			next_keep_reading = 	0;
			set_nack =		0;
			end
			
		WRITING:	
			begin
			inc_count = 		1;
			rst_count = 		0;
			D_ready = 		0;
			Q_done = 		0;
			SDA_en = 		0;
			SDA_o = 		0;
			SCL_en = 		0;
			SCL_o =			0;
			if (negedge_SCL & bit_count==7)
				D_ready = 1;
			set_reading = 		0;
			next_keep_reading = 	0;
			set_nack =		0;
			end
				
		READING:
			begin
			inc_count = 		1;
			rst_count = 		0;
			D_ready = 		0;
			Q_done = 		0;
			SDA_en = 		1;
			SDA_o = 		Q[7-bit_count];
			SCL_en = 		0;
			SCL_o =			0;
			set_reading = 		0;
			next_keep_reading = 	0;
			set_nack =		0;
			if (negedge_SCL & bit_count==7)
				Q_done = 1;
			end
		
		WAIT_ACK1:
			begin
			inc_count = 		0;
			rst_count = 		0;
			D_ready = 		0;
			Q_done = 		0;
			SDA_en = 		0;
			SDA_o = 		0;
			SCL_en = 		0;
			SCL_o =			0;
			set_reading = 		0;
			next_keep_reading = 	0;
			set_nack =		0;
			end
			
		WAIT_ACK2:
			begin
			inc_count = 		0;
			rst_count = 		1;
			D_ready = 		0;
			Q_done = 		0;
			SDA_en = 		0;
			SDA_o = 		0;
			SCL_en = 		0;
			SCL_o =			0;
			set_nack =		0;
			if (SCL)
				begin
				set_reading = 		1;
				next_keep_reading = 	!SDA;
				set_nack =		SDA;
				end
			else
				begin
				set_reading = 		0;
				next_keep_reading = 	0;
				end
			end
			
		WAIT_STOP:
			begin
			inc_count = 		0;
			rst_count = 		0;
			D_ready = 		0;
			Q_done = 		0;
			SDA_en = 		0;
			SDA_o = 		0;
			SCL_en = 		0;
			SCL_o =			0;
			set_reading = 		0;
			next_keep_reading = 	0;
			set_nack =		0;
			end
			
		default:
			begin
			inc_count = 		0;
			rst_count = 		0;
			D_ready = 		0;
			Q_done = 		0;
			SDA_en = 		0;
			SDA_o = 		0;
			SCL_en = 		0;
			SCL_o =			0;
			set_reading = 		1;
			next_keep_reading = 	0;
			set_nack =		0;
			end
	endcase
	end

endmodule
