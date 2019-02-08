echo "change directory"
cd LIBRARIES

# extract mpich
tar -zxvf mpich-3.0.4.tar.gz
cd mpich-3.0.4
./configure --prefix=$DIR/mpich
make
make install

echo "add mpich to environmental path"
sudo echo " " >> ~/.bashrc
sudo echo "#=====MPICH LIBRARY SETTING=====" >> ~/.bashrc
sudo echo "export PATH=$DIR/mpich/bin:$PATH" >> ~/.bashrc

echo "return to main directory"
cd ../..