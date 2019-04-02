function download_readwrite_fnl(daily)

% define io
inputfile='get_fnl.csh.default';
outfile='get_fnl.csh';


% ------------------ program run ----------------------

% read data 
fid=fopen(inputfile);
fo=fopen(outfile,'w');

% creating date vector
filedate=datestr(daily,'yyyy/yyyy.mm/fnl_yyyymmdd');

% loop to read and write line
t=1;
tline=fgetl(fid)
while ischar(tline)
%    disp(t)
%    disp(tline)
    if (t==45),
        fprintf(fo,'%s\n',[' grib2/',filedate,'_00_00.grib2 \']);
        fprintf(fo,'%s\n',[' grib2/',filedate,'_06_00.grib2 \']);
        fprintf(fo,'%s\n',[' grib2/',filedate,'_12_00.grib2 \']);
        fprintf(fo,'%s\n',[' grib2/',filedate,'_18_00.grib2 \']);
      
    elseif (t>45)&&(t<=48)
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
