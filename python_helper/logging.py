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
            logger.info(f"mem_write = {dut.ram_instance.mem_write.value.to_unsigned()}")
        except Exception:
            logger.info(f"mem_write = {dut.ram_instance.mem_write.value}")

        # data_in
        try: 
            logger.info(f"data_in ram = {dut.ram_instance.data_in.value.to_unsigned()} or " +
                        f"0x{dut.ram_instance.data_in.value.to_unsigned():08x}")
        except Exception:
            logger.info(f"data_in ram = {dut.ram_instance.data_in.value}")

        # mem_read
        try: 
            logger.info(f"mem_read = {dut.ram_instance.mem_read.value.to_unsigned()}")
        except Exception:
            logger.info(f"mem_read = {dut.ram_instance.mem_read.value}")

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
