import cocotb
from cocotb.triggers import Timer

@cocotb.test()
async def simple_test(dut):
    """Test fulladder with a=0, b=1, cin=0 and check sum output"""

    # Apply input values: a=0, b=1, cin=0
   
    golden = [0, 1, 1, 0, 1, 0, 0, 1]

    await Timer(1, units='ns')

    for i in range (8):
        dut.a.value = (i >> 2) & 1
        dut.b.value = (i >> 1) & 1
        dut.cin.value = i & 1
        expected_ans = golden[i]
        print(f"iter {i} expected_ans {expected_ans}")
        await Timer(1, units='ns')
        assert dut.sum.value == expected_ans, f"Test failed: expected sum=1, got sum = {dut.sum.value}"

