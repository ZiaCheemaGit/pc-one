all: RV32I.png von_neuman.png clean

RV32I.json:
	yosys -p "read_verilog ../hardware/single_cycle_rv32i_core/*.v; hierarchy -top core; proc; opt; write_json RV32I.json"

von_neuman.json:
	yosys -p "read_verilog ../hardware/single_cycle_rv32i_core/*.v ../tests/single_cycle_rv32i_core/von_neuman/*.v; hierarchy -top top; proc; opt; write_json von_neuman.json"

RV32I.svg: RV32I.json
	netlistsvg RV32I.json -o RV32I.svg

von_neuman.svg: von_neuman.json
	netlistsvg von_neuman.json -o von_neuman.svg

RV32I.png: RV32I.svg
	rsvg-convert -b white RV32I.svg -o RV32I.png

von_neuman.png: von_neuman.svg
	rsvg-convert -b white von_neuman.svg -o von_neuman.png

clean:
	rm -f *.json *.svg
