function wrf_readwrite_fnl(numstartdate,dayinterval)
% initiate condition
%clear
%clc

% define date to run
%numstartdate=datenum(2019,1,10,0,0,0);
%dayinterval=1;

% define io
inputfile='namelist.input.gfs';
outfile='namelist.input';


% ------------------ program run ----------------------

% read data 
fid=fopen(inputfile);
fo=fopen(outfile,'w');

% creating date vector
numenddate=numstartdate+dayinterval-1;
startdate=datevec(numstartdate);
enddate=datevec(numenddate);

% loop to read and write line
t=1;
tline=fgetl(fid)
while ischar(tline)
%    disp(t)
%    disp(tline)
    if (t==6),
        fprintf(fo,'%s\n',[' start_year = ',num2str(startdate(1)), ', ']);
        fprintf(fo,'%s\n',[' start_month = ',num2str(startdate(2)), ', ']);
        fprintf(fo,'%s\n',[' start_day = ',num2str(startdate(3)), ', ']);
        fprintf(fo,'%s\n',[' start_hour = ',num2str(startdate(4)), ', ']);
        fprintf(fo,'%s\n',[' end_year = ',num2str(enddate(1)), ', ']);
        fprintf(fo,'%s\n',[' end_month = ',num2str(enddate(2)), ', ']);
        fprintf(fo,'%s\n',[' end_day = ',num2str(enddate(3)), ', ']);
        fprintf(fo,'%s\n',[' end_hour = ',num2str(21), ', ']);
    elseif (t>6)&&(t<=13)
        % skip writing 
    else 
        fprintf(fo,'%s\n',tline);
    end

    % add increment and read next file
    t=t+1;
    tline=fgetl(fid);
end

fclose(fid);
fclose(fo);
