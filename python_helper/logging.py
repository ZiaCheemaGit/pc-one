from cocotb.utils import get_sim_time

from python_helper.converter import binary_to_assembly

# async def log_signals_single_cycle_rv32i(logger, dut):
#     while True:
#         await RisingEdge(dut.clk_from_FPGA)
#         # PC
#         try: 
#             logger.critical(f"PC = {dut.instr_add.value.to_unsigned()}")
#             logger.critical(f"PC = 0x{dut.instr_add.value.to_unsigned():08x}")
#         except Exception:
#             logger.critical(f"PC = {dut.instr_add.value}")

#         # Instruction 
#         try: 
#             logger.info(f"instruction = {binary_to_assembly((dut.instruction.value.to_unsigned()))}")
#         except Exception:
#             logger.info(f"instruction = {dut.instruction.value}")

#         # reg_write_control
#         try: 
#             logger.info(f"reg_write_control = {dut.core_instance.reg_file_instance.reg_write_control.value.to_unsigned()}")
#         except Exception:
#             logger.info(f"reg_write_control = {dut.core_instance.reg_file_instance.reg_write_control.value}")   

#         # reg_write_data
#         try: 
#             logger.info(f"reg_write_data = {dut.core_instance.reg_file_instance.reg_write_data.value.to_unsigned()} or " + 
#                         f"0x{dut.core_instance.reg_file_instance.reg_write_data.value.to_unsigned():08x}")
#         except Exception:
#             logger.info(f"reg_write_data = {dut.core_instance.reg_file_instance.reg_write_data.value}")   

#         # dest_reg
#         try: 
#             logger.info(f"dest_reg = {dut.core_instance.reg_file_instance.dest_reg.value.to_unsigned()}")
#         except Exception:
#             logger.info(f"dest_reg = {dut.core_instance.reg_file_instance.dest_reg.value}")   

#         # mem_write
#         try: 
#             logger.info(f"ram_mem_write = {dut.ram_instance.mem_write.value.to_unsigned()}")
#         except Exception:
#             logger.info(f"ram_mem_write = {dut.ram_instance.mem_write.value}")

#         # data_in
#         try: 
#             logger.info(f"data_in ram = {dut.ram_instance.data_in.value.to_unsigned()} or " +
#                         f"0x{dut.ram_instance.data_in.value.to_unsigned():08x}")
#         except Exception:
#             logger.info(f"data_in ram = {dut.ram_instance.data_in.value}")

#         # mem_read
#         try: 
#             logger.info(f"ram_mem_read = {dut.ram_instance.mem_read.value.to_unsigned()}")
#         except Exception:
#             logger.info(f"ram_mem_read = {dut.ram_instance.mem_read.value}")

#         # data_out
#         try: 
#             logger.info(f"data_out of ram = {dut.ram_instance.data_out.value.to_unsigned()} or " + 
#                         f"0x{dut.ram_instance.data_out.value.to_unsigned():08x}")
#         except Exception:
#             logger.info(f"data_out of ram = {dut.ram_instance.data_out.value}")

#         # data_address
#         try: 
#             logger.info(f"data_address = {dut.ram_instance.data_address.value.to_unsigned()} or " + 
#                         f"0x{dut.ram_instance.data_address.value.to_unsigned():08x}")
#         except Exception:
#             logger.info(f"data_address = {dut.ram_instance.data_address.value}")

#         # MMU mem_write_cpu
#         try: 
#             logger.info(f"MMU mem_write_cpu = {dut.MMU_instance.mem_write_cpu.value.to_unsigned()}")
#         except Exception:
#             logger.info(f"MMU mem_write_cpu = {dut.MMU_instance.mem_write_cpu.value}")

#         # MMU mem_read_cpu
#         try: 
#             logger.info(f"MMU mem_read_cpu = {dut.MMU_instance.mem_read_cpu.value.to_unsigned()}")
#         except Exception:
#             logger.info(f"MMU mem_read_cpu = {dut.MMU_instance.mem_read_cpu.value}")

#         # MMU addr
#         try: 
#             logger.info(f"MMU addr = {dut.MMU_instance.addr.value.to_unsigned()}")
#         except Exception:
#             logger.info(f"MMU addr = {dut.MMU_instance.addr.value}")

#         # MMU uart_tx_busy
#         try: 
#             logger.info(f"MMU uart_tx_busy = {dut.MMU_instance.uart_tx_busy.value.to_unsigned()}")
#         except Exception:
#             logger.info(f"MMU uart_tx_busy = {dut.MMU_instance.uart_tx_busy.value}")

#         # MMU uart_rx_valid
#         try: 
#             logger.info(f"MMU uart_rx_valid = {dut.MMU_instance.uart_rx_valid}")
#         except Exception:
#             logger.info(f"MMU uart_rx_valid = {dut.MMU_instance.uart_rx_valid.value.to_unsigned()}")

def log_signals_five_stage_rv32i(logger, dut):
    sim_time = get_sim_time('ns')
    logger.info(f"\n\n")

    logger.critical(f"---------Stage-01 FETCH(SIM TIME: {sim_time} ns)-----------")
    # PC
    try: 
        logger.info(f"PC = {dut.core_instance.instruction_address.value.to_unsigned()} OR " + 
                    f"0x{dut.core_instance.instruction_address.value.to_unsigned():08x}")
    except Exception:
        logger.info(f"PC = {dut.core_instance.instruction_address.value}")

    logger.critical(f"---------Stage-02 DECODE AND EXECUTE(SIM TIME: {sim_time} ns)-----------")
    # instruction
    try: 
        logger.info(f"instruction = {binary_to_assembly((dut.core_instance.if_id_reg_instance.inst_out.value.to_unsigned()))}")
    except Exception:
        logger.info(f"instruction = {dut.core_instance.if_id_reg_instance.inst_out.value}")

    # main_alu_instance alu_out
    try: 
        logger.info(f"alu_out = {dut.core_instance.main_alu_instance.out.value.to_unsigned()}")
    except Exception:
        logger.info(f"alu_out = {dut.core_instance.main_alu_instance.out.value}")

    # mem_write
    try: 
        logger.info(f"ram_mem_write = {dut.ram_instance.mem_write.value.to_unsigned()}")
    except Exception:
        logger.info(f"ram_mem_write = {dut.ram_instance.mem_write.value}")

    # data_in
    try: 
        logger.info(f"data_in ram = {dut.ram_instance.data_in.value.to_signed()} OR " +
                    f"0x{dut.ram_instance.data_in.value.to_unsigned():08x}")
    except Exception:
        logger.info(f"data_in ram = {dut.ram_instance.data_in.value}")

    # mem_read request
    try: 
        logger.info(f"ram_mem_read_request = {dut.ram_instance.mem_read.value.to_unsigned()}")
    except Exception:
        logger.info(f"ram_mem_read_request = {dut.ram_instance.mem_read.value}")

    # mem_read 
    try: 
        logger.info(f"MMU_mem_read = {dut.MMU_instance.mem_read.value.to_unsigned()}")
    except Exception:
        logger.info(f"MMU_mem_read = {dut.MMU_instance.mem_read.value}")
        
    # ram_address
    try: 
        logger.info(f"ram_address = {dut.ram_instance.data_address.value.to_unsigned()} or " + 
                    f"0x{dut.ram_instance.data_address.value.to_unsigned():08x}")
    except Exception:
        logger.info(f"ram_address = {dut.ram_instance.data_address.value}")

    # cpu_address
    try: 
        logger.info(f"cpu_address = {dut.core_instance.mem_address.value.to_unsigned()} or " + 
                    f"0x{dut.core_instance.mem_address.value.to_unsigned():08x}")
    except Exception:
        logger.info(f"cpu_address = {dut.core_instance.mem_address.value}")
    
    logger.critical(f"---------Stage-03 MEMORY AND WRITE-BACK(SIM TIME: {sim_time} ns)-----------")
    # reg_write_control
    try: 
        logger.info(f"reg_write_control = {dut.core_instance.reg_file_instance.reg_write_control.value.to_unsigned()}")
    except Exception:
        logger.info(f"reg_write_control = {dut.core_instance.reg_file_instance.reg_write_control.value}")   

    # reg_write_data
    try: 
        logger.info(f"reg_write_data = {dut.core_instance.reg_file_instance.reg_write_data.value.to_signed()} or " + 
                    f"0x{dut.core_instance.reg_file_instance.reg_write_data.value.to_unsigned():08x}")
    except Exception:
        logger.info(f"reg_write_data = {dut.core_instance.reg_file_instance.reg_write_data.value}")   

    # dest_reg
    try: 
        logger.info(f"dest_reg = {dut.core_instance.reg_file_instance.dest_reg.value.to_unsigned()}")
    except Exception:
        logger.info(f"dest_reg = {dut.core_instance.reg_file_instance.dest_reg.value}")   

    # data_out ram
    try: 
        logger.info(f"data_out of ram = {dut.ram_instance.data_out.value.to_unsigned()} or " + 
                    f"0x{dut.ram_instance.data_out.value.to_unsigned():08x}")
    except Exception:
        logger.info(f"data_out of ram = {dut.ram_instance.data_out.value}")

    # data_out ram
    try: 
        logger.info(f"data_out of boot rom = {dut.boot_rom_instance.data.value.to_unsigned()} or " + 
                    f"0x{dut.boot_rom_instance.data.value.to_unsigned():08x}")
    except Exception:
        logger.info(f"data_out of boot rom = {dut.boot_rom_instance.data.value}")

    # mem_read 
    try: 
        logger.info(f"MMU_mem_read = {dut.MMU_instance.mem_read.value.to_unsigned()}")
    except Exception:
        logger.info(f"MMU_mem_read = {dut.MMU_instance.mem_read.value}")

    # MMU data to cpu
    try: 
        logger.info(f"MMU_data_to_cpu = {dut.MMU_instance.data_to_cpu.value.to_unsigned()}")
    except Exception:
        logger.info(f"MMU_data_to_cpu = {dut.MMU_instance.data_to_cpu.value}")

    # MMU signals
    try: 
        logger.info(f"MMU_uart_tx_status_read = {dut.MMU_instance.uart_tx_status_read.value.to_unsigned()}")
        logger.info(f"MMU_uart_read = {dut.MMU_instance.uart_read.value.to_unsigned()}")
        logger.info(f"MMU_boot_rom_read = {dut.MMU_instance.boot_rom_read.value.to_unsigned()}")
        logger.info(f"MMU_vram_read = {dut.MMU_instance.vram_read.value.to_unsigned()}")
        logger.info(f"MMU_mem_read = {dut.MMU_instance.mem_read.value.to_unsigned()}")
    except Exception:
        logger.info(f"MMU_uart_tx_status_read = {dut.MMU_instance.uart_tx_status_read.value}")
        logger.info(f"MMU_uart_read = {dut.MMU_instance.uart_read.value}")
        logger.info(f"MMU_boot_rom_read = {dut.MMU_instance.boot_rom_read.value}")
        logger.info(f"MMU_vram_read = {dut.MMU_instance.vram_read.value}")
        logger.info(f"MMU_mem_read = {dut.MMU_instance.mem_read.value}")
