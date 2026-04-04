import nox
from pathlib import Path

all_python_deps = [
    "cocotb", 
    "pytest"
]


def install_deps(session: nox.Session) -> None:
    session.log("Installing all python dependencies for tests")
    session.install(*all_python_deps)


def collect_all_hex_files():
    base = Path("generated_hex")
    hex_files = sorted(base.rglob("*.hex"))
    return [str(p) for p in hex_files]


@nox.session
def test_pc_one(session: nox.Session) -> None:

    install_deps(session)

    session.chdir("tests/hardware/pc_one/")

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
def test_nexys3(session: nox.Session) -> None:

    install_deps(session)

    # Build rom image hex file
    session.chdir("software/")
    session.run("make", external=True)
    
    # run test
    session.chdir("../tests/hardware/FPGA_digilent_nexys3_BIOS_test/")
    session.run("make", external=True)

@nox.session
def test_ram(session: nox.Session) -> None:

    install_deps(session)
    
    # run test
    session.chdir("../tests/hardware/memories/ram/")
    session.run("make", external=True)

    