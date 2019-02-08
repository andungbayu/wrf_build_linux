echo "change directory"
cd LIBRARIES

# extract netcdf
tar -zxvf netcdf-4.1.3.tar.gz
cd netcdf-4.1.3
./configure --prefix=$DIR/netcdf --disable-dap --disable-netcdf-4 --disable-shared
make
make install

echo "add netcdf to environmental path"
sudo echo " " >> ~/.bashrc
sudo echo "#=====NETCDF LIBRARY SETTING=====" >> ~/.bashrc
sudo echo "export PATH=$DIR/netcdf/bin:$PATH" >> ~/.bashrc
sudo echo "export NETCDF=$DIR/netcdf" >> ~/.bashrc

echo "return to main directory"
cd ../..