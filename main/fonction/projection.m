function data = projection(data,radar)
% projection : realise la projection de U et V sur le rayon du radar
    if data.name=='m'
        data.Vr=data.interp_U.*cosd(radar.angle)+data.interp_V.*sind(radar.angle);
    elseif data.name=='d'
        data.Vr=data.U.*cosd(radar.angle)+data.V.*sind(radar.angle);
    end
end

