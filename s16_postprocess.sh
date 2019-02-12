# from the main directory
wget http://www2.mmm.ucar.edu/wrf/src/ARWpost_V3.tar.gz
tar -zxvf ARWpost_V3.tar.gz

echo "select compiler"
cd ARWpost
./configure

# edit makefile
cd src
echo "add this line: "
echo "-L$(NETCDF)/lib -lnetcdf -lnetcdff -I$(NETCDF)/include -lnetcdf"
vim Makefile

# ecit configuration
cd ..
echo "add this line:"
echo "CFLAGS = -fPIC -m64"
echo "CPP = /lib/cpp -P -traditional"
vim configure.arwp

# compile
./compile

# check output
ls 


