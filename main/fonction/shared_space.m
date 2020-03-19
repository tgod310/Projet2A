function [model,radar,shared] = shared_space(model,radar,shared)
radar.lat_min=min(min(radar.lat));
radar.lat_max=max(max(radar.lat));
radar.lon_min=min(min(radar.lon));
radar.lon_max=max(max(radar.lon));
model.lat_min=min(min(model.lat));
model.lat_max=max(max(model.lat));
model.lon_min=min(min(model.lon));
model.lon_max=max(max(model.lon));

[shared.lat_0,shared.lat_end]=crossed_data(radar.lat_min,radar.lat_max,model.lat_min,model.lat_max);
[shared.lon_0,shared.lon_end]=crossed_data(radar.lon_min,radar.lon_max,model.lon_min,model.lon_max);

i_lat=radar.lat<shared.lat_0 | radar.lat>shared.lat_end;
i_lon=radar.lon<shared.lon_0 | radar.lon>shared.lon_end;

radar.interp_Vr=radar.Vr;
radar.interp_Vr(i_lat)=NaN;
radar.interp_Vr(i_lon)=NaN;

i_Vr=isnan(radar.interp_Vr(:,:,1));
shared.lon=radar.lon;
shared.lat=radar.lat;
shared.lon(i_Vr)=NaN;
shared.lat(i_Vr)=NaN;
end

