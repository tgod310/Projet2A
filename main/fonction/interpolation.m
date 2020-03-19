function [model,radar] = interpolation(model,radar,shared)
%interp : fonction d'interpolation sur l'espace
for i=1:length(model.time)
    model.interp_U(:,:,i)=interp2(model.lat,model.lon,model.U(:,:,1,i),shared.lat,shared.lon,'cubic');
    model.interp_V(:,:,i)=interp2(model.lat,model.lon,model.V(:,:,1,i),shared.lat,shared.lon,'cubic');
end

s=length(shared.time);
for i=1:s-1
    i_min=find(radar.time>=shared.time(i), 1 );
    i_max=find(radar.time<=shared.time(i+1), 1, 'last' );
    radar.interp_Vr(:,:,i)=mean(radar.Vr(:,:,i_min:i_max),3);
end
end

