%% -- MAIN -- %%

%% Initialization
% Cleaning data
clear;
close all;
clc;

% Constant
Const.UTC2=1/12;
Const.R = 6371; % earth radius km 
Const.d2s = 86400; %day in sec
Const.km2m = 1000; %km in m 
Const.d2h = 24; % day in hour

% Add data path  Yann 
addpath('..\..\round1','..\..\round2','..\..\WERA')
drifter.path_drifter = '..\..\round1';
% Add data path Theo
%addpath('../../','../../NEMO','../../WERA','../../drifter/round1','../../drifter/round2');
%drifter.path_drifter = '../../drifter/round1';
% Add path fonctions
addpath('fonction')

% Time origin
shared.time_origin='2010-01-01 00:00:00';

%% Read Data
name_drifter = dir([drifter.path_drifter '/*.xlsx']); %% files name
for j=1:length(name_drifter)%% loop on all drifters 
   disp(name_drifter(j).name) % to see the steps 
drifter=read_DRIFTER(name_drifter(j).name,Const);
radar=read_RADAR('Radials_RUV_May19.nc',Const);


%% Shared time

shared.time_origin_julien=datenum(shared.time_origin); % time origin in julian calendar
drifter.time=drifter.time+drifter.time_origin-shared.time_origin_julien; 
radar.time=radar.time+radar.time_origin-shared.time_origin_julien; 

[radar,drifter,shared]=shared_time(radar,drifter,shared); 

%% Shared space
[radar,drifter,shared]=shared_space(radar,drifter,shared); 

%% Closer point

% Keeping shared data 
shared.i_min=drifter.time>=shared.time_0;
shared.i_max=drifter.time<=shared.time_end;
shared.i=drifter.lon>=shared.lon_0 & drifter.lon<=shared.lon_end & drifter.lat>=shared.lat_0 & drifter.lat<=shared.lat_end & drifter.time_min>=shared.time_0 & drifter.time_max<=shared.time_end;
shared.i=logical(shared.i.*shared.i_min.*shared.i_max); % Indice of shared data 

drifter.U=drifter.vitesseU(shared.i);
drifter.V=drifter.vitesseV(shared.i);
drifter.lon=drifter.lon(shared.i);
drifter.lat=drifter.lat(shared.i);
drifter.time=drifter.time(shared.i);


[radar,drifter,shared]=closer_point(radar,drifter,shared,Const); % searching for closer point

% Means
shared.i_notNaN=not(isnan(shared.delta_Vr));

shared.mean_time=mean(shared.delta_T(shared.i_notNaN));
shared.mean_dist=mean(shared.delta_D(shared.i_notNaN));
shared.mean_delta_U=mean(shared.delta_Vr,'omitnan');

%% Display
if length(shared.i)>1 %no error in case of no space and time shared  

    figure()
    hold on
    plot(drifter.time,drifter.Vr,'r');
    plot(drifter.time,radar.closer_Vr,'xb')
    title(strcat('Comparaison radar drifter ',name_drifter(j).name(1:3)))
    ylabel('vitesse en m/s')
    datetick('x','mmm-dd-hh','keepticks')
    legend('drifter','radar')
    hold off
    pause 
end
end 



