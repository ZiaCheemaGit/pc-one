all: MMU.png pc_one.png RAM.png ROM.png RV32I_SINGLE_CYCLE.png UART.png RV32I_FIVE_STAGE_PIPELINED.png clean


# Verilog to JSON

MMU.json:
	yosys -p "read_verilog ../../hardware/MMU/*.v; hierarchy -top MMU; proc; opt; write_json MMU.json"

pc_one.json:
	yosys -p "read_verilog -lib ../../hardware/memories/ram.v ../../hardware/memories/boot_rom.v ../../hardware/VGA/vram.v; \
	read_verilog \
	../../hardware/pc_one/pc_one.v \
	../../hardware/UART/*.v \
	../../hardware/processors/single_cycle_rv32i_core/*.v \
	../../hardware/processors/lib/*.v \
	../../hardware/VGA/vga_controller.v \
	../../hardware/MMU/*.v; \
	hierarchy -top pc_one; proc; opt; write_json -compat-int pc_one.json"

RAM.json:
	yosys -p "read_verilog ../../hardware/memories/ram.v; hierarchy -top ram; proc; opt; write_json RAM.json"

ROM.json:
	yosys -p "read_verilog ../../hardware/memories/boot_rom.v; hierarchy -top boot_rom; proc; opt; write_json ROM.json"

RV32I_SINGLE_CYCLE.json:
	yosys -p "read_verilog \
	../../hardware/processors/single_cycle_rv32i_core/*.v \
	../../hardware/processors/lib/*.v; \
	hierarchy -top single_cycle_rv32i_core; proc; opt; write_json RV32I_SINGLE_CYCLE.json"

RV32I_FIVE_STAGE_PIPELINED.json:
	yosys -p "read_verilog \
	../../hardware/processors/five_stage_pipelined_rv32i_core/*.v \
	../../hardware/processors/lib/*.v; \
	hierarchy -top five_stage_pipelined_rv32i_core; proc; opt; write_json RV32I_FIVE_STAGE_PIPELINED.json"

UART.json:
	yosys -p "read_verilog ../../hardware/UART/*.v; hierarchy -top uart_tx; proc; opt; write_json UART.json"


# JSON to SVG

MMU.svg: MMU.json
	netlistsvg MMU.json -o MMU.svg

pc_one.svg: pc_one.json
	netlistsvg pc_one.json -o pc_one.svg

RAM.svg: RAM.json
	netlistsvg RAM.json -o RAM.svg

ROM.svg: ROM.json
	netlistsvg ROM.json -o ROM.svg

RV32I_SINGLE_CYCLE.svg: RV32I_SINGLE_CYCLE.json
	netlistsvg RV32I_SINGLE_CYCLE.json -o RV32I_SINGLE_CYCLE.svg

RV32I_FIVE_STAGE_PIPELINED.svg: RV32I_FIVE_STAGE_PIPELINED.json
	netlistsvg RV32I_FIVE_STAGE_PIPELINED.json -o RV32I_FIVE_STAGE_PIPELINED.svg

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

RV32I_SINGLE_CYCLE.png: RV32I_SINGLE_CYCLE.svg
	rsvg-convert -b white RV32I_SINGLE_CYCLE.svg -o RV32I_SINGLE_CYCLE.png

RV32I_FIVE_STAGE_PIPELINED.png: RV32I_FIVE_STAGE_PIPELINED.svg
	rsvg-convert -b white RV32I_FIVE_STAGE_PIPELINED.svg -o RV32I_FIVE_STAGE_PIPELINED.png

UART.png: UART.svg
	rsvg-convert -b white UART.svg -o UART.png


# clean

clean_all:
	rm -f *.json *.svg *.png

clean:
	rm -f *.json *.svg
