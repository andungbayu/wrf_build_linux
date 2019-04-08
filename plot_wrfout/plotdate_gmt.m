% initiate condition
clear
clc

% dummy date and value
startdate=datenum(2019,1,1,0,0,0);
enddate=datenum(2019,7,1,0,0,0);
daterange=startdate:enddate;
value=rand(length(daterange),1);

% define y_axis position of text in plot
text_ypos=0.0;
plot_ymax=1;

% create sum monthly vector
data_mon=zeros(7,1);
date_mon=zeros(7,1);

% create index and string to record monthly date
idx_date=ones(7,1);
str_date{1}=datestr(startdate,'mm/yyyy');

% -------------------------- begin calculation ---------------------------

% loop to populate each month
nmonth=1;
prevmonthvec=datevec(startdate);
prevmonth=prevmonthvec(2);
for t=1:length(daterange),

    % obtain current month
    getmonthvec=datevec(daterange(t));
    getmonth=getmonthvec(2);

    % compare month with previous month
    if getmonth~=prevmonth,

        % add monthly count
        date_mon(nmonth)=prevmonth;

        % skip for the next same month
        prevmonth=getmonth;

        % add increment 
        nmonth=nmonth+1;

        % update string and index date
        idx_date(nmonth)=t;
        str_date{nmonth}=datestr(daterange(t),'mm/yyyy');

    end

    % add data to vector
    data_mon(nmonth)=data_mon(nmonth)+value(t);
   
% terminate loop t
end    

% add shift to date index to plot
idx_date_shift=idx_date+10;

% reindex monthly data xy position
for t=1:length(daterange),

    % obtain current month
    getmonthvec=datevec(daterange(t));
    getmonth=getmonthvec(2);

    % search similar month
    midx=find(date_mon==getmonth);
    if isempty(midx)==false
        data_mon_daily(t)=data_mon(midx);
    else
        data_mon_daily(t)=nan;
    end

% terminate loop t
end

% --------------------------export to delimited-------------------------- 

% create daily table
dailytable(:,1)=1:length(daterange);
dailytable(:,2)=value;
dlmwrite('dailydata.xy',dailytable);

% create monthly table
monthlytable(:,1)=1:length(daterange);
monthlytable(:,2)=data_mon_daily;
dlmwrite('monthlydata.xy',monthlytable);

% create date information
fID=fopen('date.txt','w');
for nrow=1:length(idx_date)-1
    fprintf(fID,'%6.2f,%6.2f,%s \n',....
    idx_date_shift(nrow),text_ypos,char(str_date(nrow)));
end
fclose(fID)

% create date separator
fID=fopen('separator.xy','w');
for nrow=1:length(idx_date)
    fprintf(fID,'%s \n','>');
    fprintf(fID,'%6.2f,%6.2f \n',idx_date(nrow),0);
    fprintf(fID,'%6.2f,%6.2f \n',idx_date(nrow),plot_ymax);
end
fclose(fID)


% run in non debug mode only
debug=0;
if debug==0,

%---------------------------- define GMT plot ---------------------------

% file definition
psfile='graph.ps';
outname='grafik.jpg';
paperx=20;
papery=20;

% plot definition
projection='-JX15c/8c';
plottitle='Temperatur (@+o@+C)';



%---------------------------- define paper size--------------------------

% override papersize
papersize=[num2str(paperx),'cx',num2str(papery),'c'];
            
% change GMT default parameter
system(['gmt gmtset PS_MEDIA Custom_',papersize]);
system( 'gmt gmtset MAP_FRAME_TYPE plain');
system( 'gmt gmtset COLOR_NAN white');


%------------------------------- begin plot -----------------------------

% define 1st parameter
min_x='1';
max_x=num2str(length(value));
min_y='0';
max_y=num2str(max(value));
v_tick='0.2';
v_label='Temperatur harian';

% plot daily data
system(['gmt psxy dailydata.xy',...
    ' -R',min_x,'/',max_x,'/',min_y,'/',max_y,' ',projection,...
    ' -B','/a',v_tick,':"',v_label,'":','Wsn',':."',plottitle,'": ',...
    ' -Sb0.05cb0 -Ggrey ',...
    ' -K > ',psfile]);

% plot monthly separator
system(['gmt psxy separator.xy',...
    ' -R -J -B',...
    ' -W1p',...
    ' -O -K >> ',psfile]);

% plot monthly time
system(['gmt pstext date.txt -R -J -B ',...
    '-F+jTL+f10p,Helvetica -N -O -K >> ',psfile]);

% define 2nd parameter
min_x='1';
max_x=num2str(length(value));
min_y='0';
max_y=num2str(1.2.*((max(data_mon_daily))-str2num(min_y)));
v_tick='2';
v_label='Temperatur bulanan';

% plot monthly data
system(['gmt psxy monthlydata.xy',...
    ' -R',min_x,'/',max_x,'/',min_y,'/',max_y,' ',projection,...
    ' -B','/a',v_tick,':"',v_label,'":','sEn',':."',plottitle,'": ',...
    ' -W1p,red',...
    ' -O >> ',psfile]);



% --------------------------- convert to image ---------------------------

% define output name

system(['gmt psconvert ',psfile,' -A -Tj -F',outname])

% terminate debug mode option
end

