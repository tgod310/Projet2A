function [data,drifter,shared] = closer_point(data,drifter,shared)
%retourne shared.delta_D, shared.delta_T,shared.delta_U,shared.delta_V,
%data.closer_U, data.closer_V, data.closer_Vr

%% Point le plus proche spatialement
    len=length(drifter.U);
    
    % Initialisation de vecteurs nuls
    shared.delta_D=zeros(1,len);
    drifter.closer_lon=shared.delta_D;
    drifter.closer_lat=shared.delta_D;
    shared.delta_T=shared.delta_D;
    data.closer_Vr=shared.delta_D;
    angle=shared.delta_D;

    %% Boucle prenant chaque point du drifter et enregistrant le point le plus proche
    for i=1:len
        %% Point le plus proche spatialement
        % On calcule sa distance avec tous les points partagés du model 
        dist=distancelonlat(drifter.lat(i),drifter.lon(i),shared.lat,shared.lon);

        % I la longitude du point le plus proche J la latitude
        shared.delta_D(i)=min(min(dist));
        [drifter.closer_lon(i),drifter.closer_lat(i)]=find(dist==min(min(dist)));
        I=drifter.closer_lon(i);
        J=drifter.closer_lat(i);

        %% Point le plus proche temporellement        
        delta_T=abs(drifter.time(i)-data.time);
        shared.delta_T(i)=min(delta_T);
        
        %% Comparaison avec modele ou radar
        % On utilise pas tout a fait les memes variables entre le modele et
        % le radar donc on ne realise pas tout a fait les memes operations
        if data.name=='m' % Si modele
            data.closer_U(i)=data.U(I,J,1,c);
            data.closer_V(i)=data.V(I,J,1,c);

            shared.delta_U(i)=abs(data.closer_U(i)-drifter.U(i));
            shared.delta_V(i)=abs(data.closer_V(i)-drifter.U(i));

        elseif data.name=='r' % Si radar
            data.closer_Vr(i)=data.Vr(I,J,c);
            angle(i)=data.angle(I,J);
        end
    end
    
    if data.name=='r' % Si radar
        data.angle=angle;
        drifter=projection(drifter,data);
        shared.delta_Vr=abs(data.closer_Vr-drifter.Vr);
    end
end