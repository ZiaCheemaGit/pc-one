import nox
from pathlib import Path

def collect_all_hex_files():
    base = Path("generated_hex")
    hex_files = sorted(base.rglob("*.hex"))
    return [str(p) for p in hex_files]


@nox.session
def test_pc_one_single_cycle_rv32i(session: nox.Session) -> None:

    session.chdir("tests/hardware/pc_one_single_cycle_rv32i/")

    # Generate hex files and collect each files path
    session.chdir("test_cases/")
    session.run("make", external=True)
    hex_files = collect_all_hex_files()
    
    session.chdir("../")
    
    # Run all assembly and c/cpp test programs on pc-one
    for hex_file in hex_files:
        session.log(f"Collected test_cases/{hex_file}")
        session.run("make", f"PROGRAM_FILE=test_cases/{hex_file}", external=True)

@nox.session
def test_pc_one_five_stage_pipelined_rv32i(session: nox.Session) -> None:

    session.chdir("tests/hardware/pc_one_five_stage_pipelined_rv32i/")

    # Generate hex files and collect each files path
    session.chdir("test_cases/")
    session.run("make", external=True)
    hex_files = collect_all_hex_files()
    
    session.chdir("../")
    
    # Run all assembly and c/cpp test programs on pc-one
    for hex_file in hex_files:
        session.log(f"Collected test_cases/{hex_file}")
        session.run("make", f"PROGRAM_FILE=test_cases/{hex_file}", external=True)
    
@nox.session
def test_fpga_bios_uart_single_cycle_rv32i(session: nox.Session) -> None:

    # Build rom image hex file
    session.chdir("software/")
    session.run("make", external=True)
    
    # run test
    session.chdir("../tests/hardware/FPGA_single_cycle_rv32i/")
    session.run("make", external=True)

@nox.session
def test_fpga_bios_uart_five_stage_pipelined_rv32i(session: nox.Session) -> None:

    # Build rom image hex file
    session.chdir("software/")
    session.run("make", external=True)
    
    # run test
    session.chdir("../tests/hardware/FPGA_five_stage_pipelined_rv32i/")
    session.run("make", external=True)

@nox.session
def test_ram(session: nox.Session) -> None:
    
    # run test
    session.chdir("tests/hardware/memories/ram/")
    session.run("make", external=True)

