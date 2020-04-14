%% -- MAIN -- %%

%% Initialisation
% Nettoyage des donnees
clear;clc;

% Ajout du chemin des donnees etudiees Yann 
addpath('..\..\round1','..\..\round2','..\..\NEMO')
% Ajout du chemin des donnees etudiees Théo
%addpath('../../','../../NEMO','../../WERA','../../drifter/round1','../../drifter/round2');
% Ajout du chemin des fonctions
addpath('fonction')

% Origine des temps
shared.time_origin='2010-01-01 00:00:00';

%% Recuperation des donnees
name_drifter = dir('..\..\round1');
for j=3:length(name_drifter)
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
s=length(drifter.lat);
dist_min=zeros(1,s);
diff_distance=zeros(1,s);
diff_temps=zeros(1,s);
model_vitesseU=zeros(1,s);
model_vitesseV=zeros(1,s);
diff_vitesseU=zeros(1,s);
diff_vitesseV=zeros(1,s);

T=[];
for i=1:length(drifter.lat) 
%Si le drifter est dans l'espace partagé
   if drifter.lat(i)>shared.lat_0 && drifter.lat(i)<shared.lat_end && drifter.lon(i)>shared.lon_0 && drifter.lon(i)<shared.lon_end 
       %Si le drifter est dans le temps partagé
       if drifter.time(i)>shared.time_0 && drifter.time(i)<shared.time_end
       T=[T i];
       %On calcule sa distance avec tous les points partagés du model 
       dist=distancelonlat(drifter.lat(i),drifter.lon(i),shared.lat,shared.lon);
       
        %I la longitude du point le plus proche J la latitude
        diff_distance(i)=min(min(dist));
        [I,J]=find(dist==min(min(dist)));
        I=I(1);
        J=J(1);
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
        diff_vitesseV(i)=abs(model_vitesseV(i)-drifter.vitesseV(i));
        
        end
    end
end
%Calcul moyenne distance et temps
e=0;
for i=1:length(diff_distance)
    if  ne(diff_distance(i),0)== 1 && isnan(diff_vitesseU(i))==0 %si c'est un nombre différent de 0 
        e=e+1;
        diff_distance_1(e)=diff_distance(i);
        diff_temps_1(e)=diff_temps(i);
        diff_vitesseU_1(e)=diff_vitesseU(i);
        diff_vitesseV_1(e)=diff_vitesseV(i);
    end
    
end
Moyenne_temps= mean(diff_temps_1);
Moyenne_distance=mean(diff_distance_1);
Moyenne_vitesseU=mean(diff_vitesseU_1);
Moyenne_vitesseV=mean(diff_vitesseV_1);
%% Affichage
if length(T)>1
    plot(drifter.time(T(1):T(end)),drifter.vitesseU(T(1):T(end)),'o')
    title(strcat('drifter ',name_drifter(j).name(1:3),' bleu NIDOR rouge'))
    ylabel('vitesse en m/s')
    str=datestr(drifter.time(T(1)));
    str2=datestr(drifter.time(T(end)));
    xlabel(strcat(str2,' | ',str))
    hold on
    plot(drifter.time(T(1):T(end)),model_vitesseU(T(1):T(end)),'ro')
    hold off
    %savefig(strcat(name_drifter(j).name(1:3),'.fig'))
   
end
[model2,drifter2,shared2] = closer_point(model,drifter,shared);
pause
end

