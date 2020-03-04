

name_file= '/home/yann/Documents/Yann/Seatech/PROJET2A/Projet2A/round1/033.xlsx';

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


