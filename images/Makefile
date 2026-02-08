all: MMU.png pc_one.png RAM.png ROM.png RV32I.png UART.png clean


# Verilog to JSON

MMU.json:
	yosys -p "read_verilog ../hardware/MMU/*.v; hierarchy -top MMU; proc; opt; write_json MMU.json"

pc_one.json:
	yosys -p "read_verilog \
	../hardware/pc_one/pc_one.v \
	../hardware/UART/*.v \
	../hardware/single_cycle_rv32i_core/*.v \
	../hardware/memory/ram.v \
	../hardware/memory/rom.v \
	../hardware/MMU/*.v; hierarchy -top pc_one; proc; opt; write_json pc_one.json"

RAM.json:
	yosys -p "read_verilog ../hardware/memory/ram.v; hierarchy -top ram; proc; opt; write_json RAM.json"

ROM.json:
	yosys -p "read_verilog ../hardware/memory/rom.v; hierarchy -top rom; proc; opt; write_json ROM.json"

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

ROM.svg: ROM.json
	netlistsvg ROM.json -o ROM.svg

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

ROM.png: ROM.svg
	rsvg-convert -b white ROM.svg -o ROM.png

RV32I.png: RV32I.svg
	rsvg-convert -b white RV32I.svg -o RV32I.png

UART.png: UART.svg
	rsvg-convert -b white UART.svg -o UART.png


# clean

clean:
	rm -f *.json *.svg

clean_png:
	rm -f *.png
