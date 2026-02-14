
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name windows_ise_project -dir "D:/git-clones/pc-one/FPGA_tests/test_uart/digilent_nexys3_spartan6/windows_ise_project/planAhead_run_1" -part xc6slx16csg324-3
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "top_nexys3.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {../../../../hardware/single_cycle_rv32i_core/sign_ext_12_to_32.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../../../hardware/single_cycle_rv32i_core/register_file.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../../../hardware/single_cycle_rv32i_core/pc_src_control.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../../../hardware/single_cycle_rv32i_core/pc.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../../../hardware/single_cycle_rv32i_core/mux_5X1.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../../../hardware/single_cycle_rv32i_core/mux_4X1.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../../../hardware/single_cycle_rv32i_core/main_alu.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../../../hardware/single_cycle_rv32i_core/control_unit.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../../../hardware/single_cycle_rv32i_core/alu_control.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../../../hardware/single_cycle_rv32i_core/adder32.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../../../hardware/UART/uart_tx.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../../../hardware/single_cycle_rv32i_core/core.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../../../hardware/RAMs/ram_16KB.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../../../hardware/MMU/MMU.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../../../hardware/pc_one/pc_one.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {top_nexys3.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set_property top top_nexys3 $srcset
add_files [list {top_nexys3.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc6slx16csg324-3
