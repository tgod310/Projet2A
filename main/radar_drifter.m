%% -- MAIN -- %%

%% Initialization
% Cleaning data
clear;
close all;

clc;
% Data choosen by user
type_RADAR='COD'; % Choose the type of Radar between PEY, POB and COD

% PEY
%file_RADAR='20190300001_20191002301_PEY_L1.nc'; % Name of the Radar file

% POB
%file_RADAR='20190300001_20191002301_POB_L1.nc'; % Name of the Radar file

% COD
file_RADAR='Radials_RUV_May19.nc'; % Name of the Radar file
CONFIG

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

% Statistics 

stat.vr_rad_alldrift=[];
stat.vr_drift_alldrift=[];


%% Read Data
name_drifter = dir([drifter.path_drifter '/*.xlsx']); %% files name
for j=1:length(name_drifter)%% loop on all drifters 
   disp(name_drifter(j).name) % to see the steps 

%% Get Data
drifter=read_DRIFTER(name_drifter(j).name,Const);
%drifter= read_DRIFTER('653.xlsx',Const); % for a precise drifter comment the loop and uncomment this line
radar=read_RADAR(file_RADAR,Const);


%% Shared time

shared.time_origin_julien=datenum(shared.time_origin); % time origin in julian calendar
drifter.time=drifter.time+drifter.time_origin; 
radar.time=radar.time+radar.time_origin; 

[radar,drifter,shared]=shared_time(radar,drifter,shared); 

%% Shared space
[radar,drifter,shared]=shared_space(radar,drifter,shared); 

%% Closer point

% Keeping shared data 
shared.i_min=drifter.time>=shared.time_0;
shared.i_max=drifter.time<=shared.time_end;
shared.i=drifter.lon>=shared.lon_0 & drifter.lon<=shared.lon_end & drifter.lat>=shared.lat_0 & drifter.lat<=shared.lat_end & drifter.time_min>=shared.time_0 & drifter.time_max<=shared.time_end;
shared.i=logical(shared.i.*shared.i_min.*shared.i_max); % Indice of shared data 


drifter.time_tout=drifter.time;
drifter.U=drifter.vitesseU(shared.i);
drifter.V=drifter.vitesseV(shared.i);
drifter.lon=drifter.lon(shared.i);
drifter.lat=drifter.lat(shared.i);
drifter.time=drifter.time(shared.i);



[radar,drifter,shared]=closer_point(radar,drifter,shared,Const); % searching for closer point

%% Filter spikes
[drifter,radar]=filter_spike(drifter,radar);

%% Statistics

[stat,shared]=statistic(drifter,radar,shared,stat);


%% Display
if length(drifter.U)>1 %no error in case of no space and time shared  

    [drifter.f,drifter.P1,drifter.t_inertial]=spectrum_drifter(drifter,radar,Const);
    T_inertie_th = (pi/(sind(stat.mean_lat)*Const.w_terre))/3600;
    
    %%%Display frequency spectrum 
    figure()
    plot(drifter.f,drifter.P1) 
    title(strcat('T\_inertie\_exp = ',num2str(drifter.t_inertial),' T\_inertie\_th = ',num2str(T_inertie_th)))
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
    
%     if drifter.f_inertial > 34 && drifter.f_inertial <35
%        savefig(strcat('Frequence inertielle = ',num2str(name_drifter(j).name(1:3))))
%     end
%     
    
    %% Display speed drifter and radar
    figure()
    hold on
    plot(drifter.time_drifter2,drifter.Vr_filter2,'bo');
    plot(drifter.time_radar2,radar.closer_Vr_filter2,'rx')
    title(strcat('Comparaison radar drifter ',name_drifter(j).name(1:3)))
    ylabel('vitesse en m/s')
    datetick('x','mmm-dd-hh','keepticks')
    legend('drifter','radar')
    hold off
    
%     if drifter.f_inertial > 34 && drifter.f_inertial <35
%        savefig(strcat('Comparaison radar drifter ',name_drifter(j).name(1:3)))
%     end
     figure()
    plot(drifter.time,shared.delta_Vr,'b');
    title(strcat('Comparaison radar drifter ',name_drifter(j).name(1:3)))
    ylabel('erreur')
    datetick('x','mmm-dd-hh','keepticks')
    xlabel(strcat('moyenne\_diff = ',num2str(stat.mean_delta_U),' rms = ',num2str(stat.indiv.rms),' corr = ',num2str(stat.indiv.corr)))
    pause(1)
    
end
end 
 


