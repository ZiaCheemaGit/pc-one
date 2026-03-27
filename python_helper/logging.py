from cocotb.triggers import RisingEdge

from python_helper.converter import binary_to_assembly

async def log_signals_pc_one(logger, dut):
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

        # MMU uart_rx_busy
        try: 
            logger.info(f"MMU uart_rx_busy = {dut.MMU_instance.uart_rx_busy}")
        except Exception:
            logger.info(f"MMU uart_rx_busy = {dut.MMU_instance.uart_rx_busy.value.to_unsigned()}")




