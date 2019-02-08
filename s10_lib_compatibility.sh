echo "testing library compatibility"

cd COMPATIBILITY_TEST
wget http://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/Fortran_C_NETCDF_MPI_tests.tar
tar -xvf Fortran_C_NETCDF_MPI_tests.tar

echo " "
echo "BEGIN 1ST TEST"
cp ${NETCDF}/include/netcdf.inc .
ifort -c 01_fortran+c+netcdf_f.f
icc -c 01_fortran+c+netcdf_c.c
ifort 01_fortran+c+netcdf_f.o 01_fortran+c+netcdf_c.o -L${NETCDF}/lib -lnetcdff -lnetcdf
./a.out

echo " "
echo "BEGIN 2ND TEST"
cp ${NETCDF}/include/netcdf.inc .
mpif90 -c 02_fortran+c+netcdf+mpi_f.f
mpicc -c 02_fortran+c+netcdf+mpi_c.c
mpif90 02_fortran+c+netcdf+mpi_f.o 02_fortran+c+netcdf+mpi_c.o -L${NETCDF}/lib -lnetcdff -lnetcdf
mpirun ./a.out

echo "return to main directory"
cd ..