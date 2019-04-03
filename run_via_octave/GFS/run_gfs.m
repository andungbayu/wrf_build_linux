% Before running WRF model, intel fortran resource
% must be called and memory stack should be set to unlimited
% run the command below:
%        source ~/wrf_lib/ifort15/ifortrc
%        ulimit -s unlimited

% initiate condition
clear
clc

% define package to load
pkg load netcdf

% define WRF folder to run
octavedir='/home/andung/WRF/WRFrun_octave';
WPSdir='/home/andung/WRF/WPS';
WRFdir='/home/andung/WRF/WRF/run';

% define GFS website to get the data
website='https://nomads.ncdc.noaa.gov/data/gfs4';

% define GFS grib datasource 
datasource=[octavedir,'/gfsfile'];

% define pause checking time in seconds
pause_gfs_folder=1;
pause_gfs_file=1;

% GFS time length to run in WRF (in hour)
GFS_end_time=120;

% define start date of processing
numstartdate=datenum(2019,1,10,0,0,0);
dayinterval=5;
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
wps_readwrite_gfs(startdate,dayinterval);

% generate WRF namelist
wrf_readwrite_gfs(startdate,dayinterval);

% ------------------- download GFS data -------------------

% debuging
debug=0;
if debug==0

% change directory to gfs datasource
cd(datasource)  

% empty grib input data
delete('*.grib2')

% check month of new gfs data 
outmonth=[];
while (isempty(outmonth)==true),
    searchmonth=datestr(startdate,'yyyymm');
    searchlink=searchmonth;
    syntax=['wget -O read.html ',website];
    system(syntax);
    page=fileread('read.html');
    outmonth=findstr(page,searchlink);
    delete('read.html');
    pause(pause_gfs_folder);
end

% check day of new gfs data 
outday=[];
while (isempty(outday)==true),
    searchday=datestr(startdate,'yyyymmdd');
    searchlink=searchday;
    syntax=['wget -O read.html ',website,'/',searchmonth];
    system(syntax);
    page=fileread('read.html');
    outday=findstr(page,searchlink);
    delete('read.html');
    pause(pause_gfs_folder);
end

% check file of new gfs data 
syntax=['wget -O read.html ',website,'/',searchmonth,'/',searchday];
system(syntax);
page=fileread('read.html');
delete('read.html');

% generate series to download GFS
gfs_series=0:3:120;

% loop to each data
for ngfs=1:length(gfs_series)

    % define gsf_file
    gfsfile=['gfs_4_',searchday,'_0000_',sprintf('%03d',gfs_series(ngfs)),'.grb2'];
    % check exist
    while exist(gfsfile,'file')==false,

        % download file
        syntax=['wget ',website,'/',searchmonth,'/',searchday,'/',gfsfile];
        system(syntax);
        pause(pause_gfs_file)

    end

% terminate loop ngfs
end    

% terminate debug
end

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
dfile=120;

% generate time series to read wrf output
wrf_tseries=startdate:(1/dfile):startdate+dayinterval;

% loop to read each file
for tfile=1:dfile % 23 hours ahead

    % define name  
    wrfoutdate=datestr(wrf_tseries(tfile),...
    'yyyy-mm-dd_HH:MM:SS');
    wrfoutname=['wrfout_d01_',wrfoutdate];

    % check exist
    if exist(wrfoutname,'file')

        % get data from output
        wrf.T2=ncread(wrfoutname,'T2');
        wrf.Q2=ncread(wrfoutname,'Q2');
        wrf.U10=ncread(wrfoutname,'U10');
        wrf.V10=ncread(wrfoutname,'V10');
        wrf.RAINNC=ncread(wrfoutname,'RAINNC');
        wrf.SWDNB=ncread(wrfoutname,'SWDNB');

        % save data from output
        savedate=datestr(wrf_tseries(tfile),...
        'yyyy-mm-dd_HH:MM');
        savename=['wrf_gfs_',savedate,'.mat'];
        save(savename,'wrf');

    % terminate exist file
    end 

% terminate loop tfile
end 

% calculate daily summary


% move all result to specified folder
matfile='*.mat';
copymat=[octavedir,'/output_gfs/'];
movefile(matfile,copymat);

% -------------- finishing process -----------------

% change directory
cd(copymat);

% layout and plot data

% add time increment
t=t+1;

% end infinity loop while
end

