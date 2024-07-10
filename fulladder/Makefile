
# Makefile to build a testbench and DUT

export VERDI_HOME=/home/yutung/.toolsmgr/verdi
export LD_LIBRARY_PATH:=${LD_LIBRARY_PATH}:${VERDI_HOME}/share/PLI/VCS/LINUX64:${VERDI_HOME}/share/PLI/lib/LINUX64
$(info set Environment done)

VCS = vcs -sverilog -timescale=1ns/1ns -l build.log -debug_access+all
SIMV = ./simv -l run.log

all: compile run verify

compile:
	$(VCS) ./src/*.v ./tb/*.v
run:
	rm -f ./testcases/*/output.txt
	$(SIMV)
verify:
	$(info Testcase: all)
	@cmp -s ./testcases/all/output.txt ./testcases/all/golden.txt; \
	RETVAL=$$?;\
	if [ $$RETVAL -eq 0 ]; then \
		echo "PASS"; \
	else \
		echo "FAIL"; \
	fi

waveform:
	verdi -f file.f -ssf top.fsdb &
clean:
	rm -rf core csrc simv* vc_hdrs.h ucli.key urg* *.log *.fsdb novas.* verdiLog
