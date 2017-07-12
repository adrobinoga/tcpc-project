`include "definitions.v"
//-------------------------------------------------------------------------------------------
// Buffer

module BUF(A, Y);
input A;
output Y;
assign #10 Y = A;

// incrementa el contador de transiciones respectivo
always @(Y)
	begin
	testbench.m.mem[`BUF_DIR] = testbench.m.mem[`BUF_DIR] + 1;
	end

// incrementa el contador de elementos respectivo
initial
	begin
	#1
	testbench.m.mem_elem[`BUF_DIR] = testbench.m.mem_elem[`BUF_DIR] + 1;
	end

endmodule


//-------------------------------------------------------------------------------------------
// Inversor

module NOT(A, Y);
input A;
output Y;
assign #7 Y = ~A;

// incrementa el contador de transiciones respectivo
always @(Y)
	begin
	testbench.m.mem[`INV_DIR] = testbench.m.mem[`INV_DIR] + 1;
	end

// incrementa el contador de elementos respectivo
initial
	begin
	#1
	testbench.m.mem_elem[`INV_DIR] = testbench.m.mem_elem[`INV_DIR] + 1;
	end
	
endmodule


//-------------------------------------------------------------------------------------------
// Nand

module NAND(A, B, Y);
input A, B;
output Y;
assign #7 Y = ~(A & B);

// incrementa el contador de transiciones respectivo
always @(Y)
	begin
	testbench.m.mem[`NAND_DIR] = testbench.m.mem[`NAND_DIR] + 1;
	end

// incrementa el contador de elementos respectivo
initial
	begin
	#1
	testbench.m.mem_elem[`NAND_DIR] = testbench.m.mem_elem[`NAND_DIR] + 1;
	end

endmodule


//-------------------------------------------------------------------------------------------
module NOR(A, B, Y);
input A, B;
output Y;
assign #10 Y = ~(A | B);

// incrementa el contador de transiciones respectivo
always @(Y)
	begin
	testbench.m.mem[`NOR_DIR] = testbench.m.mem[`NOR_DIR] + 1;
	end

// incrementa el contador de elementos respectivo
initial
	begin
	#1
	testbench.m.mem_elem[`NOR_DIR] = testbench.m.mem_elem[`NOR_DIR] + 1;
	end

endmodule


//-------------------------------------------------------------------------------------------
// Flip flop tipo D sin reset

module DFF(C, D, Q);
input C, D;
output reg Q;
always @(posedge C)
	Q <= #12 D;
	
// incrementa el contador de transiciones respectivo
always @(Q)
	begin
	testbench.m.mem[`DFF_DIR] = testbench.m.mem[`DFF_DIR] + 1;
	end

// incrementa el contador de elementos respectivo
initial
	begin
	#1
	testbench.m.mem_elem[`DFF_DIR] = testbench.m.mem_elem[`DFF_DIR] + 1;
	end
	
endmodule


//-------------------------------------------------------------------------------------------
// Flip flop con set, reset asincronicos

module DFFSR(C, D, Q, S, R);
input C, D, S, R;
output reg Q;
always @(posedge C, posedge S, posedge R)
	if (S)
		Q <= #12 1'b1;
	else if (R)
		Q <= #12 1'b0;
	else
		Q <= #12 D;
		
// incrementa el contador de transiciones respectivo
always @(Q)
	begin
	testbench.m.mem[`DFFSR_DIR] = testbench.m.mem[`DFFSR_DIR] + 1;
	end

// incrementa el contador de elementos respectivo
initial
	begin
	#1
	testbench.m.mem_elem[`DFFSR_DIR] = testbench.m.mem_elem[`DFFSR_DIR] + 1;
	end
	
endmodule

