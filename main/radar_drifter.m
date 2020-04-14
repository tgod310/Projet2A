%% -- MAIN -- %%

%% Initialisation
% Nettoyage des donnees
clear;
close all;
clc;

% Ajout du chemin des donnees etudiees
addpath('../../','../../NEMO','../../WERA','../../drifter/round1','../../drifter/round2');
% Ajout du chemin des fonctions
addpath('fonction')

% Origine des temps
shared.time_origin='2010-01-01 00:00:00';

%% Recuperation des donnees
%%%Comparaison drifter model%%%
radar=read_RADAR('Radials_RUV_May19.nc');
drifter=read_DRIFTER('039.xlsx');

%% Uniformisation du temps
shared.time_origin_julien=datenum(shared.time_origin); % origine des temps en calendrier julien
drifter.time=drifter.time+drifter.time_origin-shared.time_origin_julien; % temps drifter sur origine des temps
radar.time=radar.time+radar.time_origin-shared.time_origin_julien; % temps radar sur origine des temps

[radar,drifter,shared]=shared_time(radar,drifter,shared); % recupération des plages temps communes

%% Uniformisation de l'espace
[radar,drifter,shared]=shared_space(radar,drifter,shared); % recuperation des plages espace communes

% On ne garde que les données drifter qui sont dans les plages communes
i_min=drifter.time>=shared.time_0;
i_max=drifter.time<=shared.time_end;
i=drifter.lon>=shared.lon_0 & drifter.lon<=shared.lon_end & drifter.lat>=shared.lat_0 & drifter.lat<=shared.lat_end & drifter.time_min>=shared.time_0 & drifter.time_max<=shared.time_end;
i=logical(i.*i_min.*i_max);
drifter.U=drifter.vitesseU(i);
drifter.V=drifter.vitesseV(i);
drifter.lon=drifter.lon(i);
drifter.lat=drifter.lat(i);
drifter.time=drifter.time(i);

[radar,drifter,shared]=closer_point(radar,drifter,shared);

% Calcul moyenne distance et temps

i_notNaN=not(isnan(shared.delta_Vr));

mean_time=mean(shared.delta_T(i_notNaN));
mean_dist=mean(shared.delta_D(i_notNaN));
mean_U=mean(shared.delta_Vr,'omitnan');

%% Affichage
figure()
hold on
p=plot(drifter.time,drifter.Vr,'r');
plot(drifter.time,radar.closer_Vr,'xb')
title('Comparaison radar drifter')
ylabel('vitesse en m/s')
datetick('x','mmm-dd-hh','keepticks')
legend('drifter','radar')
hold off