function [model,radar] = interpolation(model,radar)
%interp : fonction d'interpolation sur l'espace
for i=1:length(model.time)
    model.interp_U(:,:,i)=interp2(model.lat,model.lon,model.U(:,:,1,i),radar.lat,radar.lon);
    model.interp_V(:,:,i)=interp2(model.lat,model.lon,model.V(:,:,1,i),radar.lat,radar.lon);
end

s=size(radar.Vr);
for i=1:s(1)
    for j=1:s(2)
        radar.interp_Vr(i,j,:)=interp1(radar.time,squeeze(radar.Vr(i,j,:)),model.time);% ou moyenne 
    end
end
end

