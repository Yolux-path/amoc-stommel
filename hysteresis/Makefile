FFLAGS = -O0 -g -Wall -fcheck=all -ffpe-trap=invalid,zero,overflow

all : exec

exec : donnes.o fonctions.o schemas.o main.o
	gfortran -o exec donnes.o fonctions.o schemas.o main.o

donnes.o : donnes.f90 
	gfortran $(FFLAGS) -c donnes.f90 

fonctions.o : donnes.mod fonctions.f90 
	gfortran $(FFLAGS) -c fonctions.f90 

schemas.o : donnes.mod fonctions.o schemas.f90 
	gfortran $(FFLAGS) -c schemas.f90 

main.o : donnes.mod fonctions.o schemas.o main.f90 
	gfortran $(FFLAGS) -c main.f90

clean : 
	rm -f *.o *.mod exec 

clean_dat : 
	rm -f *.dat 