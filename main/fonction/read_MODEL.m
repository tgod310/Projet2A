function data_MODEL = read_MODEL(name_file_U,name_file_V,Const)
% read_MODEL read  netcdf files of model data
%   INPUT : file's name
%   OUTPUT : struct ( U,V, norm)

data_MODEL.info=ncinfo(name_file_U);
data_MODEL.lon=ncread(name_file_U,'nav_lon');
data_MODEL.lat=ncread(name_file_U,'nav_lat');
data_MODEL.depth=ncread(name_file_U,'depthu');
data_MODEL.time=(ncread(name_file_U,'time_counter'))/(Const.d2s);
data_MODEL.time_counter_bnds=ncread(name_file_U,'time_counter_bnds');
data_MODEL.U=ncread(name_file_U,'vozocrtx');
data_MODEL.V=ncread(name_file_V,'vomecrty');
data_MODEL.wind_U=ncread(name_file_U,'sozotaux');
data_MODEL.wind_V=ncread(name_file_V,'sometauy');
data_MODEL.norm=sqrt(data_MODEL.U.^2+data_MODEL.V.^2);
data_MODEL.time_origin=datenum(data_MODEL.info.Variables(4).Attributes(7).Value,'yyyy-mmm-dd HH:MM:SS');

data_MODEL.name='m';
end
