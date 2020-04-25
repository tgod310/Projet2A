function [data,drifter,shared] = closer_point(data,drifter,shared,Const)
%retourne shared.delta_D, shared.delta_T,shared.delta_U,shared.delta_V,
%data.closer_U, data.closer_V, data.closer_Vr

%% Closer point in space
    len=length(drifter.U);
    
    % Initialization
    shared.delta_D=zeros(1,len);
    drifter.closer_lon=shared.delta_D;
    drifter.closer_lat=shared.delta_D;
    shared.delta_T=shared.delta_D;
    data.closer_Vr=shared.delta_D;
    angle=shared.delta_D;

    %% Loop taking each point of drifter and saving closer point
    for i=1:len
        %% Closer point in space
        % Calculation distance with shared model 
        dist=distancelonlat(drifter.lat(i),drifter.lon(i),shared.lat,shared.lon,Const);

        % I longitude of closer point J latitude
        shared.delta_D(i)=min(min(dist));
%         [drifter.closer_lon(i),drifter.closer_lat(i)]=find(dist==min(min(dist)));
%         I=drifter.closer_lon(i);
%         J=drifter.closer_lat(i);

        [I,J]=find(dist==min(min(dist)));
        I=min(I);
        J=min(J);
        
        %% Closer point in time        
        shared.delta_T(i)=100;
        for k=1:length(data.time)
            b=abs(drifter.time(i)-data.time(k));
            if b<shared.delta_T(i)
                shared.delta_T(i)=b;
                c=k;
            end
        end

        if data.name=='m' %if it is with model
            data.closer_U(i)=data.U(I,J,1,c);%model speed 
            data.closer_V(i)=data.V(I,J,1,c);%lon,lat,depth,time

            shared.delta_U(i)=abs(data.closer_U(i)-drifter.U(i));
            shared.delta_V(i)=abs(data.closer_V(i)-drifter.U(i));

        elseif data.name=='r' % if it is with radar
            data.closer_Vr(i)=data.Vr(I,J,c);
            angle(i)=data.angle(I,J);
        end
    end
    
    if data.name=='r' 
        data.angle=angle;
        drifter=projection(drifter,data);
        shared.delta_Vr=abs(data.closer_Vr-drifter.Vr);
    end
end