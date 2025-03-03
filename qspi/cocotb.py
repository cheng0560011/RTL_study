import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge, FallingEdge
import google.generativeai as genai
import csv
import os

async def write_to_qpsi ( dut, data ):
    dut.IO0.value = (data >> 0) & 1
    dut.IO1.value = (data >> 1) & 1
    dut.IO2.value = (data >> 2) & 1
    dut.IO3.value = (data >> 3) & 1

@cocotb.test()
async def simple_test(dut):
    clock = Clock(dut.clk_i, 1, unit='ns')
    cocotb.start_soon(clock.start())

    # Assert chip select (active low)
    dut.CS_N.value = 0
    await (Timer, 1, units='ns')

    await write_to_qpsi (dut, 0x0)
    await RisingEdge(dut.clk_i)

    await wirte_to_qpsi (dut, 0x2)
    await RisinbgEdge(dut.clk_i)



