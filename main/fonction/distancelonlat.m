function [distance] = distancelonlat(lat1,lon1,lat2,lon2,Const)
% Return distance in km btw 2 points from longitude and latitude 
%% Haversine formula %% 

    delta_lat = lat2-lat1;
    delta_lon = lon2-lon1;

    a = sind(delta_lat/2).* sind(delta_lat/2) + cosd(lat1).* cosd(lat2).*sind(delta_lon/2).* sind(delta_lon/2); 
    c = 2 * asin(sqrt(a));

    distance = Const.R * c;
end


