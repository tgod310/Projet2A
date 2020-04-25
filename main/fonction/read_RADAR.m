function data_RADAR = read_RADAR(name_file,Const)
% read_RADAR  read  netcdf files of radar data
%   INPUT : file's name
%   OUTPUT : struct with datas
data_RADAR.info=ncinfo(name_file);
data_RADAR.xr=ncread(name_file,'xr');
data_RADAR.yr=ncread(name_file,'yr');

data_RADAR.lat0=43.6750; % Origin of the radial grid, latitude  [decimal deg]
data_RADAR.lon0=7.3271;  % Origin of the radial grid, longitude [decimal deg]

% data_RADAR.lat0=43.0631; % Origin of the radial grid, latitude  [decimal deg]
% data_RADAR.lon0=5.8611;  % Origin of the radial grid, longitude [decimal deg]

data_RADAR.lon=ncread(name_file,'lon');
data_RADAR.lat=ncread(name_file,'lat');

% Certains fichiers radar n'ont pas de variable donnant l'angle de la
% radiale en tout point. Si c'est le cas on la creee
try
    data_RADAR.angle=ncread(name_file,'ang');
catch
    dist_lon=distancelonlat(data_RADAR.lat0,data_RADAR.lon0,data_RADAR.lat,data_RADAR.lon0,Const)*Const.km2m;
    dist_lat=distancelonlat(data_RADAR.lat0,data_RADAR.lon0,data_RADAR.lat0,data_RADAR.lon,Const)*Const.km2m;
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

data_RADAR.time=ncread(name_file,'time')-Const.UTC2;
data_RADAR.Vr=ncread(name_file,'v');
data_RADAR.time_origin=datenum(ncreadatt(name_file,'time','time_origin'));

data_RADAR.name='r';
end
