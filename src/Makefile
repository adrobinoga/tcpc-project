test_tcpc:
	make clean
	./i2c_master_lib.py tests/all/tester.v
	iverilog -o test.out -c test_all_setup
	vvp test.out 
	gtkwave testbench.vcd tests/all/default_sel.gtkw

test_synth_tcpc:
	make clean
	yosys ys_scripts/synth_all.ys
	iverilog -o test.out -c test_all_setup
	vvp test.out 
	gtkwave testbench.vcd tests/all/default_sel.gtkw
	
test_tx:
	make clean
	iverilog -o test.out -c test_tx_setup modules/tx.v
	vvp test.out 
	gtkwave testbench.vcd tests/tx/default_sel.gtkw
		
test_rx:
	make clean
	iverilog -o test.out -c test_rx_setup modules/rx.v
	vvp test.out 
	gtkwave testbench.vcd tests/rx/default_sel.gtkw

test_synth_rx:
	make clean
	yosys ys_scripts/synth_rx.ys
	iverilog -o test.out -c test_rx_setup 
	vvp test.out 
	gtkwave testbench.vcd tests/rx/default_sel.gtkw

test_i2c_slave:
	make clean
	./i2c_master_lib.py tests/i2c_slave/tester.v
	iverilog -o test.out -c test_i2c_slave_setup modules/i2c_slave.v
	vvp test.out 
	gtkwave testbench.vcd tests/i2c_slave/default_sel.gtkw	

test_synth_i2c_slave:
	make clean
	yosys ys_scripts/synth_i2c_slave.ys
	./i2c_master_lib.py tests/i2c_slave/tester.v
	iverilog -o test.out -c test_i2c_slave_setup synth_modules/synthesized_i2c_slave.v
	vvp test.out 
	gtkwave testbench.vcd tests/i2c_slave/default_sel.gtkw		
	
clean:
	rm -f test.out testbench.vcd

