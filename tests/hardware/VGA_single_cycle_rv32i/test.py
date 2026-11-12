import cocotb
from cocotb.clock import Clock
from cocotb_vga import VGACapture, VGA_640x480_60, VGASignals
from cocotb.triggers import RisingEdge

@cocotb.test()
async def test_vga(dut):
    cocotb.start_soon(Clock(dut.clk_from_FPGA_100MHz, 10, "ns").start())
    dut.rst_from_FPGA.value = 1
    await RisingEdge(dut.clk_from_FPGA_100MHz)
    dut.rst_from_FPGA.value = 0
    await RisingEdge(dut.clk_from_FPGA_100MHz)

    vga_sigs = VGASignals(
        hsync = dut.hsync_for_FPGA,
        vsync = dut.vsync_for_FPGA,
        red = dut.vga_red_for_FPGA,
        green = dut.vga_green_for_FPGA,
        blue = dut.vga_blue_for_FPGA
    )

    cap = VGACapture(dut.clk_from_FPGA_100MHz, vga_sigs, VGA_640x480_60,
                     out_dir="output", name="myproject", clk_div=4).start()
    
    frames = await cap.wait_for_frames(4)  
    cap.stop()

    cap.save_gif()                          
    frames[2].assert_matches("golden.png")  
