# download geogrid to main folder
#wget http://www2.mmm.ucar.edu/wrf/src/wps_files/geog_complete.tar.bz2
wget http://www2.mmm.ucar.edu/wrf/src/wps_files/geog_complete.tar.gz
tar -xvf geog_complete.tar.bz2
mv geog WPS_GEOG

# configure WPS to use geogrid
cd WPS
vim namelist.wps

# add geogrdi directoty
echo "geog_data_path = '{path_to_dir}/Build_WRF/WPS_GEOG' to directory"

