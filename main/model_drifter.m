%% -- MAIN -- %%

%% Initialization
% Cleaning data
clear;clc;close all;

Const.UTC2        = 1/12;      % real time to UTC
Const.R           = 6371;      % earth radius km 
Const.d2s         = 86400;     % day in sec
Const.km2m        = 1000;      % km in m 
Const.d2h         = 24;        % day in hour
Const.w_terre     = (2*pi)/(23*3600+56*60+4.09); % earth angular velocity

% Add data path  Yann 
addpath('..\..\round1','..\..\round2','..\..\NEMO')
drifter.path_drifter = '..\..\round1';
% Add data path Théo
%addpath('../../','../../NEMO','../../WERA','../../drifter/round1','../../drifter/round2');
%drifter.path_drifter = '../../drifter/round1';
% Add data path fonctions
addpath('fonction')

stat.u_mod_alldrift=[];
stat.u_drift_alldrift=[];

% Time Origin
shared.time_origin='2010-01-01 00:00:00';

%% Read data 
name_drifter = dir([drifter.path_drifter '/*.xlsx']); %% files name
for j=1:length(name_drifter)%% loop on all drifters 
   disp(name_drifter(j).name) % to see the steps 
drifter=read_DRIFTER(name_drifter(j).name,Const);
model=read_MODEL('GLAZUR64_20190511_20190524_grid_U.nc','GLAZUR64_20190511_20190524_grid_V.nc',Const);

%% Shared time
shared.time_origin_julien=datenum(shared.time_origin); % time origin in julian calendar 

model.time=model.time+model.time_origin; 
drifter.time=drifter.time+drifter.time_origin; 

[drifter,model,shared]=shared_time(drifter,model,shared); 

%% Shared space
[model,drifter,shared]=shared_space(model,drifter,shared); 

%% Closer point

% Keeping only shared data 
shared.i_shared=drifter.lon>shared.lon_0 & drifter.lon<shared.lon_end & drifter.lat>shared.lat_0 & ...
                drifter.lat<shared.lat_end & drifter.time>shared.time_0 & drifter.time<shared.time_end;

drifter.U=drifter.vitesseU(shared.i_shared);
drifter.V=drifter.vitesseV(shared.i_shared);
drifter.lon=drifter.lon(shared.i_shared);
drifter.lat=drifter.lat(shared.i_shared);
drifter.time=drifter.time(shared.i_shared);
              
[model,drifter,shared] = closer_point(model,drifter,shared,Const);
        
%% Filter spikes
[drifter,model]=filter_spike(drifter,model);

%% Statistics

[stat,shared]=statistic(drifter,model,shared,stat);

%% Display

%% Frequency spectrum
if length(drifter.U)>1
    
    [drifter.f,drifter.P1,drifter.t_inertial]=spectrum_drifter(drifter,model,Const);
   T_inertie_th = (pi/(sind(stat.mean_lat)*Const.w_terre))/3600;
   
    %%%Display frequency spectrum 
    figure()
    plot(drifter.f,drifter.P1)  
    title(strcat('T\_inertie\_exp = ',num2str(drifter.t_inertial),' T\_inertie\_th = ',num2str(T_inertie_th)))
    xlabel('f (Hz)')
    ylabel('|P1(f)|')

    %%% Display speed drifter and model
    figure()
    hold on
    plot(drifter.time_drifter2,drifter.U_filter2,'bo')
    plot(drifter.time_model,model.closer_U_filter,'ro')
    title(strcat('Comparaison model drifter ',name_drifter(j).name(1:3)))
    ylabel('vitesse en m/s')
    datetick('x','mmm-dd-hh','keepticks')
    legend('drifter','model')
    hold off
    pause
end


end

