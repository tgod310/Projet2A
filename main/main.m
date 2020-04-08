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
data1=read_RADAR('20190300001_20191002301_PEY_L1.nc');
datd2=read_MODEL('1_NIDOR_20190202_20190215_grid_U.nc','1_NIDOR_20190202_20190215_grid_V.nc');

%%%Comparaison drifter model%%%
%drifter=read_DRIFTER('033.xlsx');
%model=read_MODEL('1_NIDOR_20190511_20190524_grid_U.nc','1_NIDOR_20190511_20190524_grid_V.nc');

%% Uniformisation du temps
shared.time_origin_julien=datenum(shared.time_origin); % origine des temps en calendrier julien
data1.time=data1.time+data1.time_origin-shared.time_origin_julien; % temps radar sur origine des temps
datd2.time=datd2.time/(60*60*24)+datd2.time_origin-shared.time_origin_julien; % temps model sur origine des temps
%drifter.time=drifter.time-shared.time_origin_julien; %temps drifter sur origine des temps

[datd2,data1,shared]=shared_time(datd2,data1,shared); % recupération des plages temps communes

%% Uniformisation de l'espace
[datd2,data1,shared]=shared_space(datd2,data1,shared); % recuperation des plages espace communes

[datd2,data1]=interpolation(datd2,data1,shared); % interpolation model sur espace et moyenne radar sur temps
[datd2,data1]=projection(datd2,data1); % projection model sur radiale du radar


%% Affichage
jour=1; % choix du jour a afficher

% Moyenne radar sur le jour
figure()
contourf(shared.lon,shared.lat,data1.interp_Vr(:,:,jour));
colorbar
c=caxis;
title('Moyenne radar par jour')

% Norme du Modele
figure()
hold on
contourf(datd2.lon,datd2.lat,datd2.norm(:,:,jour));
quiver(datd2.lon,datd2.lat,datd2.U(:,:,jour),datd2.V(:,:,jour),'LineWidth',0.75,'AutoScaleFactor',1.5,'Color','r')
hold off
colorbar
caxis(c);
title('Norme du modele')

% Interpolation du modele
figure()
hold on
contourf(shared.lon,shared.lat,sqrt(datd2.interp_U(:,:,jour).^2+datd2.interp_V(:,:,jour).^2))
quiver(shared.lon,shared.lat,datd2.interp_U(:,:,jour),datd2.interp_V(:,:,jour),'LineWidth',0.75,'AutoScaleFactor',1.5,'Color','r')
hold off
colorbar
caxis(c)
title('Interpolation du modele')

% Projection du modele
figure()
hold on
contourf(shared.lon,shared.lat,datd2.Vr(:,:,jour))
hold off
colorbar
caxis(c)
title('Projection du modele')

%% Comparaison
shared.difference=(abs(datd2.Vr)-abs(data1.interp_Vr)).^2/max(abs(datd2.Vr(:,:,:)),[],'all','omitnan')^2; % calcul de la difference entre radar et model
shared.difference2=abs(abs(datd2.Vr)-abs(data1.interp_Vr));

figure()
contourf(shared.lon,shared.lat,shared.difference(:,:,jour))
colorbar
title('Comparaison entre radar et model')

figure()
contourf(shared.lon,shared.lat,shared.difference2(:,:,jour))
colorbar
title('Difference radar-modele')

%% Test git kraken

