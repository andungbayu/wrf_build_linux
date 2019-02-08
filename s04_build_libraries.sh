echo "change directory"
cd LIBRARIES

# download libraries
wget http://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/mpich-3.0.4.tar.gz\
 http://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/netcdf-4.1.3.tar.gz \
 http://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/jasper-1.900.1.tar.gz \
 http://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/libpng-1.2.50.tar.gz \
 http://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/zlib-1.2.7.tar.gz

# setting up parameter
sudo echo " " >> ~/.bashrc
sudo echo "#=====WRF LIBRARY PACK=====" >> ~/.bashrc
sudo echo "export DIR=~/Downloads/WRF_install/LIBRARIES" >> ~/.bashrc
sudo echo "export CC=gcc"  >> ~/.bashrc
sudo echo "export CXX=g++"  >> ~/.bashrc
sudo echo "export FC=ifort"  >> ~/.bashrc
sudo echo "export F77=ifort"  >> ~/.bashrc
#sudo echo "export FCFLAGS="  >> ~/.bashrc
#sudo echo "export FFLAGS="  >> ~/.bashrc
 
echo "return to main directory"
cd ..