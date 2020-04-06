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

%% Recuperation des donnees
%%%Comparaison radar model%%%
radar=read_RADAR('20190300001_20191002301_PEY_L1.nc');
model=read_MODEL('1_NIDOR_20190202_20190215_grid_U.nc','1_NIDOR_20190202_20190215_grid_V.nc');

%%%Comparaison drifter model%%%
%drifter=read_DRIFTER('033.xlsx');
%model=read_MODEL('1_NIDOR_20190511_20190524_grid_U.nc','1_NIDOR_20190511_20190524_grid_V.nc');

%% Uniformisation du temps
shared.time_origin_julien=datenum(shared.time_origin); % origine des temps en calendrier julien
radar.time=radar.time+radar.time_origin-shared.time_origin_julien; % temps radar sur origine des temps
model.time=model.time/(60*60*24)+model.time_origin-shared.time_origin_julien; % temps model sur origine des temps
%drifter.time=drifter.time-shared.time_origin_julien; %temps drifter sur origine des temps

[model,radar,shared]=shared_time(model,radar,shared); % recupération des plages temps communes

%% Uniformisation de l'espace
[model,radar,shared]=shared_space(model,radar,shared); % recuperation des plages espace communes

[model,radar]=interpolation(model,radar,shared); % interpolation model sur espace et moyenne radar sur temps
[model,radar]=projection(model,radar); % projection model sur radiale du radar


%% Affichage
jour=1; % choix du jour a afficher

% Moyenne radar sur le jour
figure()
contourf(shared.lon,shared.lat,radar.interp_Vr(:,:,jour));
colorbar
c=caxis;
title('Moyenne radar par jour')

% Norme du Modele
figure()
hold on
contourf(model.lon,model.lat,model.norm(:,:,jour));
quiver(model.lon,model.lat,model.U(:,:,jour),model.V(:,:,jour),'LineWidth',0.75,'AutoScaleFactor',1.5,'Color','r')
hold off
colorbar
caxis(c);
title('Norme du modele')

% Interpolation du modele
figure()
hold on
contourf(shared.lon,shared.lat,sqrt(model.interp_U(:,:,jour).^2+model.interp_V(:,:,jour).^2))
quiver(shared.lon,shared.lat,model.interp_U(:,:,jour),model.interp_V(:,:,jour),'LineWidth',0.75,'AutoScaleFactor',1.5,'Color','r')
hold off
colorbar
caxis(c)
title('Interpolation du modele')

% Projection du modele
figure()
hold on
contourf(shared.lon,shared.lat,model.Vr(:,:,jour))
hold off
colorbar
caxis(c)
title('Projection du modele')

%% Comparaison
shared.difference=(abs(model.Vr)-abs(radar.interp_Vr)).^2/max(abs(model.Vr(:,:,:)),[],'all','omitnan')^2; % calcul de la difference entre radar et model

figure()
contourf(shared.lon,shared.lat,shared.difference(:,:,jour))
colorbar
title('Comparaison entre radar et model')