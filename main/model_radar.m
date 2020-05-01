%% -- MODEL-RADAR -- %%

% Befor running choose the type of radar and the files you want to compare

%% Initialisation
% Data cleaning
clear;close all;clc;

% Data choosen by user
type_RADAR='COD'; % Choose the type of Radar between PEY, POB and COD

% PEY
%file_RADAR='20190300001_20191002301_PEY_L1.nc'; % Name of the Radar file

% POB
%file_RADAR='20190300001_20191002301_POB_L1.nc'; % Name of the Radar file

% COD
file_RADAR='Radials_RUV_May19.nc'; % Name of the Radar file

% GLAZUR
file_MODEL_U='GLAZUR64_20190511_20190524_grid_U.nc'; % Name of the model file
file_MODEL_V='GLAZUR64_20190511_20190524_grid_V.nc'; % Name of the model file

% NIDOR
%file_MODEL_U='1_NIDOR_20190202_20190215_grid_U.nc'; % Name of the model file
%file_MODEL_V='1_NIDOR_20190202_20190215_grid_V.nc'; % Name of the model file

% Configuration of constantes
CONFIG % Use the configuration file

% Add path of studied data
addpath('../../','../../NEMO','../../WERA','../../drifter/round1','../../drifter/round2');
% Ajout chemin Yann 
%addpath('..\..\NEMO','..\..\WERA');
% Add path of fonction folder
addpath('fonction')

% Set time origin
shared.time_origin='2010-01-01 00:00:00';

%% Get data
radar=read_RADAR(file_RADAR,Const);
model=read_MODEL(file_MODEL_U,file_MODEL_V,Const);

%% Time standardisation
shared.time_origin_julien=datenum(shared.time_origin); % Time origin on Julian calendar
radar.time=radar.time+radar.time_origin-shared.time_origin_julien; % Radar time set on time origin
model.time=model.time+model.time_origin-shared.time_origin_julien; % Model time set on time origin

[model,radar,shared]=shared_time(model,radar,shared); % Get shared time

%% Time standardisation
[radar,model,shared]=shared_space(radar,model,shared); % Get shared space

[model,radar]=interpolation(model,radar,shared); % Space interpolation of model on radar grid and mean time of radar on model grid
model=projection(model,radar); % Space projection of model on radar radial

%% Comparison
shared.difference=(abs(model.Vr)-abs(radar.interp_Vr)).^2/max(abs(model.Vr(:,:,:)),[],'all','omitnan')^2; % calcul de la difference entre radar et model
shared.difference2=abs(abs(model.Vr)-abs(radar.interp_Vr));
shared.difference2(shared.difference2>0.2)=NaN; % Suppression des valeurs trop importantes (> 0.2m/s)

%% Display
jour=10; % choix du jour a afficher

% Moyenne radar sur le jour
figure(1)
contourf(shared.lon,shared.lat,radar.interp_Vr(:,:,jour));
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

for i=2:length(shared.time)-1
    f=figure(7);
    f.WindowState='maximized';
    
    subplot(2,2,1)
    hold on
    contourf(shared.lon,shared.lat,radar.interp_Vr(:,:,i));
    contour(shared.lon,shared.lat,model.Vr(:,:,i),'ShowText','on','LineColor','k','LineWidth',2)
    s=colorbar;
    c=caxis;
    s.Label.String='Vitesse radiale (m\cdot s^{-1})';
    title('Moyenne journaliere radar')
    hold off
    
    subplot(2,2,2)
    hold on
    contourf(shared.lon,shared.lat,model.Vr(:,:,i))
    contour(shared.lon,shared.lat,radar.interp_Vr(:,:,i),'ShowText','on','LineColor','k','LineWidth',2)
    s=colorbar;
    caxis(c)
    s.Label.String='Vitesse radiale (m\cdot s^{-1})';
    title('Projection modele')
    hold off
    
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
    pause(0.5);
end

figure()
hold on
contourf(shared.lon,shared.lat,radar.interp_Vr(:,:,jour))
colorbar
contour(shared.lon,shared.lat,model.Vr(:,:,jour),'ShowText','on','LineColor','k')
hold off