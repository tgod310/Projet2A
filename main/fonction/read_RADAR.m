function data_RADAR = read_RADAR(name_file)
% read_RADAR permet de lire et ouvrir un fichier netcdf de données radar.
%   Il prend en argument le nom du fichier radar à ouvir
%   Il renvoie un struct contenant les données du fichier netcdf

data_RADAR.info=ncinfo(name_file);
data_RADAR.xr=ncread(name_file,'xr');
data_RADAR.yr=ncread(name_file,'yr');
data_RADAR.lon=ncread(name_file,'lon');
data_RADAR.lat=ncread(name_file,'lat');
data_RADAR.time=ncread(name_file,'time');
data_RADAR.v=ncread(name_file,'v');
end
