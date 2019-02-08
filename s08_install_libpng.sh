echo "change directory"
cd LIBRARIES

tar -zxvf libpng-1.2.50.tar.gz
cd libpng-1.2.50
./configure --prefix=$DIR/grib2
make
make install

echo "return to main directory"
cd ../..