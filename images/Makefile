all: MMU.png pc_one.png RAM.png RV32I.png UART.png clean

# Verilog to JSON

MMU.json:
	yosys -p "read_verilog ../hardware/MMU/*.v; hierarchy -top MMU; proc; opt; write_json MMU.json"

pc_one.json:
	yosys -p "read_verilog \
	../hardware/pc_one/pc_one.v \
	../hardware/UART/*.v \
	../hardware/single_cycle_rv32i_core/*.v \
	../hardware/RAMs/ram_16KB.v \
	../hardware/MMU/*.v; hierarchy -top pc_one; proc; opt; write_json pc_one.json"

RAM.json:
	yosys -p "read_verilog ../hardware/RAMs/*.v; hierarchy -top ram_16KB; proc; opt; write_json RAM.json"

RV32I.json:
	yosys -p "read_verilog ../hardware/single_cycle_rv32i_core/*.v; hierarchy -top core; proc; opt; write_json RV32I.json"

UART.json:
	yosys -p "read_verilog ../hardware/UART/*.v; hierarchy -top uart_tx; proc; opt; write_json UART.json"


# JSON to SVG

MMU.svg: MMU.json
	netlistsvg MMU.json -o MMU.svg

pc_one.svg: pc_one.json
	netlistsvg pc_one.json -o pc_one.svg

RAM.svg: RAM.json
	netlistsvg RAM.json -o RAM.svg

RV32I.svg: RV32I.json
	netlistsvg RV32I.json -o RV32I.svg

UART.svg: UART.json
	netlistsvg UART.json -o UART.svg


# SVG to PNG

MMU.png: MMU.svg
	rsvg-convert -b white MMU.svg -o MMU.png

pc_one.png: pc_one.svg
	rsvg-convert -b white pc_one.svg -o pc_one.png

RAM.png: RAM.svg
	rsvg-convert -b white RAM.svg -o RAM.png

RV32I.png: RV32I.svg
	rsvg-convert -b white RV32I.svg -o RV32I.png

UART.png: UART.svg
	rsvg-convert -b white UART.svg -o UART.png


# clean

clean:
	rm -f *.json *.svg

clean_png:
	rm -f *.png
