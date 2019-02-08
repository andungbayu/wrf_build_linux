# change directory
echo "enter test directory"
cd fortran_test
# obtain fortran test program and extract
echo "downloading fortran testing codes"
wget http://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/Fortran_C_tests.tar
tar -xvf Fortran_C_tests.tar
# begin test
echo "Test 1: Fixed Format Fortran Test"
ifort TEST_1_fortran_only_fixed.f
./a.out
echo "Test 2: Free Format Fortran"
ifort TEST_2_fortran_only_free.f90
./a.out
echo "Test 3: C compiler"
gcc TEST_3_c_only.c
./a.out
echo "Test 4: Fortran Calling a C Function"
gcc -c -m64 TEST_4_fortran+c_c.c
ifort -c TEST_4_fortran+c_f.f90
ifort TEST_4_fortran+c_f.o TEST_4_fortran+c_c.o
./a.out
echo "Test 5: csh"
csh ./TEST_csh.csh
echo "Test 6: perl"
./TEST_perl.pl
echo "Test 7: sh"
./TEST_sh.sh
echo "return to main directory"
cd ..
