function data_drifter = read_DRIFTER(name_file)
% read_DRIFTER permet de lire et ouvrir les fichiers xlsx des drifters
%donne la référence, le jour, la position et la vitesse du drifter 
%% Lecture des données
dd = readmatrix(name_file);

%% Variable du numéro du drifter
ds=datastore(name_file);
dv=read(ds);
reference = dv(1,1);
data_drifter.ref = reference;

%% Variable de la date du drifter en jour julien
jour = num2str(dd(:,3));
mois = num2str(dd(:,2));
annee = num2str(dd(:,4));
heure = num2str(dd(:,5));
minute = num2str(dd(:,6));
sec  = num2str(dd(:,7));

DateString=strcat(annee,{'-'},mois,{'-'},jour,{' '},heure,{':'},minute,{':'},sec);
formatIn = 'yyyy-mm-dd HH:MM:SS'; 

data_drifter.time = datenum(DateString,formatIn);
data_drifter.time_origin=0;

%%% Erreurs de mesures 
%%% Si 2 mesures sont prises dans un intervalle inférieur à 10 secondes on
%%% en enleve une

i=1;
while i<length(data_drifter.time)
    if (data_drifter.time(i)-data_drifter.time(i+1)<(10/86400))
        data_drifter.time(i)=NaN;
    end
    i=i+1;
end

%% Variables de la position du drifter
data_drifter.lat = dd(:,9);
data_drifter.lon = dd(:,10);

[data_drifter.Xlon,data_drifter.Ylat]=meshgrid(data_drifter.lon,data_drifter.lat);

%%%%%%%%%  Calcul vitesse %%%%%%%%%%%% 

%%% Calcul deltaX %%% 
%%Formule de Haversine%%

for i=1:(length(data_drifter.lat)-1)
    if data_drifter.lon(i+1)<data_drifter.lon(i)
    data_drifter.distanceX(i) = distancelonlat(data_drifter.lat(i),data_drifter.lon(i),data_drifter.lat(i),data_drifter.lon(i+1));
    else
    data_drifter.distanceX(i) = -distancelonlat(data_drifter.lat(i),data_drifter.lon(i),data_drifter.lat(i),data_drifter.lon(i+1));
    end
    if data_drifter.lat(i+1)<data_drifter.lat(i)
       data_drifter.distanceY(i) = distancelonlat(data_drifter.lat(i),data_drifter.lon(i),data_drifter.lat(i+1),data_drifter.lon(i));
    else
       data_drifter.distanceY(i) = -distancelonlat(data_drifter.lat(i),data_drifter.lon(i),data_drifter.lat(i+1),data_drifter.lon(i));
    end
    
%%%  Calcul deltaT %%% 

    data_drifter.temps(i) = data_drifter.time(i)-data_drifter.time(i+1);

%%% Calcul Vitesse %%% 

    data_drifter.vitesseU(i) = (data_drifter.distanceX(i)/data_drifter.temps(i))*(1000/(24*3600));
    data_drifter.vitesseV(i) = (data_drifter.distanceY(i)/data_drifter.temps(i))*(1000/(24*3600));
end
data_drifter.name='d';
end