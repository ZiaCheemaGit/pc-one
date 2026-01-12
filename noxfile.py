import nox
from pathlib import Path

all_python_deps = [
    "cocotb",
]


def install_deps(session: nox.Session) -> None:
    session.log("Installing all python dependencies for tests")
    session.install(*all_python_deps)

def collect_all_hex_files():
    base = Path("generated_hex")
    hex_files = sorted(base.rglob("*.hex"))
    return [str(p.resolve()) for p in hex_files]

def install_deps(session: nox.Session):
    """ Install all dependencies to run tests"""
    install_deps(session)

@nox.session
def test_single_cycle_rv32i_core(session: nox.Session) -> None:

    session.chdir("tests/single_cycle_rv32i_core/")

    # Generate hex files and collect each files paths
    session.chdir("hex/")
    session.run("make", external=True)
    hex_files = collect_all_hex_files()
    session.chdir("../")
    
    for hex_file in hex_files:
        session.run(f"make PROGRAM_FILE={hex_file}", external=True)

    session.chdir("../../")        


def test_build(session: nox.Session) -> None:

    install_deps(session)

    # test cpu
    test_single_cycle_rv32i_core(session)
    
