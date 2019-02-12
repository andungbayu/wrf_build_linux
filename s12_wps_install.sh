# download data
wget http://www2.mmm.ucar.edu/wrf/src/WPSV3.8.TAR.gz
tar -zxvf WPSV3.8.TAR.gz

# changing directory and run clean
cd WPS
./clean
cd ..

# insert jasperlib to ~/.bashrc
sudo echo " " >> ~/.bashrc 
Sudo echo "#JASPER LIBRARY" >> ~/.bashrc 
sudo echo "export JASPERLIB=~/Downloads/WRF_install/LIBRARIES/grib2/lib" >> ~/.bashrc
sudo echo "export JASPERINC=~/Downloads/WRF_install/LIBRARIES/grib2/include" >> ~/.bashrc

# notify to reload ~/.bashrc
echo "type 'source ~/.bashrc' to reload the resource file "



