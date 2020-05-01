function data_RADAR = read_RADAR(name_file,Const)
% read_RADAR  read  netcdf files of radar data
%   INPUT : file's name
%   OUTPUT : struct with datas
data_RADAR.info=ncinfo(name_file);
data_RADAR.xr=ncread(name_file,'xr');
data_RADAR.yr=ncread(name_file,'yr');

data_RADAR.lon=ncread(name_file,'lon');
data_RADAR.lat=ncread(name_file,'lat');

% Certains fichiers radar n'ont pas de variable donnant l'angle de la
% radiale en tout point. Si c'est le cas on la creee
try
    data_RADAR.angle=ncread(name_file,'ang');
catch
    [data_RADAR.x,data_RADAR.y]=xylonlat(data_RADAR.lon,data_RADAR.lat,Const.lon0,Const.lat0,1);
    % We choose the transmission point the origin of the coordinate system
    Tx_origin=0;
    Ty_origin=0;
    [Rx_origin,Ry_origin]=xylonlat(Const.lon_tx,Const.lat_tx,Const.lon0,Const.lat0,1);
    data_RADAR.angle=dist_angle(Tx_origin,Ty_origin,Rx_origin,Ry_origin,Const.mono,data_RADAR.x,data_RADAR.y);
end

data_RADAR.time=ncread(name_file,'time');
if Const.Radar_type=='PEY' | Const.Radar_type=='POB';
    data_RADAR.time=data_RADAR.time-Const.UTC2;
end

data_RADAR.Vr=ncread(name_file,'v');
data_RADAR.time_origin=datenum(ncreadatt(name_file,'time','time_origin'));

data_RADAR.name='r';
end