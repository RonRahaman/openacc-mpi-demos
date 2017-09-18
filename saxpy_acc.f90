program saxpy_acc
  implicit none

  integer :: n, i, stat
  real(4), allocatable, dimension(:) :: X, Y, Yref
  real(4) :: a
  character(len=128) :: argv

  a = 2.0

  call get_command_argument(1,argv)
  if (len_trim(argv) > 0) then
    read (argv, '(i)') n
  else
    n = 128
  endif

  allocate(X(n))
  allocate(Y(n))
  allocate(Yref(n))

  do i=1,n
    X(i) = i
    Y(i) = i + n
    Yref(i) = a * i + (i + n)
  enddo

!$ACC KERNELS
  do i=1,n
    Y(i) = a*X(i) + Y(i)
  enddo
!$ACC END KERNELS

  print *, 'Ran SAXPY for n = ', n
  if (all(Yref  == Y)) then
    print *, 'SUCCESS: Y matches Yref'
  else
    print *, 'FAILURE: Y does not match Yref'
    print *, 'Y = ', Y
    print *, 'Yref = ', Yref
  endif

end program
