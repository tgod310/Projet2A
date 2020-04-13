function [data1,data2,shared] = shared_space(data1,data2,shared)

data1.lat_min=min(min(data1.lat));
data1.lat_max=max(max(data1.lat));
data1.lon_min=min(min(data1.lon));
data1.lon_max=max(max(data1.lon));

data2.lat_min=min(min(data2.lat));
data2.lat_max=max(max(data2.lat));
data2.lon_min=min(min(data2.lon));
data2.lon_max=max(max(data2.lon));

[shared.lat_0,shared.lat_end]=crossed_data(data1.lat_min,data1.lat_max,data2.lat_min,data2.lat_max);
[shared.lon_0,shared.lon_end]=crossed_data(data1.lon_min,data1.lon_max,data2.lon_min,data2.lon_max);

i_lat=data1.lat<shared.lat_0 | data1.lat>shared.lat_end;
i_lon=data1.lon<shared.lon_0 | data1.lon>shared.lon_end;

shared.lon=data1.lon;
shared.lat=data1.lat;
shared.lon(i_lon)=NaN;
shared.lat(i_lat)=NaN;
end

