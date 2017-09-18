FFLAGS = -O2 -ta=tesla:cc30,cc35,cc50,cuda8.0 -Minfo=accel,ftn 
OBJ = sgemm_acc sgemm_mpi sgemm_acc_mpi

all: $(OBJ)

sgemm_acc: sgemm_acc.f90
	pgfortran $(FFLAGS) $^ -o $@ 

sgemm_mpi: sgemm_mpi.f90
	mpif90 $(FFLAGS) $^ -o $@

sgemm_acc_mpi: sgemm_acc_mpi.f90
	mpif90 $(FFLAGS) $^ -o $@

clean:
	rm -f $(OBJ) *.mod *.o

.PHONY: clean
