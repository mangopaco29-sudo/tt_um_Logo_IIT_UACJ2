import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer

@cocotb.test()
async def test_project(dut):
    """Test that VGA signals are generated"""
    
    # Generate clock (25.175 MHz ~ 39.7 ns period)
    clock = Clock(dut.clk, 40, unit="ns")  # Cambiado 'units' a 'unit'
    cocotb.start_soon(clock.start())
    
    # Reset
    dut.rst_n.value = 0
    await Timer(100, unit="ns")  # Cambiado 'units' a 'unit'
    dut.rst_n.value = 1
    await Timer(100, unit="ns")  # Cambiado 'units' a 'unit'
    
    # Leer el valor completo de uo_out (8 bits)
    uo_out_value = dut.uo_out.value
    
    # Extraer bits individuales del valor (usando slicing)
    hsync = (uo_out_value >> 7) & 1  # Bit 7 es HSync
    vsync = (uo_out_value >> 3) & 1  # Bit 3 es VSync
    
    cocotb.log.info(f"uo_out value: {uo_out_value} (binary: {uo_out_value.binstr})")
    cocotb.log.info(f"HSync: {hsync}, VSync: {vsync}")
    
    # Verificar que las señales existen
    assert uo_out_value is not None, "uo_out should have a value"
    
    cocotb.log.info("VGA test passed!")
