PROGRAM LATTICEB_MAN
    USE LB_PROCEDURES
!-------------------------------------------------------------------------------
!   LATTICEB_MAN.F95
!
!   Philip Kenny    -   10/5/2014
!
! This program implements a simple lattice boltzmann simulation in 2 dimensions
! 
! Initial and boundary conditions are read from the local file './input'
!  
! The user can specify the size of the simulation and either one or both
! boundaries to be periodic. The geometry of the solid object is specified by
! coordinates of voxels where the REFLECTION subroutine is invoked.
! 
! Reflection is implemented as a simple inversion of momenta - ie probabilty
! density that enters an element of gemoetry is ejected in the opposite
! direction it entered. This may be an oversimplification but it enables simple 
! rules and no case checking to prevent probability distribution from getting
! trapped in areas of adjacent geometry elements.
!-------------------------------------------------------------------------------

IMPLICIT NONE

DOUBLE PRECISION, DIMENSION(:,:,:), POINTER :: DOMAIN, DOMAIN_2, TEMP
INTEGER :: M, N, NUM_SOLIDS, TIME = 0, END_TIME
INTEGER , ALLOCATABLE, DIMENSION(:,:) :: SOLID_VOXELS
LOGICAL, ALLOCATABLE, DIMENSION(:,:) :: IS_SOLID
DOUBLE PRECISION :: RELAXATION
TYPE(RGBIMAGE) :: IO_IMAGE
TYPE (BOUNDARY_CONDITIONS) :: B_CONDS

    CALL ALLOCATE_DATA(DOMAIN, DOMAIN_2, SOLID_VOXELS, B_CONDS, IS_SOLID,  &
    						 M, N, NUM_SOLIDS, IO_IMAGE, RELAXATION, END_TIME)
    
    CALL INITIALISE_VALUES(DOMAIN, DOMAIN_2, SOLID_VOXELS, NUM_SOLIDS)
    DOMAIN_2 = 0;
!    CALL PRINT_DENSITY(DOMAIN, M, N, IO_IMAGE)
    DO WHILE (TIME <= END_TIME)

        CALL COLLISION(DOMAIN, IS_SOLID, M, N, RELAXATION)
        IF(MOD(TIME, 100) == 0) THEN
		 	CALL PRINT_VELOCITY(DOMAIN, IS_SOLID, M, N, TIME, IO_IMAGE)
            CALL PRINT_DENSITY(DOMAIN, IS_SOLID, M, N, TIME, IO_IMAGE)
!          CALL SLEEP(1)
        END IF               
        CALL ACCELERATE_FLOW(DOMAIN, M, IS_SOLID)
        CALL ADVECTION (DOMAIN, DOMAIN_2, IS_SOLID, M, N)
        CALL REFLECTION(DOMAIN_2, SOLID_VOXELS, NUM_SOLIDS)
        CALL ENFORCE_BOUNDARIES(DOMAIN_2, M, N, B_CONDS)
!        CALL COLLISION(DOMAIN_2, IS_SOLID, M, N, RELAXATION)
        CALL UPDATE_BUFFER(DOMAIN, DOMAIN_2, TEMP)
        TIME = TIME + 1
!        CALL PRINT_DENSITY(DOMAIN, M, N, IO_IMAGE) 
    END DO
!    CALL PRINT_DENSITY(DOMAIN, M, N, IO_IMAGE)    
    CALL FREE_IMG(IO_IMAGE)

   
END PROGRAM LATTICEB_MAN
