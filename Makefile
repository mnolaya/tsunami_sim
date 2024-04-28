SRC=tsunami/fort
BIN=tsunami/bin

FC=gfortran
FFLAGS=-O3

$(shell mkdir -p $(BIN))

.PHONY: tsunami

tsunami:
	$(FC) $(FFLAGS) -c $(SRC)/tsunami.f90 -I $(BIN) -J $(BIN) -L $(BIN)
	$(FC) *.o -shared -o $(BIN)/libtsunami.so
	rm tsunami.o