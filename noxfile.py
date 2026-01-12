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
    return [str(p) for p in hex_files]


@nox.session
def test_single_cycle_rv32i_core(session: nox.Session) -> None:

    install_deps(session)

    session.chdir("tests/single_cycle_rv32i_core/")

    # Generate hex files and collect each files path
    session.chdir("test_cases/")
    session.run("make", external=True)
    hex_files = collect_all_hex_files()
    
    session.chdir("../")
    
    for hex_file in hex_files:
        session.log(f"Collected test_cases/{hex_file}")
        session.run("make", f"PROGRAM_FILE=test_cases/{hex_file}", external=True)

    # Clean generated hex files
    session.chdir("test_cases/")
    session.run("make", "clean",external=True)

    session.chdir("../../")        


def test_build(session: nox.Session) -> None:

    install_deps(session)

    # test cpu
    test_single_cycle_rv32i_core(session)
    
