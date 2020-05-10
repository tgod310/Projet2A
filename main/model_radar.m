%% -- MODEL-RADAR -- %%
% Befor running choose the type of radar and the files you want to compare

%% Configuration by User
% Data cleaning
clear;close all;clc;

% Data choosen by user
type_RADAR='COD'; % Choose the type of Radar between PEY, POB and COD

% PEY
% file_RADAR='PEY_L1_Y2018M02.nc'; % Name of the Radar file

% POB
% file_RADAR='20190300001_20191002301_POB_L1.nc'; % Name of the Radar file

% COD
file_RADAR='Radials_RUV_May19.nc'; % Name of the Radar file

% GLAZUR
file_MODEL_U='GLAZUR64_20190511_20190524_grid_U.nc'; % Name of the model file
file_MODEL_V='GLAZUR64_20190511_20190524_grid_V.nc'; % Name of the model file

% NIDOR
% file_MODEL_U='1_NIDOR_20190511_20190524_grid_U.nc'; % Name of the model file
% file_MODEL_V='1_NIDOR_20190511_20190524_grid_V.nc'; % Name of the model file

% Configuration of constantes
i_Affichage=10; % choose day/hour to display

% Add path of studied data
addpath('../../','../../NEMO','../../WERA');
% Ajout chemin Yann 
%addpath('..\..\NEMO','..\..\WERA');
% Add path of fonction folder
addpath('fonction')

CONFIG_Const; % Use the configuration file for general constants
CONFIG_Radar; % Configuration of Radar constants

%% Get data
radar=read_RADAR(file_RADAR,Const);
model=read_MODEL(file_MODEL_U,file_MODEL_V,Const);

%% Time standardisation
shared.time_origin_julien=datenum(shared.time_origin); % Time origin on Julian calendar
radar.time=radar.time+radar.time_origin-shared.time_origin_julien; % Radar time set on time origin
model.time=model.time+model.time_origin-shared.time_origin_julien; % Model time set on time origin

[model,radar,shared]=shared_time(model,radar,shared); % Get shared time

%% Space standardisation
[radar,model,shared]=shared_space(radar,model,shared); % Get shared space

[model,radar]=interpolation(model,radar,shared); % Space interpolation of model on radar grid and mean time of radar on model grid
model=projection(model,radar); % Space projection of model on radar radial

%% Comparison
shared.difference=(abs(model.Vr)-abs(radar.interp_Vr)).^2/max(abs(model.Vr(:,:,:)),[],'all','omitnan')^2; % calcul de la difference entre radar et model
shared.difference2=abs(model.Vr-radar.interp_Vr);
shared.difference2(shared.difference2>0.2)=NaN; % Suppression des valeurs trop importantes (> 0.2m/s)

% Temporal evolution of difference on a section
Const.size=size(shared.difference);
shared.difference3=NaN(Const.size(2),Const.size(3));
delta_alpha=2; % error intervel for the angle
shared.diff_lat3=shared.lat(radar.angle<=Const.alpha+delta_alpha & radar.angle>=Const.alpha-delta_alpha); % Latitudes of points where we are in the angle interval
shared.diff_lat3=reshape(shared.diff_lat3,[Const.size(2),length(shared.diff_lat3)/Const.size(2)]);
shared.diff_lat3=mean(shared.diff_lat3,2); % Mean of latitudes for each lines
for i=1:Const.size(3) % calcul on each time, same as for the latitudes
    var=shared.difference2(:,:,i);
    var2=var(radar.angle<=Const.alpha+delta_alpha & radar.angle>=Const.alpha-delta_alpha);
    var2=reshape(var2,[Const.size(2),length(var2)/Const.size(2)]);
    shared.difference3(:,i)=mean(var2,2,'omitnan');
end
[shared.T,shared.lat3]=meshgrid(shared.time,shared.diff_lat3); % Creation of the grid for display


%% Display

% Moyenne radar sur le jour
figure(1)
contourf(shared.lon,shared.lat,radar.interp_Vr(:,:,i_Affichage));
colorbar
c=caxis;
title('Moyenne radar par jour')

% Norme du Modele
figure(2)
hold on
contourf(model.lon,model.lat,model.norm(:,:,i_Affichage));
quiver(model.lon,model.lat,model.U(:,:,i_Affichage),model.V(:,:,i_Affichage),'LineWidth',0.75,'AutoScaleFactor',1.5,'Color','r')
hold off
colorbar
caxis(c);
title('Norme du modele')

% Interpolation du modele
figure(3)
hold on
contourf(shared.lon,shared.lat,sqrt(model.interp_U(:,:,i_Affichage).^2+model.interp_V(:,:,i_Affichage).^2))
quiver(shared.lon,shared.lat,model.interp_U(:,:,i_Affichage),model.interp_V(:,:,i_Affichage),'LineWidth',0.75,'AutoScaleFactor',1.5,'Color','r')
hold off
colorbar
caxis(c)
title('Interpolation du modele')

% Projection du modele
figure(4)
contourf(shared.lon,shared.lat,model.Vr(:,:,i_Affichage))
colorbar
caxis(c)
title('Projection du modele')

% Comparaison
figure(5)
contourf(shared.lon,shared.lat,shared.difference(:,:,i_Affichage))
colorbar
title('Comparaison entre radar et model')

figure(6)
contourf(shared.lon,shared.lat,shared.difference2(:,:,i_Affichage))
s=colorbar;
s.Label.String='Vitesse (m\cdot s^{-1})';
title(['Difference radar-modele ' datestr(shared.time(i_Affichage)+shared.time_origin_julien)])

f=figure(7);
f.WindowState='maximized';
for i=2:length(shared.time)-1
    clf    
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
    
    sgtitle([datestr(shared.time(i)+shared.time_origin_julien),' i=',num2str(i)])
    pause();
end

figure()
hold on
contourf(shared.lon,shared.lat,radar.interp_Vr(:,:,i_Affichage))
colorbar
contour(shared.lon,shared.lat,model.Vr(:,:,i_Affichage),'ShowText','on','LineColor','k')
title('Vitesse radar avec contour du modèle')
hold off

figure()
contourf(shared.T+shared.time_origin_julien,shared.lat3,shared.difference3)
title(['Différence entre radar et modèle en fonction du temps sur la radiale ' num2str(Const.alpha) '°'])
s.Label.String='Vitesse (m\cdot s^{-1})';
x_tl=cell(1,Const.size(3));
dat=datestr(shared.T+shared.time_origin_julien);
for i=1:Const.size(3)
    x_tl{i}=dat(i,:);
end
xticklabels(x_tl)
xtickangle(30)
colorbar