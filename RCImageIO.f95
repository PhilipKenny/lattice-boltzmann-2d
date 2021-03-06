module RCImageIO
  use RCImageBasic
 
  implicit none
 
contains
 subroutine read_ppm(u, img) 
  integer, intent(in) :: u
  type(rgbimage), intent(out) :: img
  integer :: i, j, ncol, cc, status
  character(2) :: sign
  character :: ccode
 
  img%width = 0
  img%height = 0
  nullify(img%red)
  nullify(img%green)
  nullify(img%blue)
 
  read(u, '(A2)') sign
  read(u, *) img%width, img%height
  read(u, *) ncol
 
  write(0,*) sign
  write(0,*) img%width, img%height
  write(0,*) ncol

  if ( ncol /= 255 ) return

  call alloc_img(img, img%width, img%height)
  
  if ( valid_image(img) ) then
     do j=1, img%height
        do i=1, img%width
           read(u, '(A1)', advance='no', iostat=status) ccode
           cc = iachar(ccode)
           img%red(i,j) = cc
           read(u, '(A1)', advance='no', iostat=status) ccode
           cc = iachar(ccode)
           img%green(i,j) = cc
           read(u, '(A1)', advance='no', iostat=status) ccode
           cc = iachar(ccode)
           img%blue(i,j) = cc
        end do
     end do
  end if
 
end subroutine read_ppm


  subroutine output_ppm(u, img)
    integer, intent(in) :: u
    type(rgbimage), intent(in) :: img
    integer :: i, j
 
    write(u, '(A2)') 'P6'
    write(u, '(I0,'' '',I0)') img%width, img%height
    write(u, '(A)') '255'
 
    do j=1, img%height
       do i=1, img%width
          write(u, '(3A1)', advance='no') achar(img%red(i,j)), achar(img%green(i,j)), &
                                          achar(img%blue(i,j))
       end do
    end do
 
  end subroutine output_ppm
 
end module RCImageIO
