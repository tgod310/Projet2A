function [model,radar,shared] = shared_time(model,radar,shared)
radar.time_min=min(radar.time);
radar.time_max=max(radar.time);
radar.time_step=(radar.time_max-radar.time_min)/length(radar.time);
model.time_min=min(model.time);
model.time_max=max(model.time);
model.time_step=(model.time_max-model.time_min)/length(model.time);

[shared.time_0,shared.time_end]=crossed_data(radar.time_min,radar.time_max,model.time_min,model.time_max);

i_time=model.time>=shared.time_0 & model.time<=shared.time_end;
shared.time=model.time(i_time);
end

