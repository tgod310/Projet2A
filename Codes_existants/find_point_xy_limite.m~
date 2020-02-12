%%% MARMAIN
%%% 2012/05/10
%%% to find the closest i,j index  corresponding to lo1,la1
%%%
%%% updated MARMAIN 2012/08/07 - 
%%% to find the closest i,j index  corresponding to x_d,y_d

%%% 2019/10/24
%%% filter for the drifters far from the grid position


function[ir,jr]=find_point_xy_limite(nav_x,nav_y,x_d,y_d,max_range,max_dist_grid_drifter)
%%%nav_x c'est radar et x_d c'est drifter
%%% calcul de la difference de position entre flotteur et radar
for n = 1 : length(x_d)
    
   
    x1=ones(size(nav_x,1),size(nav_x,2)).*x_d(n);
    y1=ones(size(nav_x,1),size(nav_x,2)).*y_d(n);
    
    dist=sqrt((nav_x-x1).^2+(nav_y-y1).^2);
    
    if isnan(dist) == 0  %%si c'est un nombre 
        
        [ir(n),jr(n)]=find(dist==min(min(dist)));
       
    else
         ir(n) = NaN;
         jr(n) = NaN;
    end
    
   
    % limite 1 : if the drifter is out of the radar circle, then NAN
    if sqrt(x_d(n)^2+y_d(n)^2)>max_range
         ir(n) = NaN;
         jr(n) = NaN;
    else
    end
    
    % limite 2: if the difter is far from the nearest grid, then NAN
    if min(min(dist))> max_dist_grid_drifter
         ir(n) = NaN;
         jr(n) = NaN;
    else
    end
     
    
end

end
