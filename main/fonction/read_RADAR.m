function data_RADAR = read_RADAR(name_file)
% read_RADAR permet de lire et ouvrir un fichier netcdf de données radar.
%   Il prend en argument le nom du fichier radar à ouvir
%   Il renvoie un struct contenant les données du fichier netcdf

data_RADAR.info=ncinfo(name_file);
data_RADAR.xr=ncread(name_file,'xr');
data_RADAR.yr=ncread(name_file,'yr');

data_RADAR.lat0=43.6750; % Origin of the radial grid, latitude  [decimal deg]
data_RADAR.lon0=7.3271;  % Origin of the radial grid, longitude [decimal deg]

% data_RADAR.lat0=43.0631; % Origin of the radial grid, latitude  [decimal deg]
% data_RADAR.lon0=5.8611;  % Origin of the radial grid, longitude [decimal deg]

data_RADAR.lon=ncread(name_file,'lon');
data_RADAR.lat=ncread(name_file,'lat');

try
    data_RADAR.angle=ncread(name_file,'ang');
catch
    dist_lon=distancelonlat(data_RADAR.lat0,data_RADAR.lon0,data_RADAR.lat,data_RADAR.lon0)*1000;
    dist_lat=distancelonlat(data_RADAR.lat0,data_RADAR.lon0,data_RADAR.lat0,data_RADAR.lon)*1000;
    data_RADAR.angle=atan2d(dist_lat,dist_lon);
    q1=data_RADAR.lon<data_RADAR.lon0 & data_RADAR.lat<data_RADAR.lat0;
    q2=data_RADAR.lon<data_RADAR.lon0 & data_RADAR.lat>=data_RADAR.lat0;
    q3=data_RADAR.lon>data_RADAR.lon0 & data_RADAR.lat>=data_RADAR.lat0;
    q4=data_RADAR.lon>data_RADAR.lon0 & data_RADAR.lat<data_RADAR.lat0;
    data_RADAR.angle(q1)=90-data_RADAR.angle(q1);
    data_RADAR.angle(q2)=270+data_RADAR.angle(q2);
    data_RADAR.angle(q3)=270-data_RADAR.angle(q3);
    data_RADAR.angle(q4)=90+data_RADAR.angle(q4);
end

data_RADAR.time=ncread(name_file,'time')-1/12;
data_RADAR.Vr=ncread(name_file,'v');
data_RADAR.time_origin=datenum(ncreadatt(name_file,'time','time_origin'));

data_RADAR.name='r';
end
