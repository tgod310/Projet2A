function [data1,drifter,shared] = closer_point(data1,drifter,shared)
%1)on prend le point du drifter
%2)on regarde quel point est le plus proche 
%%liste des drifters qui sont dans le shared
s=length(drifter.U);

dist_min=zeros(1,s);
delta_D=dist_min;
delta_T=zeros(1,s);
data1_vitesseU=zeros(1,s);
data1_vitesseV=zeros(1,s);
diff_vitesseU=zeros(1,s);

for i=1:length(drifter.U) 
    % On calcule sa distance avec tous les points partagés du model 
    dist=distancelonlat(drifter.lat(i),drifter.lon(i),shared.lat,shared.lon);

    % I la longitude du point le plus proche J la latitude
    delta_D(i)=min(min(dist));
    [I,J]=find(dist==delta_D(i));

    % On prend le meme jour
    delta_T(i)=100; 
    for k=1:length(data1.time)
        b=abs(drifter.time(i)-data.time(k));
        if b<delta_T(i)
            delta_T(i)=b;
            c=k;
        end
    end
    data1_vitesseU(i)=data1.U(I,J,1,c); % Le model commence le 9 mai avec une donnee par jour
    data1_vitesseV(i)=data1.V(I,J,1,c);

    diff_vitesseU(i)=abs(data1_vitesseU(i)-drifter.vitesseU(i));
end
end

