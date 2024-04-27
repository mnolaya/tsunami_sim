SRC=fort
BIN=bin

FC=gfortran
FFLAGS=-O3

$(shell mkdir -p $(BIN))

tsunami: $(SRC)/*.f90
	$(FC) $(FFLAGS) $< -o $(BIN)/$@