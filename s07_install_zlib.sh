echo "change directory"
cd LIBRARIES

tar -zxvf zlib-1.2.7.tar.gz
cd zlib-1.2.7
./configure --prefix=$DIR/grib2
make
make install

echo "return to main directory"
cd ../..