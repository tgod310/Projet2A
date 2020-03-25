function data_drifter = read_DRIFTER(name_file)
% read_MODEL permet de lire et ouvrir les fichiers netcdf de données de modeles.

dd = readmatrix(name_file);
ds=datastore(name_file);
dv=read(ds);

reference = dv(1,1);

jour = num2str(dd(:,3));
mois = num2str(dd(:,2));
annee = num2str(dd(:,4));
heure = num2str(dd(:,5));
minute = num2str(dd(:,6));
sec  = num2str(dd(:,7));


DateString=strcat(annee,{'-'},mois,{'-'},jour,{' '},heure,{':'},minute,{':'},sec);
formatIn = 'yyyy-mm-dd HH:MM:SS';
 
 
data_drifter.date = datenum(DateString,formatIn);

data_drifter.lat = dd(:,9);
data_drifter.lon = dd(:,10);
data_drifter.ref = reference;


%%%%%%%%%  Calcul vitesse %%%%%%%%%%%% 

%%% Calcul deltaX %%%%%% 
a=111.13292; b=-0.55982; c=111.41284;

for i=1:length(data_drifter.lat)
    cos1=cosd(data_drifter.lat(i)); 
    cos2=cosd(2*data_drifter.lat(i));

   
    X = (data_drifter.lon(i+1)-data_drifter.lon(i)).*(c*cos1); 
    Y = (data_drifter.lat(i+1)-data_drifter.lat(i)).*(a+b*cos2);
    data_drifter.distance(i) = sqrt(X(i)*X(i)+Y(i)*Y(i));
     


%%%%%  Calcul deltaT %%%%%%% 

    data_drifter.temps(i) = data_drifter.date(i+1)-data_drifter.date(i);

%%%%% Calcul Vitesse %%%%%%% 

    data_drifter.vitesse(i) = data_drifter.distance(i)/data_drifter.temps(i);

end


end

