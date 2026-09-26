from cocotb.utils import get_sim_time

from python_helper.converter import binary_to_assembly

async def log_signals_single_cycle_rv32i(logger, dut):
    while True:
        await RisingEdge(dut.clk_from_FPGA)
        # PC
        try: 
            logger.critical(f"PC = {dut.instr_add.value.to_unsigned()}")
            logger.critical(f"PC = 0x{dut.instr_add.value.to_unsigned():08x}")
        except Exception:
            logger.critical(f"PC = {dut.instr_add.value}")

        # Instruction 
        try: 
            logger.info(f"instruction = {binary_to_assembly((dut.instruction.value.to_unsigned()))}")
        except Exception:
            logger.info(f"instruction = {dut.instruction.value}")

        # reg_write_control
        try: 
            logger.info(f"reg_write_control = {dut.core_instance.reg_file_instance.reg_write_control.value.to_unsigned()}")
        except Exception:
            logger.info(f"reg_write_control = {dut.core_instance.reg_file_instance.reg_write_control.value}")   

        # reg_write_data
        try: 
            logger.info(f"reg_write_data = {dut.core_instance.reg_file_instance.reg_write_data.value.to_unsigned()} or " + 
                        f"0x{dut.core_instance.reg_file_instance.reg_write_data.value.to_unsigned():08x}")
        except Exception:
            logger.info(f"reg_write_data = {dut.core_instance.reg_file_instance.reg_write_data.value}")   

        # dest_reg
        try: 
            logger.info(f"dest_reg = {dut.core_instance.reg_file_instance.dest_reg.value.to_unsigned()}")
        except Exception:
            logger.info(f"dest_reg = {dut.core_instance.reg_file_instance.dest_reg.value}")   

        # mem_write
        try: 
            logger.info(f"ram_mem_write = {dut.ram_instance.mem_write.value.to_unsigned()}")
        except Exception:
            logger.info(f"ram_mem_write = {dut.ram_instance.mem_write.value}")

        # data_in
        try: 
            logger.info(f"data_in ram = {dut.ram_instance.data_in.value.to_unsigned()} or " +
                        f"0x{dut.ram_instance.data_in.value.to_unsigned():08x}")
        except Exception:
            logger.info(f"data_in ram = {dut.ram_instance.data_in.value}")

        # mem_read
        try: 
            logger.info(f"ram_mem_read = {dut.ram_instance.mem_read.value.to_unsigned()}")
        except Exception:
            logger.info(f"ram_mem_read = {dut.ram_instance.mem_read.value}")

        # data_out
        try: 
            logger.info(f"data_out of ram = {dut.ram_instance.data_out.value.to_unsigned()} or " + 
                        f"0x{dut.ram_instance.data_out.value.to_unsigned():08x}")
        except Exception:
            logger.info(f"data_out of ram = {dut.ram_instance.data_out.value}")

        # data_address
        try: 
            logger.info(f"data_address = {dut.ram_instance.data_address.value.to_unsigned()} or " + 
                        f"0x{dut.ram_instance.data_address.value.to_unsigned():08x}")
        except Exception:
            logger.info(f"data_address = {dut.ram_instance.data_address.value}")

        # MMU mem_write_cpu
        try: 
            logger.info(f"MMU mem_write_cpu = {dut.MMU_instance.mem_write_cpu.value.to_unsigned()}")
        except Exception:
            logger.info(f"MMU mem_write_cpu = {dut.MMU_instance.mem_write_cpu.value}")

        # MMU mem_read_cpu
        try: 
            logger.info(f"MMU mem_read_cpu = {dut.MMU_instance.mem_read_cpu.value.to_unsigned()}")
        except Exception:
            logger.info(f"MMU mem_read_cpu = {dut.MMU_instance.mem_read_cpu.value}")

        # MMU addr
        try: 
            logger.info(f"MMU addr = {dut.MMU_instance.addr.value.to_unsigned()}")
        except Exception:
            logger.info(f"MMU addr = {dut.MMU_instance.addr.value}")

        # MMU uart_tx_busy
        try: 
            logger.info(f"MMU uart_tx_busy = {dut.MMU_instance.uart_tx_busy.value.to_unsigned()}")
        except Exception:
            logger.info(f"MMU uart_tx_busy = {dut.MMU_instance.uart_tx_busy.value}")

        # MMU uart_rx_valid
        try: 
            logger.info(f"MMU uart_rx_valid = {dut.MMU_instance.uart_rx_valid}")
        except Exception:
            logger.info(f"MMU uart_rx_valid = {dut.MMU_instance.uart_rx_valid.value.to_unsigned()}")

def log_signals_five_stage_rv32i(logger, dut):
    sim_time = get_sim_time('ns')
    logger.info(f"\n\n")

    core = dut.core_instance

    def log_sig(name, sig, is_hex=False, is_signed=False):
        try:
            val_unsigned = sig.value.to_unsigned()
            if is_signed:
                val_signed = sig.value.to_signed()
                logger.info(f"{name} = {val_signed} OR 0x{val_unsigned:08x}")
            elif is_hex:
                logger.info(f"{name} = {val_unsigned} OR 0x{val_unsigned:08x}")
            else:
                logger.info(f"{name} = {val_unsigned}")
        except Exception:
            logger.info(f"{name} = {sig.value}")

    logger.critical(f"---------Stage-01 FETCH (SIM TIME: {sim_time} ns)-----------")
    log_sig("pc_value (Current PC)", core.pc_value, is_hex=True)


    logger.critical(f"---------Stage-02 DECODE (SIM TIME: {sim_time} ns)-----------")
    log_sig("pc_value_from_if_id", core.pc_value_from_if_id, is_hex=True)

    instruction = 0
    try: 
        instruction = core.instruction_from_if_id.value.to_unsigned()
    except Exception:
        logger.info(f"instruction_from_if_id = {core.instruction_from_if_id.value}")
    else:
        logger.info(f"instruction_from_if_id = {binary_to_assembly((instruction))}")

    # # Immediates
    # log_sig("sign_ext_from_sign_ext_instance", core.sign_ext_from_sign_ext_instance, is_hex=True, is_signed=True)
    # log_sig("b_type_immediate", core.b_type_immediate_from_sign_ext_instance, is_signed=True)
    # log_sig("jal_offset", core.jal_offset_from_sign_ext_instance, is_signed=True)
    # log_sig("u_type_immediate", core.u_type_immediate_from_sign_ext_instance, is_hex=True)
    # log_sig("s_type_immediate", core.s_type_immediate_from_sign_ext_instance, is_signed=True)
    # log_sig("pc_plus_u_type_immediate_value", core.pc_plus_u_type_immediate_value, is_hex=True)
    # log_sig("pc_plus_immediate_value (Branch Target)", core.pc_plus_immediate_value, is_hex=True)
    
    # # Control Signals (Decode)
    # log_sig("pc_src_from_control_unit", core.pc_src_control)
    # log_sig("alu_src_control_from_control_unit", core.alu_src_control_from_control_unit)
    # log_sig("alu_op_control_from_control_unit", core.alu_op_control_from_control_unit)
    # log_sig("mem_read_from_control_unit", core.mem_read_from_control_unit)
    # log_sig("mem_write_from_control_unit", core.mem_write_from_control_unit)
    # log_sig("reg_write_control_from_control_unit", core.reg_write_control_from_control_unit)
    # log_sig("write_back_mux_control_from_control_unit", core.write_back_mux_control_from_control_unit)
    # log_sig("byte_op_from_control_unit", core.byte_op_from_control_unit)
    # log_sig("half_op_from_control_unit", core.half_op_from_control_unit)


    logger.critical(f"---------Stage-03 EXECUTE (SIM TIME: {sim_time} ns)-----------")
    log_sig("rs1_from_id_ex (Reg Addr 1)", core.rs1_from_id_ex)
    log_sig("rs2_from_id_ex (Reg Addr 2)", core.rs2_from_id_ex)
    log_sig("rs1_value (RegFile Out 1)", core.rs1_value, is_hex=True)
    log_sig("rs2_value (RegFile Out 2)", core.rs2_value, is_hex=True)
    
    # Forwarding & ALU Inputs
    log_sig("rs1_value_from_forwarding_unit (ALU Src1)", core.rs1_value_from_forwarding_unit, is_hex=True)
    log_sig("dest_reg_from_ex_mem", core.dest_reg_from_ex_mem)
    log_sig("dest_reg_from_ex_mem", core.rs1_value)
    log_sig("alu_src_value (ALU Src2)", core.alu_src_value, is_hex=True)
    log_sig("rs2_value_from_forwarding_unit (Forwarded Mem Data/Reg Src 2)", core.rs2_value_from_forwarding_unit, is_hex=True)
    
    # ALU Control & Output
    log_sig("alu_control_from_id_ex", core.alu_control_from_id_ex)
    log_sig("invert_control_from_id_ex", core.invert_control_from_id_ex)
    log_sig("alu_out_from_main_alu_instance", core.alu_out_from_main_alu_instance, is_hex=True, is_signed=True)
    log_sig("zero_flag_from_main_alu_instance", core.zero_flag_from_main_alu_instance)
    
    # Branch & Jump Targets
    log_sig("pc_src_control_value (Final PC Mux Sel)", core.pc_src_control_value)
    log_sig("pc_plus_immediate_from_id_ex (Branch Target)", core.pc_plus_immediate_from_id_ex, is_hex=True)
    log_sig("pc_plus_u_type_immediate_from_id_ex", core.pc_plus_u_type_immediate_from_id_ex, is_hex=True)
    log_sig("pc_plus_jal_offset_value (JAL Target)", core.pc_plus_jal_offset_value, is_hex=True)
    log_sig("jalr_pc (JALR Target)", core.jalr_pc, is_hex=True)

    # Memory Requests to outside world
    log_sig("mem_read_request (To Mem)", core.mem_read_request)
    log_sig("mem_write_request (To Mem)", core.mem_write_request)
    log_sig("mem_address_request (To Mem)", core.mem_address_request, is_hex=True)
    log_sig("mem_data_to_mem (Data out to Mem)", core.mem_data_to_mem, is_hex=True, is_signed=True)


    logger.critical(f"---------------Stage-04 MEMORY (SIM TIME: {sim_time} ns)-----------------")
    # Memory Address & Status
    log_sig("mem_read (from ex_mem)", core.mem_read)
    
    # Inbound Memory Data
    log_sig("mem_data_from_mem (Raw CPU Input)", core.mem_data_from_mem, is_hex=True)
    log_sig("load_op_data (Formatted Load Data)", core.load_op_data, is_hex=True, is_signed=True)
    
    # Format Control
    log_sig("byte_op_from_ex_mem", core.byte_op_from_ex_mem)
    log_sig("half_op_from_ex_mem", core.half_op_from_ex_mem)
    log_sig("unsigned_op_from_ex_mem", core.unsigned_op_from_ex_mem)

    logger.critical(f"--------------Stage-05 WRITE BACK (SIM TIME: {sim_time} ns)--------------")
    log_sig("dest_reg_from_mem_write_back", core.dest_reg_from_mem_write_back)
    log_sig("reg_write_control_from_mem_write_back", core.reg_write_control_from_mem_write_back)
    log_sig("write_back_mux_control_from_mem_write_back_reg", core.write_back_mux_control_from_mem_write_back_reg)
    log_sig("reg_write_back_data (Data to RegFile)", core.reg_write_back_data, is_hex=True, is_signed=True)

