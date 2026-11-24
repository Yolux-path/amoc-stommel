FC = gfortran

FFLAGS = -Wall -O0 -fcheck=all -g

SRCS = donnees.f90 fonctions.f90 schemas.f90 post_traitement.f90 amoc_main.f90

OBJS = $(SRCS:.f90=.o)

EXEC = exe

all: $(EXEC)

%.o: %.f90
	$(FC) $(FFLAGS) -c $< 

$(EXEC): $(OBJS)
	$(FC) $(FFLAGS) $^ -o $@

fonctions.o: donnees.o
schemas.o: fonctions.o donnees.o
post_traitement.o: fonctions.o donnees.o
amoc_main.o: donnees.o fonctions.o post_traitement.o schemas.o

clean:
	rm -f *.o *.mod $(EXEC)