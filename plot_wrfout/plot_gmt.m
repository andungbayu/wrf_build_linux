% initiate condition
clear
clc

% load netcdf package
pkg load netcdf

% load wrf output data
% load('wrf_fnl_2019-01-10_00:00.mat');

% dummy load latlon
samplewrf='wrfout_d03_2019-01-12_17:45:00';
lat=ncread(samplewrf,'XLAT');
lon=ncread(samplewrf,'XLONG');
T2=ncread(samplewrf,'T2');

% squeeze lat lon
lat=double(lat(1,:));
lon=double(lon(:,1).');

% select variables to load
% T2=wrf.T2;
% T2=T2.';

% convert temperatur to celciut
T2=T2-273;

% create netcdf
ncid = netcdf_create('test_files.nc','CLASSIC_MODEL');

% define dimension
dim_lon = netcdf_defDim(ncid,'lon',length(lon));
dim_lat = netcdf_defDim(ncid,'lat',length(lat));
dim_depth = netcdf_defDim(ncid,'z',1);
dim_time = netcdf_defDim(ncid,'time',1);

% define variable
var_lon = netcdf_defVar(ncid,'lon','double',dim_lon);
var_lat = netcdf_defVar(ncid,'lat','double',dim_lat);
var_dep = netcdf_defVar(ncid,'z','double',dim_depth);
var_ti = netcdf_defVar(ncid,'time','double',dim_time);
var_data = netcdf_defVar(ncid,'data','double',[dim_lon,dim_lat,dim_depth,dim_time]);

% end mode definition
netcdf_endDef(ncid);

% write data
netcdf_putVar(ncid,var_lon,lon);
netcdf_putVar(ncid,var_lat,lat);
netcdf_putVar(ncid,var_dep,1);
netcdf_putVar(ncid,var_ti,1);
netcdf_putVar(ncid,var_data,T2);

% close netcdf
netcdf_close(ncid);

% --------------------------convert data to GMT -------------------------

system('gmt grdconvert test_files.nc?data -Gtemp.nc -V')

%---------------------------- define GMT plot ---------------------------

% file definition
grdfile='temp.nc';
h_label='';
v_label='';
plottitle='Temperatur (@+o@+C)';
paperx=20;
papery=20;

% define grid resolution and range for gridding
min_x=num2str(min(lon(:)));
max_x=num2str(max(lon(:)));
min_y=num2str(min(lat(:)));
max_y=num2str(max(lat(:)));
psfile='layout.ps';

% define GMT colormap (jet,rainbow,panoply,no_green)
colortype='rainbow'; 
minrange='15.00';
maxrange='30.00';
interval='0.10';
cptfile='color.cpt';
discrete_color=' -D'; % -M -D

% define grid spacing
projection='-Jm7c';
h_tick='1';
v_tick='1';
wsenlabel='WSen';

% define colorbar position
xbar_pos='2c';
ybar_pos='-1.5c';
bartype='+h';            % +h, default vertical
barlen='10c';          % cm
bararrow='';           % -E b/f/bf
bar_interval='5';
barlabel='';

%---------------------------- define paper size--------------------------

% override papersize
papersize=[num2str(paperx),'cx',num2str(papery),'c'];
            
% change GMT default parameter
system(['gmt gmtset PS_MEDIA Custom_',papersize]);
system( 'gmt gmtset MAP_FRAME_TYPE plain');
system( 'gmt gmtset COLOR_NAN white');


%---------------------------- create CPT file ---------------------------

% begin override GMT colormap
system(['gmt makecpt -C',colortype,' -T',minrange,'/',maxrange,'/',...
            interval,discrete_color,' > ',cptfile]);


%------------------------------- begin plot -----------------------------

% plot data
system(['gmt grdview ',grdfile,...
    ' -R',min_x,'/',max_x,'/',min_y,'/',max_y,' ',projection,...
    ' -Ba',h_tick,':"',h_label,'":','/a',v_tick,':"',v_label,'":',...
    wsenlabel,':."',plottitle,'": ',...
    ' -C',cptfile,...
    ' -K -T > ',psfile]);

% plot coast
system(['gmt pscoast -Da -R -J -B -W0.5p -O -K >> ',psfile]);

% plot kabupaten
system(['gmt psxy kabupaten.gmt.xy -R -J -B -W0.5p -O -K >> ',psfile])

% plot colorbar
system(['gmt psscale -C',cptfile,...
    ' -Dx',xbar_pos,'/',ybar_pos,'+w',barlen,'/0.18c',bartype,...
    ' -Ba',bar_interval,':"',barlabel,'":/a:"": ',bararrow,...
    ' -S -O >> ',psfile]);

% --------------------------- convert to image ---------------------------

% define output name
outname='temperatur.jpg';
system(['gmt psconvert ',psfile,' -A -Tj -F',outname])

