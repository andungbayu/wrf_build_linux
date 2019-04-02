% Before running WRF model, intel fortran resource
% must be called and memory stack should be set to unlimited
% run the command below:
%        source ~/wrf_lib/ifort15/ifortrc
%        set ulimit unlimited

% initiate condition
clear
clc

% define package to load
pkg load netcdf

% define WRF folder to run
octavedir='/home/andung/WRF/WRFrun_octave';
WPSdir='/home/andung/WRF/WPS';
WRFdir='/home/andung/WRF/WRF/run';
postdir='/data/wrf/fnl';

% define FNL grib datasource (This is only for FNL & GFS data)
datasource=[octavedir,'/fnlfile'];

% define FNL login password (check csh file for username)
fnl_pass='';

% define start date of processing
numstartdate=datenum(2019,1,10,0,0,0);
dayinterval=1;
t=0;

% begin infinity loop
while true

% ------------------- generate namelist -------------------

% go to octave directory
cd(octavedir)

% define WPS and WRF startdate 
if (t==0),
    startdate=numstartdate;
else
    startdate=numstartdate+t;
end

% generate WPS namelist 
wps_readwrite_fnl(startdate,dayinterval);

% generate WRF namelist
wrf_readwrite_fnl(startdate,dayinterval);

% ------------------- download FNL data -------------------

% empty FNL data
delete('*.grib2')

% generate csh script to download FNL
download_readwrite_fnl(startdate);

% run csh script to download
system(['csh get_fnl.csh ',fnl_pass]); 

% check if all file successfuly downloaded

% move grib file to download folder
genfile='*.grib2';
getfname=[datasource,'/'];
movefile(genfile,getfname);

% change directory
cd(datasource);

%--------------------- WPS PROCESSING ---------------------

% change directory to WPS
cd(WPSdir);

% cleaning previous run
delete('GRIBFILE.*')
delete('FILE:*')
delete('met_em.d*')
delete('geo_em.d*')
delete('Vtable')
delete('namelist.wps')

% copy generated namelist from octave
namelistfile=[octavedir,'/namelist.wps'];
copyname=[WPSdir,'/namelist.wps'];
copyfile(namelistfile,copyname);

% Linking FNL GRIB2  
string=['./link_grib.csh ',datasource,'/'];
system(string);

% Linking vtable
string='ln -sf ungrib/Variable_Tables/Vtable.GFS Vtable';
system(string);

% running WPS
system('./geogrid.exe');
system('./ungrib.exe');
system('./metgrid.exe');


% ----------------- WRF PROCESSING ---------------------- 

% change directory to WRF
cd(WRFdir);

% delete previous result
delete('wrfinput_d0*');
delete('wrfout_d0*');
delete('wrfbdy_d0*');
delete('met_em*');
delete('namelist.input');

% copy generated namelist from octave
namelistfile=[octavedir,'/namelist.input'];
copyname=[WRFdir,'/namelist.input'];
copyfile(namelistfile,copyname);

% linking with WPS output
string=['ln -sf ',WPSdir,'/met_em* ./'];
system(string);

% wait for running WRF process to finish
syntax='pgrep -x wrf.exe';
[stats,out]=system(syntax);

% check other WRF process
while isempty(out)==0,

   % wait seconds for other WRF process to finish
   pause(900)

   % scan again for running WRF process to finish
   syntax='pgrep -x wrf.exe';
   [stats,out]=system(syntax);

% terminate isempty
end

% run wrf  
pause(15);
system('mpirun ./real.exe')
pause(15);
system('mpirun ./wrf.exe')

% ---------------- do post processing -----------------

% define number of file each day
dfile=24;

% generate time series to read wrf output
wrf_tseries=startdate:(1/dfile):startdate+1;

% loop to read each file
for t=1:2 %dfile-1 % 23 hours ahead

    % define name  
    wrfoutdate=datestr(wrf_tseries(t),...
    'yyyy-mm-dd_HH:MM:SS');
    wrfoutname=['wrfout_d01_',wrfoutdate];

    % get data from output
    wrf.T2=ncread(wrfoutname,'T2');
    wrf.Q2=ncread(wrfoutname,'Q2');
    wrf.U10=ncread(wrfoutname,'U10');
    wrf.V10=ncread(wrfoutname,'V10');
    wrf.RAINNC=ncread(wrfoutname,'RAINNC');
    wrf.SWDNB=ncread(wrfoutname,'SWDNB');

    % save data from output
    savedate=datestr(wrf_tseries(t),...
    'yyyy-mm-dd_HH:MM');
    savename=['wrf_fnl_',savedate,'.mat'];
    save(savename,'wrf');

% terminate loop t
end 

% calculate daily summary


% move all result to specified folder
matfile='*.mat';
copymat=[octavedir,'/output/'];
copyfile(matfile,copymat);

% -------------- finishing process -----------------

% change directory
cd(copymat);

% layout and plot data

% add time increment
t=t+1;

% end infinity loop while
end

