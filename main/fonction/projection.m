function data = projection(data,radar)
% projection : U and V projection on radar radius
    if data.name=='m' % If model
        data.Vr=data.interp_U.*cosd(radar.angle)+data.interp_V.*sind(radar.angle);
    elseif data.name=='d' % If drifter
        data.Vr=data.U.*cosd(radar.angle)+data.V.*sind(radar.angle);
    end
end