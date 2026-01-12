import nox


all_python_deps = [
    "cocotb",
]


def install_deps(session: nox.Session) -> None:
    session.log("Installing all python dependencies for tests")
    session.install(*all_python_deps)


def test_single_cycle_rv32i_core(session: nox.Session) -> None:
    session.chdir("tests/single_cycle_rv32i_core/")
    session.log("Entering Directory tests/single_cycle_rv32i_core")



@nox.session
def test_build(session: nox.Session) -> None:

    # Install all dependencies to run tests
    install_deps(session)

    # test cpu
    test_single_cycle_rv32i_core(session)
    
