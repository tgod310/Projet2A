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
%%%Comparaison drifter model%%%
radar=read_RADAR('Radials_RUV_May19.nc');
drifter=read_DRIFTER('033.xlsx');

%% Uniformisation du temps
shared.time_origin_julien=datenum(shared.time_origin); % origine des temps en calendrier julien
drifter.time=drifter.time+drifter.time_origin-shared.time_origin_julien; % temps drifter sur origine des temps
radar.time=radar.time+radar.time_origin-shared.time_origin_julien; % temps radar sur origine des temps

[radar,drifter,shared]=shared_time(radar,drifter,shared); % recupération des plages temps communes

%% Uniformisation de l'espace
[radar,drifter,shared]=shared_space(radar,drifter,shared); % recuperation des plages espace communes

[radar,drifter]=interpolation(radar,drifter,shared); % interpolation model sur espace et moyenne radar sur temps
[radar,drifter]=projection(radar,drifter); % projection model sur radiale du radar

%% Comparaison
shared.difference=(abs(radar.Vr)-abs(drifter.interp_Vr)).^2/max(abs(radar.Vr(:,:,:)),[],'all','omitnan')^2; % calcul de la difference entre radar et model
shared.difference2=abs(abs(radar.Vr)-abs(drifter.interp_Vr));
shared.difference2(shared.difference2>0.2)=NaN; % Suppression des valeurs trop importantes (> 0.2m/s)

%% Affichage
jour=1; % choix du jour a afficher

% Moyenne radar sur le jour
figure(1)
contourf(shared.lon,shared.lat,drifter.interp_Vr(:,:,jour));
colorbar
c=caxis;
title('Moyenne radar par jour')

% Norme du Modele
figure(2)
hold on
contourf(radar.lon,radar.lat,radar.norm(:,:,jour));
quiver(radar.lon,radar.lat,radar.U(:,:,jour),radar.V(:,:,jour),'LineWidth',0.75,'AutoScaleFactor',1.5,'Color','r')
hold off
colorbar
caxis(c);
title('Norme du modele')

% Interpolation du modele
figure(3)
hold on
contourf(shared.lon,shared.lat,sqrt(radar.interp_U(:,:,jour).^2+radar.interp_V(:,:,jour).^2))
quiver(shared.lon,shared.lat,radar.interp_U(:,:,jour),radar.interp_V(:,:,jour),'LineWidth',0.75,'AutoScaleFactor',1.5,'Color','r')
hold off
colorbar
caxis(c)
title('Interpolation du modele')

% Projection du modele
figure(4)
contourf(shared.lon,shared.lat,radar.Vr(:,:,jour))
colorbar
caxis(c)
title('Projection du modele')

% Comparaison
figure(5)
contourf(shared.lon,shared.lat,shared.difference(:,:,jour))
colorbar
title('Comparaison entre radar et model')

figure(6)
contourf(shared.lon,shared.lat,shared.difference2(:,:,jour))
s=colorbar;
s.Label.String='Vitesse (m\cdot s^{-1})';
title(['Difference radar-modele ' datestr(shared.time(jour)+shared.time_origin_julien)])

for i=1:length(shared.time)
    f=figure(7);
    f.WindowState='maximized';
    subplot(2,2,1)
    contourf(shared.lon,shared.lat,drifter.interp_Vr(:,:,i));
    s=colorbar;
    c=caxis;
    s.Label.String='Vitesse radiale (m\cdot s^{-1})';
    title('Moyenne journaliere radar')
    
    subplot(2,2,2)
    contourf(shared.lon,shared.lat,radar.Vr(:,:,i))
    s=colorbar;
    caxis(c)
    s.Label.String='Vitesse radiale (m\cdot s^{-1})';
    title('Projection modele')
    
    subplot(2,2,3)
    contourf(shared.lon,shared.lat,shared.difference(:,:,i))
    s=colorbar;
    s.Label.String='Sans unitees';
    title('Comparaison radar-model')
    
    subplot(2,2,4)
    contourf(shared.lon,shared.lat,shared.difference2(:,:,i))
    s=colorbar;
    s.Label.String='Vitesse (m\cdot s^{-1})';
    title('Difference radar-modele')
    
    sgtitle(datestr(shared.time(i)+shared.time_origin_julien))
    pause(2);
end
