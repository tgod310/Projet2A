function data_MODEL = read_MODEL(name_file_U,name_file_V)
% read_MODEL permet de lire et ouvrir les fichiers netcdf de données de modeles.
%   Il prend en argument le nom des fichier d'un modele à ouvir
%   Il renvoie un struct contenant les données du fichier netcdf avec les composantes U et V ainsi que la norme des deux

data_MODEL.info=ncinfo(name_file_U);
data_MODEL.lon=ncread(name_file_U,'nav_lon');
data_MODEL.lat=ncread(name_file_U,'nav_lat');
data_MODEL.depth=ncread(name_file_U,'depthu');
data_MODEL.time_counter=ncread(name_file_U,'time_counter');
data_MODEL.time_counter_bnds=ncread(name_file_U,'time_counter_bnds');
data_MODEL.U=ncread(name_file_U,'vozocrtx');
data_MODEL.V=ncread(name_file_V,'vozocrtx');
data_MODEL.wind_U=ncread(name_file_U,'sozotaux');
data_MODEL.wind_V=ncread(name_file_V,'sozotaux');
data_MODEL.norm=sqrt(data_MODEL.U^2+data_MODEL.V^2);
end
