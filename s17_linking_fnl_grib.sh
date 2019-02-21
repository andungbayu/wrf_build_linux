# define FNL grib datasource (This is only for FNL & GFS data)
datasource='/home/andung/research/wrf_grib/jogjacase/'

# begin linking FNL GRIB2
./link_grib.csh $datasource

# linking vtable
ln -sf ungrib/Variable_Tables/Vtable.GFS Vtable

# Running WPS
./geogrid.exe
./ungrib.exe
./metgrid.exe

