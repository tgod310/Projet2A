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
    error("Les donnees a comparer n'ont pas de temps communes");
elseif radar.time_max > model.time_min
    time_0=model.time_min;
    time_end=min(model.time_max,radar.time_max);
elseif radar.time_min < model.time_max
    time_0=radar.time_min;
    time_end=min(model.time_max,radar.time_max);
end

% Recuperation des plages de donnees commune dans l'espace
radar.lat_min=min(min(radar.lat));
radar.lat_max=max(max(radar.lat));
radar.lon_min=min(min(radar.lon));
radar.lon_max=max(max(radar.lon));
model.lat_min=min(min(model.lat));
model.lat_max=max(max(model.lat));
model.lon_min=min(min(model.lon));
model.lon_max=max(max(model.lon));

if radar.lat_min > model.lat_max || radar.lat_max < model.lat_min
    error("Les donnees a comparer n'ont pas de latitudes communes");
elseif radar.lat_max > model.lat_min
    lat_0=model.lat_min;
    lat_end=min(model.lat_max,radar.lat_max);
elseif radar.lat_min < model.lat_max
    lat_0=radar.lat_min;
    lat_end=min(model.lat_max,radar.lat_max);
end

if radar.lon_min > model.lon_max || radar.lon_max < model.lon_min
    error("Les donnees a comparer n'ont pas de longitudes communes");
elseif radar.lon_max > model.lon_min
    lon_0=model.lon_min;
    lon_end=min(model.lon_max,radar.lon_max);
elseif radar.lon_min < model.lon_max
    lon_0=radar.lon_min;
    lon_end=min(model.lon_max,radar.lon_max);
end

%% A modifier, ne fonctionne pas, but : garder que les lat et lon qui sont dans la zone commune de l'espace
i_lat=find(radar.lat<lat_0 | radar.lat>lat_end);
i_lon=find(radar.lon<lon_0 | radar.lon>lon_end);

radar.lat(i_lat)=NaN;
radar.lon(i_lon)=NaN;
radar.Vr(i_lat)=NaN;
radar.Vr(i_lon)=NaN;

[model,radar]=interpolation(model,radar);
[model,radar]=projection(model,radar);

temps=1;

figure()
contourf(radar.lon,radar.lat,radar.Vr(:,:,temps));
colorbar
c=caxis;
title('Radar')

figure()
contourf(radar.lon,radar.lat,model.Vr(:,:,temps));
colorbar
title('Projection du modele')
caxis(c);

figure()
hold on
contourf(model.lon,model.lat,model.norm(:,:,temps));
quiver(model.lon,model.lat,model.U(:,:,temps),model.V(:,:,temps),'LineWidth',0.75,'AutoScaleFactor',1.5,'Color','r')
hold off
colorbar
title('Norme du modele')
caxis(c);

figure()
hold on
contourf(radar.lon,radar.lat,sqrt(model.interp_U(:,:,temps).^2+model.interp_V(:,:,temps).^2))
quiver(radar.lon,radar.lat,model.interp_U(:,:,temps),model.interp_V(:,:,temps),'LineWidth',0.75,'AutoScaleFactor',1.5,'Color','r')
hold off
