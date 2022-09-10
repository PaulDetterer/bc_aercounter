TOPFILE ?= TESTBENCH/Top.bs
TOPMODULE ?= mkTop


BSC_COMP_FLAGS += -keep-fires  -aggressive-conditions  -no-warn-action-shadowing  -check-assert  -cpp \
				  		+RTS -K128M -RTS  -show-range-conflict \
								$(BSC_COMP_FLAG1)  $(BSC_COMP_FLAG2)  $(BSC_COMP_FLAG3)


BSC_LINK_FLAGS += -keep-fires

BSC_PATHS = -p $(BSC_PATH1)bs:$(BSC_PATH1)bsv:%/Libraries


.PHONY: help b_all b_compile b_link b_sim v_compile v_link v_sim

help:
	@echo "Help TODO"


B_SIM_DIRS = -simdir build_b_sim -bdir build_b_sim -info-dir build_b_sim
B_SIM_EXE = $(TOPMODULE)_b_sim


b_all: b_compile b_link b_sim


build_b_sim:
	mkdir build_b_sim

b_compile: build_b_sim
	@echo "Compiling for Bluesim ..."
	bsc -u -sim $(B_SIM_DIRS) $(BSC_COMP_FLAGS) $(BSC_PATHS) -g $(TOPMODULE) $(TOPFILE)
	@echo "Compiling for Bluesim finished"

b_link:
	@echo Linking for Bluesim ...
	bsc -e $(TOPMODULE) -sim -o $(B_SIM_EXE) $(B_SIM_DIRS) $(BSC_LINK_FLAGS) $(BSC_PATHS)
	@echo Linking for Bluesim finished

b_sim:
	@echo Bluesim simulation ...
	./$(B_SIM_EXE)
	@echo Bluesim simulation finished


# ----------------------------------------------------------------
# Verilog compile/link/sim
V_DIRS = -vdir RTL -bdir build_v -info-dir build_v
V_SIM_EXE = $(TOPMODULE)_v_sim

.PHONY: v_all
v_all: v_compile  v_link  v_sim

build_v:
	mkdir  build_v
RTL:
	mkdir  verilog_RTL

v_compile: build_v  RTL
	@echo Compiling for Verilog ...
	bsc -u -verilog $(V_DIRS) $(BSC_COMP_FLAGS) $(BSC_PATHS) -g $(TOPMODULE)  $(TOPFILE)
	@echo Compiling for Verilog finished

v_link:  build_v  RTL
	@echo Linking for Verilog sim ...
	bsc -e $(TOPMODULE) -verilog -o ./$(V_SIM_EXE) $(V_DIRS) -vsim ncsim  RTL/$(TOPMODULE).v
	@echo Linking for Verilog sim finished

v_sim:
	@echo Verilog simulation...
	./$(V_SIM_EXE)
	@echo Verilog simulation finished

