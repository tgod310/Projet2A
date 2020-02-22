function [model,radar] = interpolation(model,radar)
%interp : fonction d'interpolation sur l'espace
for i=1:length(model.time)
    model.interp_U(:,:,i)=interp2(model.lat,model.lon,model.U(:,:,1,i),radar.lat,radar.lon);
    model.interp_V(:,:,i)=interp2(model.lat,model.lon,model.V(:,:,1,i),radar.lat,radar.lon);
end
end

