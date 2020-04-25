function data_drifter = read_DRIFTER(name_file,Const)
% read_DRIFTER read xlsx files of drifters
%return  date, position ,speed 
%% Read data
dd = readmatrix(name_file);

%% Reference
% ds=datastore(name_file);
% dv=read(ds);
% reference = dv(1,1);
% data_drifter.ref = reference;

%% date in julian calendar
jour = num2str(dd(:,3));
mois = num2str(dd(:,2));
annee = num2str(dd(:,4));
heure = num2str(dd(:,5));
minute = num2str(dd(:,6));
sec  = num2str(dd(:,7));

DateString=strcat(annee,{'-'},mois,{'-'},jour,{' '},heure,{':'},minute,{':'},sec);
formatIn = 'yyyy-mm-dd HH:MM:SS'; 

data_drifter.time = datenum(DateString,formatIn);
data_drifter.time_origin=0;

%%% Measure errors 
%%% If 2 measures are in a range below  10 seconds we remove it 

i=1;
while i<length(data_drifter.time)
    if (data_drifter.time(i)-data_drifter.time(i+1)<(90/Const.d2s))
        data_drifter.time(i)=NaN;
    end
    i=i+1;
end

%% drifter position
data_drifter.lat = dd(:,9);
data_drifter.lon = dd(:,10);

[data_drifter.Xlon,data_drifter.Ylat]=meshgrid(data_drifter.lon,data_drifter.lat);

%%%%%%%%%  Speed %%%%%%%%%%%% 

%%% deltaX %%% 

for i=1:(length(data_drifter.lat)-1)
    if data_drifter.lon(i+1)<data_drifter.lon(i)
    data_drifter.distanceX(i) = distancelonlat(data_drifter.lat(i),data_drifter.lon(i),data_drifter.lat(i),data_drifter.lon(i+1),Const);
    else
    data_drifter.distanceX(i) = -distancelonlat(data_drifter.lat(i),data_drifter.lon(i),data_drifter.lat(i),data_drifter.lon(i+1),Const);
    end
    if data_drifter.lat(i+1)<data_drifter.lat(i)
       data_drifter.distanceY(i) = distancelonlat(data_drifter.lat(i),data_drifter.lon(i),data_drifter.lat(i+1),data_drifter.lon(i),Const);
    else
       data_drifter.distanceY(i) = -distancelonlat(data_drifter.lat(i),data_drifter.lon(i),data_drifter.lat(i+1),data_drifter.lon(i),Const);
    end
    
%%%  deltaT %%% 

    data_drifter.temps(i) = data_drifter.time(i)-data_drifter.time(i+1);

%%% Speed %%% 

    data_drifter.vitesseU(i) = (data_drifter.distanceX(i)/data_drifter.temps(i))*(Const.km2m/(Const.d2s));
    data_drifter.vitesseV(i) = (data_drifter.distanceY(i)/data_drifter.temps(i))*(Const.km2m/(Const.d2s));
    
    
end
     
data_drifter.name='d';
end