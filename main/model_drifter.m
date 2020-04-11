%% -- MAIN -- %%

%% Initialisation
% Nettoyage des donnees
clear;close all;clc;

% Ajout du chemin des donnees etudiees Yann 
addpath('..\..\round1','..\..\round2','..\..\NEMO')
% Ajout du chemin des donnees etudiees Théo
%addpath('../../','../../NEMO','../../WERA','../../drifter/round1','../../drifter/round2');
% Ajout du chemin des fonctions
addpath('fonction')

% Origine des temps
shared.time_origin='2010-01-01 00:00:00';

%% Recuperation des donnees

drifter=read_DRIFTER('033.xlsx');
model=read_MODEL('1_NIDOR_20190511_20190524_grid_U.nc','1_NIDOR_20190511_20190524_grid_V.nc');

%% Uniformisation du temps
shared.time_origin_julien=datenum(shared.time_origin); % origine des temps en calendrier julien

model.time=model.time/(60*60*24)+model.time_origin-shared.time_origin_julien; % temps model sur origine des temps
drifter.time=drifter.time-shared.time_origin_julien; %temps drifter sur origine des temps

[model,drifter,shared]=shared_time_model_drifter(model,drifter,shared); % recupération des plages temps communes

%% Uniformisation de l'espace
[model,drifter,shared]=shared_space_model_drifter(model,drifter,shared); % recuperation des plages espace communes

%% Recherche du point le plus proche 

%1)on prend le point du drifter
%2)on regarde quel point est le plus proche 
%%liste des drifters qui sont dans le shared 
dist_min=zeros(1,length(drifter.lat));
diff_distance=zeros(1,length(drifter.lat));
diff_temps=zeros(1,length(drifter.lat));
model_vitesseU=zeros(1,length(drifter.lat));
model_vitesseV=zeros(1,length(drifter.lat));
diff_vitesseU=zeros(1,length(drifter.lat));



for i=1:length(drifter.lat) 
%Si le drifter est dans l'espace partagé
   if drifter.lat(i)>shared.lat_0 && drifter.lat(i)<shared.lat_end && drifter.lon(i)>shared.lon_0 && drifter.lon(i)<shared.lon_end 
       %Si le drifter est dans le temps partagé
       if drifter.time(i)>shared.time_0 && drifter.time(i)<shared.time_end
       
       %On calcule sa distance avec tous les points partagés du model 
       dist=distancelonlat(drifter.lat(i),drifter.lon(i),shared.lat,shared.lon);
       
        %I la longitude du point le plus proche J la latitude
        diff_distance(i)=min(min(dist));
        [I,J]=find(dist==min(min(dist)));
       
        %On prend le meme jour
        
            diff_temps(i)=100; 
            for k=1:length(model.time)
                 b=abs(drifter.time(i)-model.time(k));
                    if b<diff_temps(i) 
                     diff_temps(i)=b;
                     c=k;
                    end
   
            end
        model_vitesseU(i)=model.U(I,J,1,c);%le model commence le 9 mai avec une donnee par jour
        model_vitesseV(i)=model.V(I,J,1,c);
        
        diff_vitesseU(i)=abs(model_vitesseU(i)-drifter.vitesseU(i));
        end
    end
end

%% Affichage
%plot(drifter.vitesseU,'-o')
%plot(model.U(91,11,1,:)