FC = mpif90
FFLAGS = -O2 -ta=tesla:cc30,cc35,cc50,cc60,cuda8.0 -Minfo=accel,ftn
OBJ = sgemm_acc sgemm_mpi sgemm_acc_mpi

all: $(OBJ)

% : %.f90
	$(FC) $(FFLAGS) $^ -o $@

clean:
	rm -f $(OBJ) *.mod *.o

.PHONY: clean
