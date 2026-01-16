all: RV32I.png pc_one.png clean

RV32I.json:
	yosys -p "read_verilog ../hardware/single_cycle_rv32i_core/*.v; hierarchy -top core; proc; opt; write_json RV32I.json"

pc_one.json:
	yosys -p "read_verilog \
	../hardware/pc_one/pc_one.v \
	../hardware/UART/*.v \
	../hardware/single_cycle_rv32i_core/*.v \
	../hardware/RAMs/ram_16KB.v \
	../hardware/MMU/*.v; hierarchy -top pc_one; proc; opt; write_json pc_one.json"

RV32I.svg: RV32I.json
	netlistsvg RV32I.json -o RV32I.svg

pc_one.svg: pc_one.json
	netlistsvg pc_one.json -o pc_one.svg

RV32I.png: RV32I.svg
	rsvg-convert -b white RV32I.svg -o RV32I.png

pc_one.png: pc_one.svg
	rsvg-convert -b white pc_one.svg -o pc_one.png

clean:
	rm -f *.json *.svg

clean_png:
	rm -f *.png
