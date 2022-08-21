# archivo makefile para el proyecto

# NOTA: COMPILAR CON IVERILOG v11.0 O UNA VERSIÓN MÁS
# RECIENTE, PUESTO QUE IVERILOG ARROJA UN ERROR DE
# COMPILACIÓN PARA VERSIONES ANTERIORES A v11.0.

# corre todos los comandos (excepto síntesis)
# del PCS con simulación correcta (main datapath)
# escribir en consola >>> make all
all: gtk

# corre solo iverilog
ver: ./tester_tb/testbench.v
	iverilog -I ./src -I ./src/includes -I ./tester_tb -o ./out/testbench.vvp ./tester_tb/testbench.v

# corre solo vvp
vvp: ver
	vvp ./out/testbench.vvp

# corre solo gtkwave
gtk: vvp
	gtkwave ./out/testbench.vcd



# corre todos los comandos (excepto síntesis)
# de todas las simulaciones 
# escribir en consola >>> make all_all
all_all: gtk_all

# corre solo iverilog todas las pruebas
ver_all: ./tester_tb/tb_TX.v ./tester_tb/tb_SYNC.v ./tester_tb/tb_TX_SYNC.v ./tester_tb/tb_PCS.v ./tester_tb/tb_CS.v ./tester_tb/testbench.v
	iverilog -I ./src -I ./src/includes -I ./tester_tb -o ./out/tb_TX.vvp ./tester_tb/tb_TX.v
	iverilog -I ./src -I ./src/includes -I ./tester_tb -o ./out/tb_SYNC.vvp ./tester_tb/tb_SYNC.v
	iverilog -I ./src -I ./src/includes -I ./tester_tb -o ./out/tb_TX_SYNC.vvp ./tester_tb/tb_TX_SYNC.v
	iverilog -I ./src -I ./src/includes -I ./tester_tb -o ./out/tb_PCS.vvp ./tester_tb/tb_PCS.v
	iverilog -I ./src -I ./src/includes -I ./tester_tb -o ./out/tb_CS.vvp ./tester_tb/tb_CS.v
	iverilog -I ./src -I ./src/includes -I ./tester_tb -o ./out/testbench.vvp ./tester_tb/testbench.v

# corre solo vvp todas las pruebas
vvp_all: ver_all
	vvp ./out/tb_TX.vvp
	vvp ./out/tb_SYNC.vvp
	vvp ./out/tb_TX_SYNC.vvp
	vvp ./out/tb_PCS.vvp
	vvp ./out/tb_CS.vvp
	vvp ./out/testbench.vvp

# corre solo gtkwave todas las pruebas
gtk_all: vvp_all
	gtkwave ./out/tb_TX.vcd
	gtkwave ./out/tb_SYNC.vcd
	gtkwave ./out/tb_TX_SYNC.vcd
	gtkwave ./out/tb_PCS.vcd
	gtkwave ./out/tb_CS.vcd
	gtkwave ./out/testbench.vcd

# elimina archivos creados con make
clean:
	rm -f ./out/*