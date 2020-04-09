
clear
close all 
clc

addpath('../../WERA','../../drifter/round1')

%%
%%% Comparaison between radial velocities from radar and drifter
%%%
%%%
%%%     INPUT:  - drifters file in netcdf coriolis format
%%%             - radar data in netcdf format from
%%%             conversion_cll_xyv_2_nc.m
%%%
%%% !!! At this date, the time indicated in the name file of radar data 
%%% available on SYNCHROWERA is the time of the begining of the measure.
%%% Each file are computing over one hour, containing all the sample needed
%%% for MUSIC algorithm. If samples are missing, then the algorithm ignores
%%% them. Consequently an estimate of the radar mesurement time is the time
%%% indicated in the file name + 30 min. More accurate estimation could be
%%% done but not yet!!!

CONFIGURATION_PEY_POB

%% list of available drifters

i_station = 1;


%% datas for find_point_xy_limite


    angle_resol=5.0;  %[deg]  angle_resolution
    range_resol=1.853400;   %[km]
    max_range=45*1.8534;  %[km]
    max_dist_grid_drifter=sqrt((2*pi*max_range*angle_resol/360)^2+range_resol^2);
    
 %% ############################
    %%% LOAD radar
    %%############################ 
  
    ncfile='Radials_RUV_May19.nc';
    time_origin = '2010-01-01 00:00:00' ;
    
    
    radar.VR      =double(ncread(ncfile,'v'));%vr%VR
    radar.latr    =double(ncread(ncfile,'lat'));%latr%LATR
    radar.lonr    =double(ncread(ncfile,'lon'));%lonr%LONR
    radar.xr      =double(ncread(ncfile,'xr'));%XR
    radar.yr      =double(ncread(ncfile,'yr'));%YR
    radar.JULD    =double(ncread(ncfile,'time'));%JULD
    
   
    %time_origin   =ncreadatt(ncfile,'JULD','time_origin');

   if (i_station == 1)
    radar.lat0    = 43.6750; % Origin of the radial grid, latitude  [decimal deg]
    radar.lon0    = 7.3271;  % Origin of the radial grid, longitude [decimal deg]
    radar.lat_tx  = 43.6750; % TX latitude  [decimal deg]radar.alpha  
    radar.lon_tx  = 7.3271333;  % TX longitude [decimal deg]
    radar.lat_rx  =43.6750; % RX latitude  [decimal deg]
    radar.lon_rx  = 7.3271333;  % RX longitude [decimal deg]
   end   
   
    fillval = -9.9999e+32;
    radar.VR(radar.VR == fillval)=NaN;
    
    [radar.x_tx radar.y_tx]= xylonlat(radar.lon_tx,radar.lat_tx, radar.lon0, radar.lat0 , 1);
    [radar.x_rx radar.y_rx]= xylonlat(radar.lon_rx,radar.lat_rx, radar.lon0, radar.lat0 , 1);

    
    %% ############################ 
    %%% LOAD drifter
    %%############################ 
    
    %% list of available drifters
    path_drifter='..\..\round1';
    drifter_name=drifter_list(path_drifter);

    for i_drift=1: size(drifter_name.short,1)
        
        disp(drifter_name.long(i_drift,:))
        dd= readmatrix(drifter_name.long(i_drift,:));
        dd=flipud(dd);
        drifter(1,i_drift).JULD=datenum(dd(:,4),dd(:,2),dd(:,3),dd(:,5),dd(:,6),dd(:,7))-...
            datenum(time_origin);
%          size(drifter(1,i_drift).JULD)

        drifter(1,i_drift).long_name  =drifter_name.long(i_drift,:);
        drifter(1,i_drift).short_name =drifter_name.short(i_drift,:);
        
        drifter(1,i_drift).lon   =dd(:,10);
        drifter(1,i_drift).lat   =dd(:,9);
        drifter(1,i_drift).DATE  =julday2date(drifter(1,i_drift).JULD,time_origin);  
        
        
        %%% conversion lon/lat to (x,y) km
        
        [drifter(1,i_drift).x,drifter(1,i_drift).y]= ...
            xylonlat(drifter(1,i_drift).lon , drifter(1,i_drift).lat,...
            radar.lon0 , radar.lat0 , 1);
        
    end
    
    
        %% ###################################### 
    %%% Regular Time vector for interpolation 
    %%%###################################### 
    %%%
    %%% based on radar time
    %%%
    %%% times step in seconds
    
    time_step = 900;   %%% 1800 30 minutes
   
    time1=floor(radar.JULD(1));
    time2=ceil(radar.JULD(end));

    interpolation.DATE.julian=time1: time_step/86400:time2;
    
      %% ###################################### 
    %%% radar time interpolation 
    %%%###################################### 

     clear interpolation.radar.VR
    for i=1:size(radar.VR,1)
        for j=1:size(radar.VR,2)
            
            VRtmp=squeeze(radar.VR(i,j,:));         
            interpolation.radar.VR(i,j,:) = ...
                interp1(radar.JULD,VRtmp,interpolation.DATE.julian,'linear');
            
        end
    end
    
    
     %% ###################################### 
    %%% drifter time interpolation 
    %%%###################################### 

        for i_drift= 1: size(drifter_name.short,1)
        
        i_drift

        interpolation.drifter(1,i_drift).x=...
            interp1(drifter(1,i_drift).DATE.julian,drifter(1,i_drift).x,...
            interpolation.DATE.julian,'linear');
        
        interpolation.drifter(1,i_drift).y=...
            interp1(drifter(1,i_drift).DATE.julian,drifter(1,i_drift).y,...
            interpolation.DATE.julian,'linear');
 
    %%% to check interpolation
    [interpolation.drifter(1,i_drift).lon,interpolation.drifter(1,i_drift).lat]= ...
            xylonlat(interpolation.drifter(1,i_drift).x , interpolation.drifter(1,i_drift).y,...
            radar.lon0 , radar.lat0 , 2);
        
        
        %     clf(figure(1));
        %     hold on
        %     trace_cotes_bathy
        %
        %     plot(drifter(1,i_drift).lon,drifter(1,i_drift).lat,'.-b','markersize',4)
        %     plot(interpolation.drifter(1,i_drift).lon,interpolation.drifter(1,i_drift).lat,'.-r','markersize',4)
        
        
    %% ###################################### 
    %%% drifter speed computation
    %%%###################################### 
         interpolation.drifter(1,i_drift).u=NaN.*interpolation.drifter(1,i_drift).x;
         interpolation.drifter(1,i_drift).v=NaN.*interpolation.drifter(1,i_drift).x;
        
        
        interpolation.drifter(1,i_drift).u(1,1)=NaN;
        interpolation.drifter(1,i_drift).v(1,1)=NaN;
%         
%         %%% we consider a backward scheme: the speed at time 't' result
%         %%% from what happened between time 't-1' and 't'.
%         
%         for t = 2 : size(interpolation.drifter(1,i_drift).x,2)
%             
%             interpolation.drifter(1,i_drift).u(1,t) = ...
%                 ( interpolation.drifter(1,i_drift).x(1,t)...
%                 -interpolation.drifter(1,i_drift).x(1,t-1) ) *1e3 / time_step;
%                 
%             interpolation.drifter(1,i_drift).v(1,t) = ...
%                 ( interpolation.drifter(1,i_drift).y(1,t)...
%                 -interpolation.drifter(1,i_drift).y(1,t-1) ) *1e3 / time_step;
% 
%         end
%         %%%%%%%%%% end backward %%%%%%%%
        
        %%% we consider a centerd scheme: the speed at time 't' result
        %%% from what happened between time 't-1' and 't+1'.
        
        for t = 2 : size(interpolation.drifter(1,i_drift).x,2)-1
            
            interpolation.drifter(1,i_drift).u(1,t) = ...
                ( interpolation.drifter(1,i_drift).x(1,t+1)...
                -interpolation.drifter(1,i_drift).x(1,t-1) ) *1e3 / (2*time_step);
                
            interpolation.drifter(1,i_drift).v(1,t) = ...
                ( interpolation.drifter(1,i_drift).y(1,t+1)...
                -interpolation.drifter(1,i_drift).y(1,t-1) ) *1e3 / (2*time_step);

        end
        interpolation.drifter(1,i_drift).u(1,1)=NaN;
        interpolation.drifter(1,i_drift).v(1,1)=NaN;
        %%%%%%%%% end centered %%%%%%%%%%%%%%%
        
        
       interpolation.drifter(1,i_drift).speed=...
            sqrt(interpolation.drifter(1,i_drift).u.^2 + interpolation.drifter(1,i_drift).v.^2);
        
        
    %% ###################################### 
    %%% drifter speed projection
    %%%###################################### 
    
    %%% Calcul de la direction de projection de la vitesse %%%%%%%%%%%%%%%%%%%%    
    [ alpha, e_x , e_y ] =...
    projection_direction_bistatic(interpolation.drifter(1,i_drift).x,...
    interpolation.drifter(1,i_drift).y,...
    radar.x_tx,radar.y_tx,radar.x_rx,radar.y_rx );


    %%% projection 
    interpolation.drifter(1,i_drift).VR = ...
        interpolation.drifter(1,i_drift).u.*e_x + ...
        interpolation.drifter(1,i_drift).v.*e_y ;
    
    
    %% ######################################################### 
    %%% RADAR spatial interpolation
    %%%######################################################### 
    
    %%% Closest Radar grid point selection to drifters positions
    
    %%% find the points and save them in a vector to compare
    
    [ir,jr]=find_point_xy_limite(radar.xr,radar.yr,...
        interpolation.drifter(1,i_drift).x,interpolation.drifter(1,i_drift).y,...
        max_range,max_dist_grid_drifter);
      
    % the function "find_point_xy_limte" is based on
    % function"find_point_xy"
%      [ir,jr]=find_point_xy(radar.xr,radar.yr,...
%         interpolation.drifter(1,i_drift).x,interpolation.drifter(1,i_drift).y);
    
    
    
    for t = 1:size(interpolation.radar.VR,3)
        
        if isnan(ir(t)) == 0
            
            interpolation.drifter(1,i_drift).VRradar(t) = ...
                interpolation.radar.VR(ir(t),jr(t),t);
            
            
%             clf(figure(1))
%             hold on
%             trace_cotes_bathy
%             
%             %h0=pcolor(radar.lonr,radar.latr,NaN(size(radar.lonr,1),size(radar.lonr,2)));
%             h0=pcolor(radar.lonr,radar.latr,squeeze(interpolation.radar.VR(:,:,t)));
%             h1=plot(radar.lonr(ir(t),jr(t)),radar.latr(ir(t),jr(t)),'ob');
%             h2=plot(interpolation.drifter(1,i_drift).lon(t),interpolation.drifter(1,i_drift).lat(t),'xr');
%             
%             pause
            
            
        else
            
            interpolation.drifter(1,i_drift).VRradar(t) = NaN;
        end
        
    end
    
    
%     clf(figure(2)); 
%     hold on ;
%     h1=plot(interpolation.DATE.julian,interpolation.drifter(1,i_drift).VR,'xr');
%     h2=plot(interpolation.DATE.julian,interpolation.drifter(1,i_drift).VRradar,'ob');
%     legend([h1 h2],'drifter','radar')
%     title([RADAR_infos(active_sites(i_station)).name ' / ' drifter(i_drift).short_name(1:end-3)])
%     xlabel('Date (julian day)')
%     ylabel('Radial Velocity (m/s)')
%     box on;grid on
%     
%     set(gcf,'position',[53   685  1592   259])
%     %savefig(['Figure/' RADAR_infos(active_sites(i_station)).name '-' drifter(i_drift).short_name(1:end-3)],2,'jpeg');
%     %eval(['print -djpeg Figure/' RADAR_infos(active_sites(i_station)).name '-' drifter(i_drift).short_name(1:end-3) '.jpeg'])
%     
%     set(gcf, 'Color', 'w');
%     filename=['Figure/' RADAR_infos(active_sites(i_station)).name '-' drifter(i_drift).short_name(1:end-3)];
%     
%     %export_fig(filename, '-jpeg', '-painters','-m2.5')
    
    
    

        end
        
        
 %       save('veldiff_ontraj.mat','-struct','interpolation.drifter')

     %   pause

    %% ######################################################### 
    %%% Correlation between radar and drifters
    %%%######################################################### 
    
    %% 1/ Correlation and Plot radar against drifter for each drifter
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     clear all
%     close all
%     clc
%    load('matlab.mat')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    clf(figure(3));
    hold on ;
    vr_rad_alldrift=[];
    vr_drift_alldrift=[];
    
    for i_drift= 1: size(drifter_name.short,1)
         
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% linear regression + correlation
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        to_ignore1 = isnan(interpolation.drifter(1,i_drift).VRradar) == 1;
        to_ignore2 = isnan(interpolation.drifter(1,i_drift).VR) == 1;
        to_ignore=to_ignore1+to_ignore2;
        
        vr_rad = interpolation.drifter(1,i_drift).VRradar;
        vr_rad(to_ignore ~= 0)=[];
        
        vr_rad_alldrift= [vr_rad_alldrift vr_rad];
        
        vr_drift = interpolation.drifter(1,i_drift).VR;
        vr_drift(to_ignore ~= 0)=[];
        
        vr_drift_alldrift = [vr_drift_alldrift vr_drift];
        
        [PP,S] = polyfit(vr_drift,vr_rad,1);
        fm=PP(1,1)*(-1:1)+PP(1,2);
        
        %% some statistiques:
        stat.indiv.bias(i_drift)        = mean(vr_drift) - mean(vr_rad);
        stat.indiv.var.radar(i_drift)   = mean((vr_rad - mean(vr_rad)).^2);
        stat.indiv.std.radar(i_drift)   = sqrt(stat.indiv.var.radar(i_drift));
        stat.indiv.var.drifter(i_drift) = mean((vr_drift - mean(vr_drift)).^2);
        stat.indiv.std.drifter(i_drift) = sqrt(stat.indiv.var.drifter(i_drift));
        stat.indiv.rms(i_drift)         = sqrt(mean((vr_rad - vr_drift).^2));
        stat.indiv.corr(i_drift)        = ...
            sum( (vr_rad-mean(vr_rad)) .* (vr_drift-mean(vr_drift)) ) ...
            ./ ( sqrt(sum((vr_rad - mean(vr_rad)).^2)).*sqrt(sum((vr_drift - mean(vr_drift)).^2)) );
        
        
        %% Plot
        % comparaison VR VRradar
        
        
        
        
         figure('units','normalized','outerposition',[0 0 1 1])
        
         plot(interpolation.drifter(i_drift).VR,'-')
         
%          ylim([-0.5 0.5]); 
         hold on
         plot(interpolation.drifter(i_drift).VRradar,'*')
         hold off
         title(['comparaison drifter N.' num2str(i_drift) '-radar' ])
%          xlable('')
         ylabel('speed')
         legend('drifter','radar')
        
        
        
        
        %pause
        %% plot
        
        
%         h1=plot(interpolation.drifter(1,i_drift).VR,interpolation.drifter(1,i_drift).VRradar,'.');
%         
%         h2=plot([-1 1],[-1 1],'color',[0.7 0.7 0.7],'LineWidth',2);
%         
%         h3=plot([-1:1],fm,'color',plot_param.col(i_drift,:));
%         
%         set(h1,'color',plot_param.col(i_drift,:),'Markersize',plot_param.msr)
%         %legend([h1 h2],'drifter','radar')
%         title([RADAR_infos(active_sites(i_station)).name],'fontsize',plot_param.fst)
%         xlabel('Radial Velocity Drifter (m/s)','fontsize',plot_param.fst)
%         ylabel('Radial Velocity Radar (m/s)','fontsize',plot_param.fst)
%         box on;grid on
%         set(gca,'Xlim',[-1 1],'Ylim',[-1 1])
%         set(gcf, 'Color', 'w');
% %         k=0;
% %         %%% legend
% %         k=k+1;
% %         plot(-0.9,0+k*0.05,'.',markersize,'10')
%         filename=['Figure/correlation-' RADAR_infos(active_sites(i_station)).name '-' drifter(i_drift).short_name(1:end-3)] ;
% %        export_fig(filename, '-jpeg', '-painters','-m2.5')
    end
     
   % pause
    
     %% 2/ Plot radar against drifter for all drifter
     
     %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %%% linear regression + correlation
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
     [PP,S] = polyfit(vr_drift_alldrift,vr_rad_alldrift,1);
     fm=PP(1,1)*(-1:1)+PP(1,2);
     
      %% some statistiques:
        stat.alldrift.bias       = mean(vr_drift_alldrift) - mean(vr_rad_alldrift);
        stat.alldrift.var.radar   = mean((vr_rad_alldrift - mean(vr_rad_alldrift)).^2);
        stat.alldrift.std.radar   = sqrt(stat.alldrift.var.radar);
        stat.alldrift.var.drifter = mean((vr_drift_alldrift - mean(vr_drift_alldrift)).^2);
        stat.alldrift.std.drifter = sqrt(stat.alldrift.var.drifter);
        stat.alldrift.rms        = sqrt(mean((vr_rad_alldrift - vr_drift_alldrift).^2));
        stat.alldrift.corr        = ...
            sum( (vr_rad_alldrift-mean(vr_rad_alldrift)) .* (vr_drift_alldrift-mean(vr_drift_alldrift)) ) ...
            ./ ( sqrt(sum((vr_rad_alldrift - mean(vr_rad_alldrift)).^2)).*sqrt(sum((vr_drift_alldrift - mean(vr_drift_alldrift)).^2)) );
        
        
        
    figure(3)  
    h4=plot([-1:1],fm,'--','color',[0 0 0],'LineWidth',2 );
    

 
    clf(figure(4));
    hold on ;
    
    for i_drift= 1: size(drifter_name.short,1)
        
        h1=plot(interpolation.drifter(1,i_drift).VR,interpolation.drifter(1,i_drift).VRradar,'.');
        set(h1,'color',plot_param.col(i_drift,:),'Markersize',plot_param.msr)
    end
        
        h2=plot([-1 1],[-1 1],'color',[0.7 0.7 0.7],'LineWidth',2);
        
        h3=plot([-1:1],fm,'color',[0 0 0],'LineWidth',2);
        

        %legend([h1 h2],'drifter','radar')
        title([RADAR_infos(active_sites(i_station)).name],'fontsize',plot_param.fst)
        xlabel('Radial Velocity Drifter (m/s)','fontsize',plot_param.fst)
        ylabel('Radial Velocity Radar (m/s)','fontsize',plot_param.fst)
        box on;grid on
        set(gca,'Xlim',[-1 1],'Ylim',[-1 1])
        set(gcf, 'Color', 'w');
  
    filename=['Figure/correlation' RADAR_infos(active_sites(i_station)).name];
 %   export_fig(filename, '-jpeg', '-painters','-m2.5')
    
    
    %%% 3 Plot difference along the trajectories
    figure
    hold on;
     for i_drift= 1: size(drifter_name.short,1)
    Delta_VR=-1*(interpolation.drifter(1,i_drift).VR-interpolation.drifter(1,i_drift).VRradar);

    scatter(interpolation.drifter(1,i_drift).lon, interpolation.drifter(1,i_drift).lat, 10, Delta_VR)
    caxis([-0.25 0.25])  
   % plot(interpolation.drifter(1,i_drift).lon, interpolation.drifter(1,i_drift).lat)
     end
     
        %%% 4 Plot velocities along trajectories
        
        for i_drift= 1: size(drifter_name.short,1)
            figure
            hold off
            plot(interpolation.drifter(1,i_drift).VR,'r')
            hold on
            plot(interpolation.drifter(1,i_drift).VRradar,'b*')
            title([ drifter_name.short(i_drift,12:15) drifter_name.short(i_drift,24:24)])
            print([ 'POB' drifter_name.short(i_drift,12:15) drifter_name.short(i_drift,24:24) 'error'] ,'-djpeg')
        end
        
     


    
    
    
    
    
    
    
    




