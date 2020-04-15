%% -- MAIN -- %%

%% Initialisation
% Nettoyage des donnees
clear;clc;

% Ajout du chemin des donnees etudiees Yann 
%addpath('..\..\round1','..\..\round2','..\..\NEMO')
% Ajout du chemin des donnees etudiees Théo
addpath('../../','../../NEMO','../../WERA','../../drifter/round1','../../drifter/round2');
% Ajout du chemin des fonctions
addpath('fonction')

% Origine des temps
shared.time_origin='2010-01-01 00:00:00';

%% Recuperation des donnees
name_drifter = dir('..\..\round1'); %% nom des fichiers
for j=3:length(name_drifter)%% boucle sur tous les drifters
   name_drifter(j).name %pour voir ou on en est dans le calcul
drifter=read_DRIFTER(name_drifter(j).name);
model=read_MODEL('1_NIDOR_20190511_20190524_grid_U.nc','1_NIDOR_20190511_20190524_grid_V.nc');

%% Uniformisation du temps
shared.time_origin_julien=datenum(shared.time_origin); % origine des temps en calendrier julien

model.time=model.time+model.time_origin-shared.time_origin_julien; % temps model sur origine des temps
drifter.time=drifter.time-shared.time_origin_julien; %temps drifter sur origine des temps

[drifter,model,shared]=shared_time(drifter,model,shared); % recupération des plages temps communes

%% Uniformisation de l'espace
[model,drifter,shared]=shared_space(model,drifter,shared); % recuperation des plages espace communes

%% Recherche du point le plus proche 

% On ne garde que les données drifter qui sont dans les plages communes
m=drifter.lon>shared.lon_0 & drifter.lon<shared.lon_end & drifter.lat>shared.lat_0 & drifter.lat<shared.lat_end & drifter.time>shared.time_0 & drifter.time<shared.time_end;
drifter.U=drifter.vitesseU(m);
drifter.V=drifter.vitesseV(m);
drifter.lon=drifter.lon(m);
drifter.lat=drifter.lat(m);
drifter.time=drifter.time(m);
       
        
[model,drifter,shared] = closer_point(model,drifter,shared);
        
Moyenne_temps= mean(shared.delta_T);
Moyenne_distance=mean(shared.delta_D);

%% Affichage
if length(m)>1
    figure()
    plot(drifter.time,drifter.U,'o')
    title(strcat('drifter ',name_drifter(j).name(1:3),' bleu NIDOR rouge'))
    ylabel('vitesse en m/s')
    str=datestr(drifter.time(1));
    str2=datestr(drifter.time(end));
    xlabel(strcat(str2,' | ',str))
    hold on
    plot(drifter.time,model.closer_U,'ro')
    hold off
    
end
pause
end

