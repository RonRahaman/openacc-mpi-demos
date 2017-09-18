OpenACC/MPI Demos
=================

These demos use OpenACC and MPI to run SAXPY in various contexts.


Contents
--------

* **saxpy\_acc** runs a SAXPY in parallel on a single GPU.

* **saxpy\_mpi** runs SAXPY on CPU with multiple MPI processes.  The root
  allocates an array for the global problem, then scatters local subarrays to
  the other ranks.  Then, each rank computes SAXPY on its subarray.  Finally,
  the subarrays are gathered back onto the root to check the results.  The
  length of the global problem must be evenly divisible by the number of MPI
  ranks.

* **saxpy\_acc\_mpi** runs SAXPY with multiple MPI processes.  Each process
  offloads its local work to GPU using OpenACC kernels.  The MPI scheme is the
  same as saxpy\_mpi, and the length of the global problem must be evenly
  divisible by the number of MPI ranks.  The number of NVIDIA-capable GPUs can
  be arbitrarily >= 1; each rank's kernels will be round-robin scheduled on the
  available GPUs.


Building
--------

Ensure that the `mpif90` in your path uses pgfortran.  Then simply run `make all`.


Running
-------

MPI programs are run as usual, e.g: `mpirun -np 2 ./saxpy_acc_mpi`


Profiling
---------

The nvprof users' manual describes how to profile and visualize MPI sessions:

* [MPI Profiling With nvprof](http://docs.nvidia.com/cuda/profiler-users-guide/index.html#mpi-nvprof)
* [Import Multi-Process nvprof Session](http://docs.nvidia.com/cuda/profiler-users-guide/index.html#import-multi-nvprof-session)

For example, you could run nvprof as the following, where `%p` is substituted with the corresponding process ID:

``` Shell
mpirun -np 2 nvprof --export-profile saxpy.%p.prof ./sgemm_acc_mpi
```

After copying the `*.nvprof` files to your local computer, you can import and visual them in nvvp.
