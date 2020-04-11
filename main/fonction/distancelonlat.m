function [distance] = distancelonlat(lat1,lon1,lat2,lon2)
%retourne la distance en km entre deux points à partir de leur latitude et
%longitude
%%Formule de Haversine%%
R = 6371;%rayon de la terre 

    delta_lat = lat2-lat1;
    delta_lon = lon2-lon1;


     a = sind(delta_lat/2).* sind(delta_lat/2) + cosd(lat1).* cosd(lat2).*sind(delta_lon/2).* sind(delta_lon/2); 
    c = 2 * atan2(sqrt(a), sqrt(1-a));

    distance = R * c;
    
end


