test_tcpc:
	make clean
	iverilog -o test.out -c test_all_setup
	vvp test.out 
	gtkwave testbench.vcd tests/all/default_sel.gtkw
	
test_tx:
	make clean
	iverilog -o test.out -c test_tx_setup
	vvp test.out 
	gtkwave testbench.vcd tests/tx/default_sel.gtkw
	
test_rx:
	make clean
	iverilog -o test.out -c test_rx_setup
	vvp test.out 
	gtkwave testbench.vcd tests/rx/default_sel.gtkw

test_i2c_slave:
	make clean
	iverilog -o test.out -c test_i2c_slave_setup
	vvp test.out 
	gtkwave testbench.vcd tests/i2c_slave/default_sel.gtkw	

clean:
	rm -f test.out testbench.vcd

