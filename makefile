#
# makefile for Perple_X 6.9.2+
#
# To compile the Perple_X programs with this file first edit the compiler
# variables so that they are consistent with the fortran installation on 
# your system. Then type the command
#
#                             make -f makefile
#
# where makefile is the name of this file, e.g., LINUX_makefile.
#
# JADC, April 14, 2021    
# 
##################### COMPILER VARIABLES ####################################  
#                   
#                  COMP77 = the name of the local fortran 77 compatible compiler
#COMP77 = g77
COMP77 = gfortran
#                  FFLAGS = compile options
#                  FLINK = linker options
#FFLAGS = -C -O3 -Wpedantic -Wunused

# pappel: for use with gfortran
# JADC 1/21/13: O2 and O3 cause fp errors in the speciation routine speci2 in gfortran, the optimization
# seems to work if local variables are initialized to zero (even though there are no uninitialized variables).
# use -ffpe-trap=zero,overflow,underflow to catch fp errors.
# use -ffpe-trap 
# use -fbounds-check array bound checking
# use -finit-real=snan -fpe=trap check for unitialized variables
# use -Wall -Wextra for extensive warnings

# Mark Caddick's OSX generic gfortran compilation flags:

#FFLAGS = -O3 
#FFLINK = -static-libgfortran -lgfortran -lgcc -lSystem -nodefaultlibs -mmacosx-version-min=10.6  /usr/local/lib/libquadmath.a

# FFLAGS = -finit-local-zero -Os -m64 -static-libgfortran
# For distribution using static (pre-linked) compiler run-time libraries, use
# following compiler flags for gfortran builds on MacOSX/Darwin.  gfortran
# versions up through 4.9 lack the ability to include a static libquadmath, so
# awkward link flags (FLINK) and directory for static libquadmath defined.
# Most commonly, gfortran will use the directory /usr/local/lib, but some
# builds will differ on location.  To find your library location, use a command
# (from the command line) like,
#    find /usr/local -name libquadmath.a -print
# and substitute the directory name you find for LQMDIR.  En garde choosing
# 32/64 bit libraries.
# G. Helffrich/30 Nov. '15
# FFLAGS =  -O3 -static-libgfortran -Wpedantic

FFLAGS = -O3
FLINK = -static-libgfortran -m64 -lgfortran -lgcc -lm 

#-Wstrict-overflow -Wstringop-overflow=2 removed for 690
# WFM Added 2007Sep05, PAPPEL 2010SEPT08: for 6.6.0
MYOBJ = actcor build fluids ctransf frendly meemum convex pstable pspts psvdraw pssect pt2curv vertex werami
all: $(MYOBJ)

LIBRARY = pscom.o pslib.o rlib.o tlib.o flib.o olib.o resub.o minime_blas.o blas2lib.o

LIBRARY_PS = cont_lib.o pscom.o pslib.o tlib.o

clean: 
	rm -f *.o $(MYOBJ)

###################### TARGETS FOR 692+ PROGRAMS ######################### 
#
#
convex: convex.o $(LIBRARY)
	$(COMP77) $(FFLAGS) $(FLINK) convex.o $(LIBRARY) -o $@$(EXT)

meemum: meemum.o $(LIBRARY)
	$(COMP77) $(FFLAGS) $(FLINK) meemum.o $(LIBRARY) -o $@$(EXT)

vertex: vertex.o $(LIBRARY)
	$(COMP77) $(FFLAGS) $(FLINK) vertex.o $(LIBRARY) -o $@$(EXT)

werami: werami.o $(LIBRARY)
	$(COMP77) $(FFLAGS) $(FLINK) $@.o $(LIBRARY) -o $@$(EXT)

pssect: psect.o $(LIBRARY)
	$(COMP77) $(FFLAGS) $(FLINK) psect.o $(LIBRARY) -o $@$(EXT)

pstable: pstable.o $(LIBRARY_PS)
	$(COMP77) $(FFLAGS) $(FLINK) $@.o $(LIBRARY_PS) -o $@$(EXT)

pspts: pspts.o $(LIBRARY_PS) 
	$(COMP77) $(FFLAGS) $(FLINK) $@.o $(LIBRARY_PS) -o $@$(EXT)

psvdraw: psvdraw.o $(LIBRARY_PS)
	$(COMP77) $(FFLAGS) $(FLINK) $@.o $(LIBRARY_PS) -o $@$(EXT)

pt2curv: pt2curv.o $(LIBRARY_PS)
	$(COMP77) $(FFLAGS) $(FLINK) $@.o $(LIBRARY_PS) -o $@$(EXT)

actcor: actcor.o $(LIBRARY)
	$(COMP77) $(FFLAGS) $(FLINK) $@.o $(LIBRARY) -o $@$(EXT)

build: build.o $(LIBRARY)
	$(COMP77) $(FFLAGS) $(FLINK) $@.o $(LIBRARY) -o $@$(EXT)

fluids: fluids.o $(LIBRARY)
	$(COMP77) $(FFLAGS) $(FLINK) $@.o $(LIBRARY) -o $@$(EXT)

ctransf: ctransf.o $(LIBRARY)
	$(COMP77) $(FFLAGS) $(FLINK) $@.o $(LIBRARY) -o $@$(EXT)

DEW_2_ver: DEW_2_ver.o $(LIBRARY)
	$(COMP77) $(FFLAGS) $(FLINK) $@.o $(LIBRARY) -o $@$(EXT)

frendly: frendly.o $(LIBRARY)
	$(COMP77) $(FFLAGS) $(FLINK) $@.o $(LIBRARY) -o $@$(EXT)

#hptover: hptover.o
#	$(COMP77) $(FFLAGS) $@.o -o $@

#htog: htog.o
#	$(COMP77) $(FFLAGS) $@.o -o $@

# targets missing from '07:
#rk: rk.o flib.o tlib.o
#	$(COMP77) $(FFLAGS) $@.o tlib.o flib.o -o $@
#ps_p_contor: ps_p_contor.o pslib.o
#	$(COMP77) $(FFLAGS) $@.o pslib.o -o $@
#ge0pt: ge0pt.o
#	$(COMP77) $(FFLAGS) $@.o -o $@
#satsurf: satsurf.o flib.o tlib.o
#	$(COMP77) $(FFLAGS) $@.o flib.o tlib.o -o $@
#rewrite,sox,gox,cohscont 

#################################################################################
# Explicitly make objects to override the default compiler choice implemented
# on some machines.

actcor.o: actcor.f
	$(COMP77) $(FFLAGS) -c actcor.f
build.o: build.f
	$(COMP77) $(FFLAGS) -c build.f
DEW_2_ver.o: DEW_2_ver.f
	$(COMP77) $(FFLAGS) -c DEW_2_ver.f
fluids.o: fluids.f
	$(COMP77) $(FFLAGS) -c fluids.f
convex.o: convex.f
	$(COMP77) $(FFLAGS) -c convex.f
cont_lib.o: cont_lib.f
	$(COMP77) $(FFLAGS) -c cont_lib.f
ctransf.o: ctransf.f
	$(COMP77) $(FFLAGS) -c ctransf.f
frendly.o: frendly.f
	$(COMP77) $(FFLAGS) -c frendly.f
#ge0pt.o: ge0pt.f
#	$(COMP77) $(FFLAGS) -c ge0pt.f
#hptover.o: hptover.f
#	$(COMP77) $(FFLAGS) -c hptover.f
#htog.o: htog.f
#	$(COMP77) $(FFLAGS) -c htog.f
psect.o: psect.f
	$(COMP77) $(FFLAGS) -c psect.f
psvdraw.o: psvdraw.f
	$(COMP77) $(FFLAGS) -c psvdraw.f
pscom.o: pscom.f
	$(COMP77) $(FFLAGS) -c pscom.f
pspts.o: pspts.f
	$(COMP77) $(FFLAGS) -c pspts.f
pstable.o: pstable.f
	$(COMP77) $(FFLAGS) -c pstable.f

# NEXT LINE MODIFIED BY pappel (PA@MIN.UNI-KIEL.DE) 2010SEPT08: CHANGED ptcurv.o TO pt2curv.o

pt2curv.o: pt2curv.f
	$(COMP77) $(FFLAGS) -c pt2curv.f
werami.o: werami.f
	$(COMP77) $(FFLAGS) -c werami.f
flib.o: flib.f
	$(COMP77) $(FFLAGS) -c flib.f
pslib.o: pslib.f
	$(COMP77) $(FFLAGS) -c pslib.f
vertex.o: vertex.f
	$(COMP77) $(FFLAGS) -c vertex.f
meemum.o: meemum.f
	$(COMP77) $(FFLAGS) -c meemum.f
resub.o: resub.f
	$(COMP77) $(FFLAGS) -c resub.f
tlib.o: tlib.f
	$(COMP77) $(FFLAGS) -c tlib.f
olib.o: olib.f
	$(COMP77) $(FFLAGS) -c olib.f
rlib.o: rlib.f
	$(COMP77) $(FFLAGS) -c rlib.f
blas2lib.o: blas2lib.f
	$(COMP77) $(FFLAGS) -c blas2lib.f
minime_blas.o: minime_blas.f
	$(COMP77) $(FFLAGS) -c minime_blas.f

# WFM 2007Sep05
.c.o:
	$(CC) $(CFLAGS) $(INCL) -c $<

.f.o:
	$(FC) $(FFLAGS) $(INCL) -c $<
