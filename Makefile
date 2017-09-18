FFLAGS = -O2 -ta=tesla:cc50,cuda8.0 -Minfo=accel,ftn 
#OBJ = sgemm_acc sgemm_mpi sgemm_acc_mpi
OBJ = sgemm_acc

all: $(OBJ)

sgemm_acc: sgemm_acc.f90
	pgfortran $(FFLAGS) $^ -o $@ 

clean:
	rm -f $(OBJ) *.mod *.o

.PHONY: clean
