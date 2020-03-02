function [model,radar] = projection(model,radar)
%projction : réalise la projection de U et V sur le rayon du radar
model.Vr=model.interp_U.*cos(radar.angle)+model.interp_V.*sin(radar.angle);
end

