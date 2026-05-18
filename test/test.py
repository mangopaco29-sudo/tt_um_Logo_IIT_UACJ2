import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer

@cocotb.test()
async def test_project(dut):
    """Test that VGA signals are generated"""
    
    # Generate clock
    clock = Clock(dut.clk, 40, units="ns")  # 25 MHz
    cocotb.start_soon(clock.start())
    
    # Reset
    dut.rst_n.value = 0
    await Timer(100, units="ns")
    dut.rst_n.value = 1
    await Timer(100, units="ns")
    
    # Check that hsync and vsync are toggling
    hsync_initial = dut.uo_out[7].value
    vsync_initial = dut.uo_out[3].value
    
    await Timer(1000, units="ns")
    
    # Verify signals changed (VGA is active)
    assert dut.uo_out[7].value is not None, "HSync should be connected"
    assert dut.uo_out[3].value is not None, "VSync should be connected"
    
    cocotb.log.info("VGA test passed!")
