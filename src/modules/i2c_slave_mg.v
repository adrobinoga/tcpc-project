module i2c_slave_mg(
	input CLK,
	input RESET,
	
	// entradas provenientes de i2c_slave
	input [7:0] D,	// valor obtenido del bus
	input D_ready,
	input [3:0] bit_count,
	input start,
	input stop,
	input RW,
	input nack,
	input address_match,
	
	// salidas hacia i2c_slave
	output [7:0] Q, 	// valor a escribir en el bus
	output Q_done,
	
	// entradas provenientes de regs_writer
	input [7:0] RD_DATA_tcpm,
	input ACK_tcpm,
	
	// salidas hacia regs_writer
	output reg REQ_tcpm,
	output reg RNW_tcpm,
	output reg [7:0] ADDR_tcpm,
	output [7:0] WR_DATA_tcpm
);

//-----------------------------------------------------------------
// declaracion de estados
localparam 	IDLE =			0,
		WAIT_MATCH_ADDR =	1,
		STORE_REG_ADDR =	2, 
		READ_BYTE_FROM_BUS =	3,
		WRITE_REG =		4,
		READING_INC_ADDR =	5,
		WRITE_BYTE_2BUS =	6,
		WRITING_INC_ADDR =	7
		;
		
reg [7:0] state;
reg [7:0] next_state;

reg load_addr;
reg [7:0] next_addr;
reg inc_addr;
reg load_wr_data;
reg [7:0] next_wr_data;

assign Q = RD_DATA_tcpm;

assign WR_DATA_tcpm = D;
//-----------------------------------------------------------------
// memoria de estado
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
		ADDR_tcpm <= 0;
		end
	else
		begin
		if (load_addr)
			ADDR_tcpm <= next_addr;
		else
			begin
			if (inc_addr)
				ADDR_tcpm <= ADDR_tcpm + 1;
			end
		end
	end
	
//-----------------------------------------------------------------
// logica de proximo estado
always @(*)
	begin
	next_state = state;
	case (state)
		IDLE:
			begin
			if (start)
				next_state = WAIT_MATCH_ADDR;
			end
		
		WAIT_MATCH_ADDR:
			begin
			if (bit_count == 8)
				begin
				if (address_match)
					begin
					if (RW)
						begin
						next_state = WRITE_BYTE_2BUS;
						end
					else
						begin
						next_state = STORE_REG_ADDR;
						end
					end
				else
					begin
					next_state = IDLE;
					end
				end
			end
		
		STORE_REG_ADDR:
			begin
			if (bit_count == 8)
				next_state = READ_BYTE_FROM_BUS;
			end
		
		READ_BYTE_FROM_BUS:
			begin
			if (start)
				next_state = WAIT_MATCH_ADDR;
			else
				if (D_ready)
					next_state = WRITE_REG;
			end
		
		WRITE_REG:
			begin
			next_state = READING_INC_ADDR;
			end
		
		READING_INC_ADDR:
			begin
			next_state = READ_BYTE_FROM_BUS;
			end
			
		WRITE_BYTE_2BUS:
			begin
			if (Q_done)
				next_state = WRITING_INC_ADDR;
			if (nack)
				next_state = IDLE;
			end
			
		WRITING_INC_ADDR:
			begin
			next_state = WRITE_BYTE_2BUS;
			end
	endcase
	
	if (stop)
		next_state = IDLE;
	
	end
	
	
//-----------------------------------------------------------------		
// logica de salidas
always @(*)
	begin
	case (state)
		IDLE:
			begin
			load_addr = 	1'b0;
			next_addr = 	8'b0;
			inc_addr =	1'b0;
			REQ_tcpm = 	1'b0;
			RNW_tcpm =	1'b1;
			end
		
		WAIT_MATCH_ADDR:
			begin
			load_addr = 	1'b0;
			next_addr = 	8'b0;
			inc_addr =	1'b0;
			REQ_tcpm = 	1'b0;
			RNW_tcpm =	1'b1;
			end
		
		STORE_REG_ADDR:
			begin
			load_addr = 	1'b1;
			next_addr = 	D;
			inc_addr =	1'b0;
			REQ_tcpm = 	1'b0;
			RNW_tcpm =	1'b1;
			end
		
		READ_BYTE_FROM_BUS:
			begin
			load_addr = 	1'b0;
			next_addr = 	8'b0;
			inc_addr =	1'b0;
			REQ_tcpm = 	1'b0;
			RNW_tcpm =	1'b1;
			end
		
		WRITE_REG:
			begin
			load_addr = 	1'b0;
			next_addr = 	8'b0;
			inc_addr =	1'b0;
			REQ_tcpm = 	1'b1;
			RNW_tcpm =	1'b0;
			end
		
		READING_INC_ADDR:
			begin
			load_addr = 	1'b0;
			next_addr = 	8'b0;
			inc_addr =	1'b1;
			REQ_tcpm = 	1'b0;
			RNW_tcpm =	1'b1;
			end
			
		WRITE_BYTE_2BUS:
			begin
			load_addr = 	1'b0;
			next_addr = 	8'b0;
			inc_addr =	1'b0;
			REQ_tcpm = 	1'b1;
			RNW_tcpm =	1'b1;
			end
			
		WRITING_INC_ADDR:
			begin
			load_addr = 	1'b0;
			next_addr = 	8'b0;
			inc_addr =	1'b1;
			REQ_tcpm = 	1'b1;
			RNW_tcpm =	1'b1;
			end
	endcase
	end
	
endmodule

