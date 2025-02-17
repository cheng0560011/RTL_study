# Specify Verilog source files
VERILOG_SOURCES += ../src/fulladder.v  # Update this with the actual path to your DUT

# Top-level module name (DUT module name in Verilog)
TOPLEVEL = fulladder

# Python test module (without .py extension)
MODULE = testbench

# Set the simulator to Icarus Verilog (iverilog)
SIM = icarus

# Enable waveform generation (VCD dump)
VCD = 1

# Include the Cocotb Makefile
include $(shell cocotb-config --makefile)/Makefile.sim

