# change to 'WRFV3/run' directory
cd /home/andung/Downloads/WRF_install/WRFV3/run 

# begin linking
ln -sf /home/andung/Downloads/WRF_install/WPS/met_em* ./

# edit the namelist.input

# 
ulimit -s unlimited

# run wrf
./real.exe
./wrf.exe

# obtain output
cd ../../ARWpost
ln -sf ~/WRF/WRF/run/wrfout_d* ./

