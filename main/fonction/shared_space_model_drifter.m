function [model,drifter,shared] = shared_space_model_drifter(model,drifter,shared)
drifter.lat_min=min(drifter.lat);
drifter.lat_max=max(drifter.lat);
drifter.lon_min=min(drifter.lon);
drifter.lon_max=max(drifter.lon);

model.lat_min=min(min(model.lat));
model.lat_max=max(max(model.lat));
model.lon_min=min(min(model.lon));
model.lon_max=max(max(model.lon));

[shared.lat_0,shared.lat_end]=crossed_data_model_drifter(drifter.lat_min,drifter.lat_max,model.lat_min,model.lat_max);
[shared.lon_0,shared.lon_end]=crossed_data_model_drifter(drifter.lon_min,drifter.lon_max,model.lon_min,model.lon_max);

i_lat=model.lat<shared.lat_0 | model.lat>shared.lat_end;
i_lon=model.lon<shared.lon_0 | model.lon>shared.lon_end;

shared.lon=model.lon;
shared.lat=model.lat;
shared.lon(i_lon)=NaN;
shared.lat(i_lat)=NaN;
end

