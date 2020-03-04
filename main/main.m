%% -- MAIN -- %%

%% Initialisation
% Nettoyage des donnees
clear;close all;clc;

% Ajout du chemin des donnees etudiees
addpath('../../','../../NEMO','../../WERA','../../drifter/round1','../../drifter/round2');
% Ajout du chemin des fonctions
addpath('fonction')

% Origine des temps
shared.time_origin='2010-01-01 00:00:00';

%% Début du programme

% Recuperation des donnees
radar=read_RADAR('20190300001_20191002301_PEY_L1.nc');
model=read_MODEL('1_NIDOR_20190202_20190215_grid_U.nc','1_NIDOR_20190202_20190215_grid_V.nc');
drifter=read_DRIFTER('033.xlsx');


% Uniformisation du temps
shared.time_origin_julien=datenum(shared.time_origin);
radar.time=radar.time+radar.time_origin-shared.time_origin_julien;
model.time=model.time/(60*60*24)+model.time_origin-shared.time_origin_julien;

[model,radar,shared]=shared_time(model,radar,shared);

% Uniformisation de l'espace
[model,radar,shared]=shared_space(model,radar,shared);

[model,radar]=interpolation(model,radar,shared);
[model,radar]=projection(model,radar);

temps=2;

% figure()
% contourf(shared.lon,shared.lat,radar.interp_Vr(:,:,temps));
% colorbar
% c=caxis;
% title('Radar')
% 
% <<<<<<< Updated upstream
% figure()
% contourf(shared.lon,shared.lat,model.Vr(:,:,temps));
% colorbar
% title('Projection du modele')
% caxis(c);
% =======

% 
% figure()
% hold on
% contourf(model.lon,model.lat,model.norm(:,:,temps));
% quiver(model.lon,model.lat,model.U(:,:,temps),model.V(:,:,temps),'LineWidth',0.75,'AutoScaleFactor',1.5,'Color','r')
% hold off
% title('norme du modele')
% c=caxis;
% 
% 
% figure()
% contourf(radar.lon,radar.lat,model.Vr(:,:,temps));
% colorbar
% title('Projection du modele')
% caxis(c);
% >>>>>>> Stashed changes

% figure()
% hold on
% contourf(radar.lon,radar.lat,sqrt(model.interp_U(:,:,temps).^2+model.interp_V(:,:,temps).^2))
% quiver(radar.lon,radar.lat,model.interp_U(:,:,temps),model.interp_V(:,:,temps),'LineWidth',0.75,'AutoScaleFactor',1.5,'Color','r')
% hold off
% title('interpolation du modele')
% caxis(c)


% <<<<<<< Updated upstream
% figure()
% hold on
% contourf(shared.lon,shared.lat,sqrt(model.interp_U(:,:,temps).^2+model.interp_V(:,:,temps).^2))
% quiver(shared.lon,shared.lat,model.interp_U(:,:,temps),model.interp_V(:,:,temps),'LineWidth',0.75,'AutoScaleFactor',1.5,'Color','r')
% hold off
% title('projection du modele')
% caxis(c)
% =======
% >>>>>>> Stashed changes
