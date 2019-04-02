function wps_readwrite_fnl(numstartdate,dayinterval)
% initiate condition
% clear
% clc

% define date to run
% numstartdate=datenum(2019,1,10,0,0,0);
% dayinterval=1;

% define io
inputfile='namelist.wps.fnl';
outfile='namelist.wps';


% ------------------ program run ----------------------

% read data 
fid=fopen(inputfile);
fo=fopen(outfile,'w');

% creating date vector
numenddate=numstartdate+dayinterval;
s_startdate=datestr(numstartdate,'yyyy-mm-dd_HH:MM:SS');
s_enddate=datestr(numstartdate,'yyyy-mm-dd_18:00:00');

% loop to read and write line
t=1;
tline=fgetl(fid)
while ischar(tline)
    %disp(t)
    %disp(tline)
    if (t==4),
        fprintf(fo,'%s\n',[' start_date = ','''',s_startdate,''',']);
        fprintf(fo,'%s\n',[' end_date   = ','''',s_enddate,''',']);
    elseif (t>4)&&(t<=5)
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
