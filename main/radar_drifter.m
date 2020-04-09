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
drifter=read_DRIFTER('033.xlsx');
model=read_MODEL('1_NIDOR_20190511_20190524_grid_U.nc','1_NIDOR_20190511_20190524_grid_V.nc');

%% Uniformisation du temps
shared.time_origin_julien=datenum(shared.time_origin); % origine des temps en calendrier julien
drifter.time=drifter.time+drifter.time_origin-shared.time_origin_julien; % temps drifter sur origine des temps
model.time=model.time/(60*60*24)+model.time_origin-shared.time_origin_julien; % temps model sur origine des temps

[model,drifter,shared]=shared_time(model,drifter,shared); % recupération des plages temps communes

%% Uniformisation de l'espace
[model,drifter,shared]=shared_space(model,drifter,shared); % recuperation des plages espace communes

[model,drifter]=interpolation(model,drifter,shared); % interpolation model sur espace et moyenne radar sur temps
[model,drifter]=projection(model,drifter); % projection model sur radiale du radar

%% Comparaison
shared.difference=(abs(model.Vr)-abs(drifter.interp_Vr)).^2/max(abs(model.Vr(:,:,:)),[],'all','omitnan')^2; % calcul de la difference entre radar et model
shared.difference2=abs(abs(model.Vr)-abs(drifter.interp_Vr));
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
contourf(model.lon,model.lat,model.norm(:,:,jour));
quiver(model.lon,model.lat,model.U(:,:,jour),model.V(:,:,jour),'LineWidth',0.75,'AutoScaleFactor',1.5,'Color','r')
hold off
colorbar
caxis(c);
title('Norme du modele')

% Interpolation du modele
figure(3)
hold on
contourf(shared.lon,shared.lat,sqrt(model.interp_U(:,:,jour).^2+model.interp_V(:,:,jour).^2))
quiver(shared.lon,shared.lat,model.interp_U(:,:,jour),model.interp_V(:,:,jour),'LineWidth',0.75,'AutoScaleFactor',1.5,'Color','r')
hold off
colorbar
caxis(c)
title('Interpolation du modele')

% Projection du modele
figure(4)
contourf(shared.lon,shared.lat,model.Vr(:,:,jour))
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
    contourf(shared.lon,shared.lat,model.Vr(:,:,i))
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
