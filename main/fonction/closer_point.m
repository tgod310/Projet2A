function [data,drifter,shared] = closer_point(data,drifter,shared)
% 1)on prend le point du drifter
% 2)on regarde quel point est le plus proche 
    
    %% Point le plus proche spatialement
    l=length(drifter.U);

    shared.delta_D=zeros(1,l);
    drifter.closer_lon=shared.delta_D;
    drifter.closer_lat=shared.delta_D;
    shared.delta_T=shared.delta_D;
    data.closer_Vr=shared.delta_D;
    angle=shared.delta_D;

    for i=1:l
        % On calcule sa distance avec tous les points partagés du model 
        dist=distancelonlat(drifter.lat(i),drifter.lon(i),shared.lat,shared.lon);

        % I la longitude du point le plus proche J la latitude
        shared.delta_D(i)=min(min(dist));
        [drifter.closer_lon(i),drifter.closer_lat(i)]=find(dist==min(min(dist)));
        I=drifter.closer_lon(i);
        J=drifter.closer_lat(i);

        %% Point le plus proche temporellement        
        shared.delta_T(i)=100;
        for k=1:length(data.time)
            b=abs(drifter.time(end-i)-data.time(k));
            if b<shared.delta_T(i)
                shared.delta_T(i)=b;
                c=k;
            end
        end

        if data.name=='m'
            data.closer_U(i)=data.U(I,J,1,c);
            data.closer_V(i)=data.V(I,J,1,c);

            shared.delta_U(i)=abs(data.closer_U(i)-drifter.U(i));
            shared.delta_V(i)=abs(data.closer_V(i)-drifter.U(i));

        elseif data.name=='r'
            data.closer_Vr(i)=data.Vr(I,J,c);
            angle(i)=data.angle(I,J);
        end
    end
    data.angle=angle;
    drifter=projection(drifter,data);
    shared.delta_Vr=abs(data.closer_Vr-drifter.Vr);
end

