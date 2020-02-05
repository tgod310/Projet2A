% read radar RUV radial files 
% from Carlo to create a MAT file
% containing all data
%
% based on scripts by Lucio Bellomo
% itimu Apr 2013

clear all
close all
clc

addpath /home/cheng/RADAR/test_plus/
cm2meters = 0.01;
deg2rad = pi/180;
fillval = -9.9999e+32;

%% define matlab output file
% outpath = '/home/cheng/RADAR/';
% matOutFile = [outpath,'test_Radials_RUV_Carlo.mat'];
% inpath = '/home/cheng/RADAR/';

outpath = '/home/cheng/RADAR/';
%matOutFile = [outpath,'Radials_RUV_May19.nc'];
inpath ='/home/cheng/RADAR/DATA/';% '/mnt/TLNRADAR/DYFAMED/CFER/Archives/Radials/CFER_RDLi_2019_W18_AprMay/';%CFER_RDLi_2019_W02_Jan/';


%% switches
PLOTRAW = 0 ; %to plot raw data

%% specs Sites/Antennas and common parts for reading RUV files
% prefix{1} = [inpath,'DYFAMED/CFER/Archives/Radials/RDLm_VIAR_']; %RDli menas not calibrated


prefix{1} = [inpath,'RDLi_CFER_']; 
% prefix{2} = [inpath,'PCOR/RDLm_PCOR_']; %RDli means not calibrated
% prefix{3} = [inpath,'TINO/RDLm_TINO_']; %RDLm means CALIBRATED

Nsite = length(prefix);

SiteSource = struct('NameAn',{{'CFER'}},...
                    'lonOrg',[7.3271333],...
                    'latOrg',[43.6750000],...
                    'bearin',[212.0],... %Antenna bearing [deg]
                    'Dangle',[5.0],... %angle resolution [deg]
                    'Drange',[1.853400],... %range resol. [km]
                    'Mrange',[45*1.8534],... %max range [km]
                    'colAnt',{{'b'}} );
                   
                
NnoUseLine1 = 6;
NnoUseLine2 = 39;
NnoUseLine3 = 4;
posfix = '.ruv';
STA=SiteSource.NameAn;

%% define time limits
monthstart=5;
monthend=6;
datestart=2;
dateend=11;
hourstart=0;
hourend=23;

date_empty=9;
hour_empty=12;

% pause
time_origin = '2010-01-01 00:00:00';
inidate = datenum(2019,monthstart,datestart,hourstart,00,00);%-datenum(time_origin);
enddate = datenum(2019,monthend,dateend,hourend,00,00);%-datenum(time_origin);

time_new=[inidate:1/24:enddate];
NT = length(time_new);


%% calculates grids for each site 
for iSite = 1 : 1
    bearing = SiteSource.bearin(iSite);
    deltaAng{iSite} = SiteSource.Dangle(iSite);
    maxRange = SiteSource.Mrange(iSite);
    deltaRange = SiteSource.Drange(iSite);
    lonOrg = SiteSource.lonOrg(iSite);
    latOrg = SiteSource.latOrg(iSite);
    [dist{iSite},angle{iSite},xr{iSite},yr{iSite},lonr{iSite},latr{iSite}] = calcRadialGrid(lonOrg,latOrg,bearing,deltaAng{iSite},maxRange,deltaRange);
    
    %% initialize velocity fields 
    [Nangl,Ndist] =  size(dist{iSite});
    vr{iSite} = NaN*ones(Nangl,Ndist,NT);    
end

% test no.1
 
% [lonr,latr]=xylonlat(xr,yr,lon0,lat0,2)

for number=1:(enddate-inidate)*24+1
 
%    if date==date_empty && hour==hour_empty
%         continue
%     end
% date
% hour



% hold on

%% initialize timeStamp
timeStamp = NaN*ones(NT,1);
thisTime_no_string=(number-1)/24+inidate;
thisTime=datestr((number-1)/24+inidate,0);
  
    yyyy = datestr(thisTime,10);
    mm = datestr(thisTime,5);
    dd = datestr(thisTime,7);
    hhmnss = datestr(thisTime,13);
    hh = hhmnss(1:2);

%     for iSite = 1:1
               iSite = 1;    
        ruvFile = [prefix{iSite},yyyy,'_',mm,'_',dd,'_',hh,'00',posfix];   
     
        if(~exist(ruvFile,'file'))
            disp(' ');
            disp(['NOTE : ',ruvFile,' does not exist!']);               
        else
            disp(' ');
            disp([ num2str(number) , 'Reading file : ',ruvFile]); 
            fid = fopen(ruvFile);                            
            % skip useless lines at the beginning of the file
            for iline = 1:NnoUseLine1
               blank = fgetl(fid);
            end
           
            % gets TimeStamp and check it is consistent with thisTime
            line = fgetl(fid);
            [~, tmp] = strtok(line,':');
            tmp = tmp(2:end);
            tmp(isspace(tmp)) = [];         % remove all white spaces
            timeSt = [str2double(tmp(1:4)),   ...    % year
                      str2double(tmp(5:6)),   ...    % month
                      str2double(tmp(7:8)),   ...    % day
                      str2double(tmp(9:10)),  ...    % hour
                      str2double(tmp(11:12)), ...    % minute
                      str2double(tmp(13:14))];       % second
            timeStamp = datenum(timeSt); % days since 01-Jan-0000 00:00:00
            
            %use single for comparison not to have precision issues
%             if(single(timeStamp) ~= single(thisTime)) 
%                 disp(' ');
%                 disp(['timeStamp: ',datestr(timeStamp,0)]);
%                 disp(['thisTime:  ',datestr(thisTime,0)]);
%                 error(['ERROR : timeStamp not consistent with thisTime']);               
%             end

            if(double(timeStamp) ~= double(thisTime_no_string)) 
                disp(' ');
                disp(['timeStamp: ',datestr(timeStamp,0)]);
                disp(['thisTime:  ',datestr(thisTime,0)]);
                error(['ERROR : timeStamp not consistent with thisTime']);               
            end
            
           
            
             blank = fgetl(fid);
            % gets TimeCoverage
            line = fgetl(fid);
            [~, tmp] = strtok(line,':');
            tmp = tmp(2:end);
            [tmp, ~] = strtok(tmp,'.');
            tmp(isspace(tmp)) = [];         % remove all white spaces
            timeCoverage = str2double(tmp); % minutes
            
            % gets Origin (antenna coordinates)
            % note that CODAR is by definition monostatic
            % (emission antenna coincides with receiving antenna). 
            % Hence, lon_tx=lon_rx and lat_tx=lon_rx
            line = fgetl(fid);
            [~, tmp] = strtok(line,':');
            tmp = tmp(2:end);
            tmp = strtrim(tmp);             % remove leading white spaces
            ind = strfind(tmp,' ');
            lat_tx = str2double(tmp(1:ind(1)-1));
            lat_rx = lat_tx;
            tmp = strtrim(tmp(ind(1):end));
            lon_tx = tmp(1:end);
            lon_rx = lon_tx;
            
            % skip some other useless lines in the middle of the file
            % note that if antenna is calibrated there is one line less
    
%             if(iSite == 3)
%                 NnoUseLine2 = NnoUseLine2 - 1;
%             end
%             for iline = 11:(10+NnoUseLine2)
                for iline = 1:NnoUseLine2
                blank = fgetl(fid);
                end 
              
            % reads the number of data (rows) in each file
            dummy = textscan(fid,'%s%d',1);
            NdataLines = dummy{2}(:);
            clear dummy
            
            % skip other useless lines
            for iline = 1:NnoUseLine3
                blank = fgetl(fid);
            end            
            

            % reads data from one line, NdataLines times
   
            Data = textscan(fid,'%f%f%f%f%d%f%f%f%f%d%d%f%f%f%f%f%f%d',NdataLines);
             
             
            % close file
            fclose(fid);
            
            % gets radial velocity in the 16th column of data
            vel = Data{16}(:);
                   
            % gets radial grid index as spectral
            % range cell in the last column of data
            RadPos = Data{18}(:);
            
            % gets angular grid index using bearing angle in the 15th
            % column of data and considering that CODAR angles are degrees 
            % from North so they must be transformed in 90-angle
            AngEast(1:NdataLines) = 90-Data{15}(:)  ;
            AngEast(AngEast<0) = AngEast(AngEast<0) + 360;
            AngPos = (AngEast-angle{iSite}(1))/deltaAng{iSite} + 1;%         AngPos = (AngEast-angle{iSite}(1))/deltaAng{iSite} + 1;
            % insert data in m/sec and in the correct positions
            for idata = 1 : NdataLines
                vr{iSite}(AngPos(idata),RadPos(idata),number) = vel(idata).*cm2meters;
            end
% size(vr{iSite})
            
           
%    end %iSite   
     

% set also dates in 

% julianDay(1,1,number) = timeStamp - datenum(time_origin);
% date3format = julday2date(julianDay,time_origin); 


        end

end%number loop


ncfile=[outpath,'Radials_RUV_May19_filter.nc'];
ang=angle;
% v=vr{1};

%%%create nc
%%% Creation
s = size(xr{1});

time=datestr(time_new);
time_tmp=time_new-datenum(time_origin);

%%  mail


fillval = -9.9999e+32;
vr{1}(isnan(vr{1})) = fillval;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

min_angle=20; % from E, couter-clockwise
max_angle=220;


% find(angle{1}(:,1)>min_angle && angle{1}(:,1)<max_angle)
lonr{1}(find(angle{1}(:,1)>min_angle & angle{1}(:,1)<max_angle),:)=NaN;
latr{1}(find(angle{1}(:,1)>min_angle & angle{1}(:,1)<max_angle),:)=NaN;
xr{1}(find(angle{1}(:,1)>min_angle & angle{1}(:,1)<max_angle),:)=NaN;
yr{1}(find(angle{1}(:,1)>min_angle & angle{1}(:,1)<max_angle),:)=NaN;


%% %%%%%%%%%%%%%%%%%%
% vr(:,:,((date_empty-7)*24+hour_empty+1))=NaN*ones(size(xr,1),size(xr,2));
% julianDay((date_empty-7)*24+hour_empty+1)=(julianDay((date_empty-7)*24+hour_empty)+julianDay((date_empty-7)*24+hour_empty+2))/2;
%%%%%%%%%%%%%%%%%%%%%%%%


nccreate(ncfile,'xr',...
    'Dimensions',{'x',s(1),'y',s(2)}, 'Format','classic');
nccreate(ncfile,'yr',...
    'Dimensions',{'x',s(1),'y',s(2)}, 'Format','classic');
nccreate(ncfile,'lon',...
    'Dimensions',{'x',s(1),'y',s(2)}, 'Format','classic');
nccreate(ncfile,'lat',...
    'Dimensions',{'x',s(1),'y',s(2)}, 'Format','classic');
nccreate(ncfile,'time',...
    'Dimensions',{'time',length(time_new)}, 'Format','classic');
nccreate(ncfile,'v',...
    'Dimensions',{'x',s(1),'y',s(2),'time',length(time_new)} ,'Format','classic');


%%% Attributes
ncwriteatt(ncfile,'xr','long_name',char('Abscisse'));
ncwriteatt(ncfile,'xr','units',    char('km'));
% ncwriteatt(ncfile,'x','point_spacing', char('even'));
ncwriteatt(ncfile,'yr','long_name',char('Ordinate'));
ncwriteatt(ncfile,'yr','units',    char('km'));
% ncwriteatt(ncfile,'y','point_spacing', char('even'));
ncwriteatt(ncfile,'lon','long_name',char('Longitude'));
ncwriteatt(ncfile,'lon','units',    char('decimal deg'));
% ncwriteatt(ncfile,'lon','point_spacing', char('even'));
ncwriteatt(ncfile,'lat','long_name',char('Latitude'));
ncwriteatt(ncfile,'lat','units',    char('decimal deg'));
% ncwriteatt(ncfile,'lat','point_spacing', char('even'));
ncwriteatt(ncfile,'time','long_name',char('Valid Time'));
ncwriteatt(ncfile,'time','units',char(['days since ' time_origin]));
ncwriteatt(ncfile,'time','time_origin',time_origin);

ncwriteatt(ncfile,'v','long_name',   char(['Radial velocity' STA{1}]));
%ncwriteatt(ncfile,'v','comment',     char(['Original format ' EXT]));
ncwriteatt(ncfile,'v','units',       char('m/s'));
% ncwriteatt(ncfile,'v','scale_factor',1);%single(1));
% ncwriteatt(ncfile,'v','add_offset',  0);%single(0));
ncwriteatt(ncfile,'v','_FillValue',  fillval);%single(fillval));

% 
% %%% GLOBAL Attributes
% ncwriteatt(ncfile,'/','title',                   char(['Radial velocity from ' STA]));
% ncwriteatt(ncfile,'/','station',                 char(STA));
% % ncwriteatt(ncfile,'/','grid origin coordinates', char(['lon: ' num2str(lon0)   ', lat: ' num2str(lat0)  ]));
% % ncwriteatt(ncfile,'/','TX site coordinates',     char(['lon: ' num2str(lon_tx) ', lat: ' num2str(lat_tx)]));
% % ncwriteatt(ncfile,'/','RX site coordinates',     char(['lon: ' num2str(lon_rx) ', lat: ' num2str(lat_rx)]));
% % ncwriteatt(ncfile,'/','original_type',           char(EXT));
% % ncwriteatt(ncfile,'/','creation_date',           char(datestr(now)));
% 
% ncwriteatt(ncfile,'/','author',                  char('Molcard'));



% %%% Write variables
ncwrite(ncfile,'xr',xr{1});
ncwrite(ncfile,'yr',yr{1});
ncwrite(ncfile,'lon',lonr{1});
ncwrite(ncfile,'lat',latr{1});
% ncwrite(ncfile,'time',DATEjulian);
ncwrite(ncfile,'time',time_tmp);
ncwrite(ncfile,'v',vr{1});

