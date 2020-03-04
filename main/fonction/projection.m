function [model,radar] = projection(model,radar)
% projection : realise la projection de U et V sur le rayon du radar
model.Vr=model.interp_U.*cosd(radar.angle)+model.interp_V.*sind(radar.angle);
end

