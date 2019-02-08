echo "change directory"
cd LIBRARIES

tar -zxvf jasper-1.900.1.tar.gz
cd jasper-1.900.1
./configure --prefix=$DIR/grib2
make
make install

echo "return to main directory"
cd ../..