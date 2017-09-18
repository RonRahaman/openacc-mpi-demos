program sgemm_acc
  use mpi
  implicit none

  integer :: len_global, len_local, i
  integer :: irank, nranks, ierr, istat(MPI_STATUS_SIZE)
  real(4), allocatable, dimension(:) :: X_local, X_global, Y_global, Y_local, Y_ref
  real(4) :: a
  character(len=128) :: argv

  a = 2.0
  len_global = 8

  ! Initialize MPI
  call MPI_Init(ierr)
  call MPI_Comm_rank(MPI_COMM_WORLD, irank, ierr)
  call MPI_Comm_size(MPI_COMM_WORLD, nranks, ierr)

  ! Check to see that the global length is evenly divisible by the number of MPI ranks
  if (mod(len_global, nranks) .ne. 0) then
    if (irank .eq. 0) then
      write(*,'(a,5i,a,5i)'), 'The global array length, ', len_global, &
          ', is not divisible by the number of ranks, ', nranks
      call MPI_Abort(MPI_COMM_WORLD, 1, ierr)
    endif
  else
    len_local = len_global / nranks
  endif

  ! Allocate local and global arrays
  allocate(X_local(len_local))
  allocate(Y_local(len_local))
  if (irank .eq. 0) then
    allocate(X_global(len_global))
    allocate(Y_global(len_global))
    allocate(Y_ref(len_global))
  endif

  ! If root, set global and reference arrays
  if (irank .eq. 0) then
    do i = 1, len_global
      X_global(i) = i
      Y_global(i) = i + len_global
      Y_ref(i) = a * i + (i + len_global)
    enddo
  endif

  ! Scatter operands
  call MPI_Scatter( &
      X_global, &
      len_local, &
      MPI_REAL4, &
      X_local, &
      len_local, &
      MPI_REAL4, &
      0, &
      MPI_COMM_WORLD, &
      ierr &
  )
  call MPI_Scatter( &
      Y_global, &
      len_local, &
      MPI_REAL4, &
      Y_local, &
      len_local, &
      MPI_REAL4, &
      0, &
      MPI_COMM_WORLD, &
      ierr &
  )

  ! Do local calculation
  do i = 1, len_local
    Y_local(i) = a*X_local(i) + Y_local(i)
  enddo

  ! Gather result
  call MPI_Gather( &
      Y_local, &
      len_local, &
      MPI_REAL4, &
      Y_global, &
      len_local, &
      MPI_REAL4, &
      0, &
      MPI_COMM_WORLD, &
      ierr &
  )

  ! Root checks result
  if (irank .eq. 0) then
    print *, 'Ran SAXPY for n = ', len_global
    if (all(Y_ref .eq. Y_global)) then
      print *, 'SUCCESS: Y_global matches Y_ref'
    else
      print *, 'FAILURE: Y_global does not match Y_ref'
      print *, 'Y_global = ', Y_global
      print *, 'Y_ref = ', Y_ref
    endif
  endif

  ! Cleanup
  deallocate(X_local)
  deallocate(Y_local)
  if (irank .eq. 0) then
    deallocate(X_global)
    deallocate(Y_global)
    deallocate(Y_ref)
  endif

  call MPI_Finalize(ierr)

end program
