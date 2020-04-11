function [data1,drifter] = closer_point(data1,drifter,shared)
% 1)on prend le point du drifter
% 2)on regarde quel point est le plus proche 

    l=length(drifter.U);

    delta_D=zeros(1,l);
    drifter.closer_lon=delta_D;
    drifter.closer_lat=delta_D;

    for i=1:l
        % On calcule sa distance avec tous les points partagés du model 
        dist=distancelonlat(drifter.lat(i),drifter.lon(i),shared.lat,shared.lon);

        % I la longitude du point le plus proche J la latitude
        delta_D(i)=min(min(dist));
        [drifter.closer_lon(i),drifter.closer_lat(i)]=find(dist==min(min(dist)));
    end
end