%% -- MAIN -- %%

%% Initialisation
% Nettoyage des donnees
clear;close all;clc;

% Ajout du chemin des donnees etudiees
addpath('../../','../../NEMO','../../WERA','../../drifter/round1','../../drifter/round2');
% Ajout du chemin des fonctions
addpath('fonction')

% Origine des temps
time_origin='2010-01-01 00:00:00';

%% Début du programme

% Recuperation des donnees
radar=read_RADAR('20190300001_20191002301_PEY_L1.nc');
model=read_MODEL('1_NIDOR_20190202_20190215_grid_U.nc','1_NIDOR_20190202_20190215_grid_V.nc');

% Uniformisation du temps
time_origin=datenum(time_origin);
radar.time=radar.time+radar.time_origin-time_origin;
model.time=model.time/(60*60*24)+model.time_origin-time_origin;

% Recuperation des plages de donnees commune dans le temps
radar.time_min=min(radar.time);
radar.time_max=max(radar.time);
radar.time_step=(radar.time_max-radar.time_min)/length(radar.time);
model.time_min=min(model.time);
model.time_max=max(model.time);
model.time_step=(model.time_max-model.time_min)/length(model.time);

if radar.time_min > model.time_max || radar.time_max < model.time_min
    error("Les donnees a comparer n'ont pas de plages de donnees communes");
elseif radar.time_max > model.time_min
    time_0=model.time_min;
    time_end=min(model.time_max,radar.time_max);
elseif radar.time_min < model.time_max
    time_0=radar.time_min;
    time_end=min(model.time_max,radar.time_max);
end

[model,radar]=interpolation(model,radar);
[model,radar]=projection(model,radar);

figure()
contourf(radar.lon,radar.lat,radar.Vr(:,:,1));
colorbar
c=caxis;
figure()
contourf(radar.lon,radar.lat,model.Vr(:,:,1));
colorbar
caxis(c);
