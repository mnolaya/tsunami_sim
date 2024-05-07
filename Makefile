SRC=tsunami/fort
BIN=tsunami/bin
MOD=tsunami/include
BUILD=./build

FC=gfortran
FFLAGS=-O3
CWD=$(shell pwd)

$(shell mkdir -p $(BUILD))
$(shell mkdir -p $(BIN))
$(shell mkdir -p $(MOD))

.PHONY: tsunami copy clean

build: tsunami copy clean

tsunami:
	$(FC) $(FFLAGS) -c $(SRC)/tsunami_solver.f90 -I $(BUILD) -J $(BUILD) -L $(BUILD)
	$(FC) $(FFLAGS) -c $(SRC)/py_iface.f90 -I $(BUILD) -J $(BUILD) -L $(BUILD)
	$(FC) *.o -shared -o $(BUILD)/libtsunami.so
	rm *.o

clean:
	rm -rf $(BUILD)

copy:
	cp $(BUILD)/*.so $(BIN)
	cp $(BUILD)/*.mod $(MOD)