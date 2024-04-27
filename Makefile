SRC=fort
BIN=bin

FC=gfortran
FFLAGS=-O3

$(shell mkdir -p $(BIN))

tsunami:
	$(FC) $(FFLAGS) -c $(SRC)/tsunami.f90 -I $(BIN) -J $(BIN)
	$(FC) *.o -o $(BIN)/tsunami
	rm tsunami.o