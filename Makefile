# The compiler
FC = gfortran
# flags for debugging or for maximum performance, comment as necessary
FCFLAGS = -g -fbounds-check
FCFLAGS = -O3 -pg
# flags forall (e.g. look for system .mod files, required in gfortran)
FCFLAGS += -I/usr/include

# libraries needed for linking, unused in the examples
#LDFLAGS = -li_need_this_lib

# List of executables to be built within the package
PROGRAMS = LATTICEB_MAN
#RCImageBasic.f95 RCImageIO.f95 LB_PROCEDURES.F95 LATTICEB_MAN.F95

# "make" builds all
all: $(PROGRAMS)

RCImageIO.o: RCImageBasic.o 
RCImageIO: RCImageBasic.o 
LB_PROCEDURES.o: RCImageBasic.o RCImageIO.o
LB_PROCEDURES: RCImageBasic.o RCImageIO.o
LATTICEB_MAN: RCImageBasic.o RCImageIO.o LB_PROCEDURES.o


# ======================================================================
# And now the general rules, these should not require modification
# ======================================================================

# General rule for building prog from prog.o; $^ (GNU extension) is
# used in order to list additional object files on which the
# executable depends
%: %.o
	$(FC) $(FCFLAGS) -o $@ $^ $(LDFLAGS)

# General rules for building prog.o from prog.f90 or prog.F90; $< is
# used in order to list only the first prerequisite (the source file)
# and not the additional prerequisites such as module or include files
%.o: %.f95
	$(FC) $(FCFLAGS) -c $<

%.o: %.F95
	$(FC) $(FCFLAGS) -c $<

# Utility targets
.PHONY: clean veryclean

clean:
	rm -f *.o *.mod *.MOD

veryclean: clean
	rm -f *~ $(PROGRAMS)


