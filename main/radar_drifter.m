%% -- MAIN -- %%

%% Initialization
% Cleaning data
clear;
close all;

clc;

CONFIG

% Add data path  Yann 
%addpath('..\..\round1','..\..\round2','..\..\WERA')
%drifter.path_drifter = '..\..\round1';
% Add data path Theo
addpath('../../','../../NEMO','../../WERA','../../drifter/round1','../../drifter/round2');
drifter.path_drifter = '../../drifter/round1';
% Add path fonctions
addpath('fonction')

% Time origin
shared.time_origin='2010-01-01 00:00:00';

% Statistics 

stat.vr_rad_alldrift=[];
stat.vr_drift_alldrift=[];


%% Read Data
name_drifter = dir([drifter.path_drifter '/*.xlsx']); %% files name
for j=1:length(name_drifter)%% loop on all drifters 
   disp(name_drifter(j).name) % to see the steps 
drifter=read_DRIFTER(name_drifter(j).name,Const);
%drifter= read_DRIFTER('653.xlsx',Const); % for a precise drifter comment the loop and uncomment this line
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

%% Filter spikes
[drifter,radar]=filter_spike2(drifter,radar);

%% Statistics

[stat,shared]=statistic(drifter,radar,shared,stat);


%% Display
if length(drifter.U)>1 %no error in case of no space and time shared  

    [drifter.f,drifter.P1,drifter.f_inertial]=spectrum_drifter(drifter,radar,Const);
    
    %%%Display frequency spectrum 
    figure()
    plot(drifter.f,drifter.P1) 
    title(strcat('Frequence inertielle = ',num2str(drifter.f_inertial)))
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
%     if drifter.f_inertial > 34 && drifter.f_inertial <35
%        savefig(strcat('Frequence inertielle = ',num2str(name_drifter(j).name(1:3))))
%     end
%     
    
    %%% Display speed drifter and radar
    figure()
    hold on
    plot(drifter.time_drifter2,drifter.Vr_filter2,'bo');
    plot(drifter.time_radar2,radar.closer_Vr_filter2,'rx')
    title(strcat('Comparaison radar drifter ',name_drifter(j).name(1:3)))
    ylabel('vitesse en m/s')
    datetick('x','mmm-dd-hh','keepticks')
    legend('drifter','radar')
    hold off
    pause(1)
%     if drifter.f_inertial > 34 && drifter.f_inertial <35
%        savefig(strcat('Comparaison radar drifter ',name_drifter(j).name(1:3)))
%     end
    
    
end
end 
 


