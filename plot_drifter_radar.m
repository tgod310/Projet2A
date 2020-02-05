%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% comparaison between radar and drifter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
clc

%% basic data
date_start=datenum('2019-05-01 00:00:00')-datenum('1899-12-30 00:00:00');% yyyy-mm-dd hh:mm:ss
date_end=datenum('2019-06-11 00:00:00')-datenum('1899-12-30 00:00:00');
max_longitude=10;
max_latitude=44.5;
%drifter
ptotal=readmatrix('drifter-09_25_19-00_57.xlsx');
%radar
rlon=ncread('Radials_RUV_May19.nc','lon');
rlat=ncread('Radials_RUV_May19.nc','lat');
rv=ncread('Radials_RUV_May19.nc','v');
%radar mask
lonOrg=7.3271333;  % radar position
latOrg=43.6750000; 
angel_limite=260;  % 260°, clockwise, from north


%% drifter data

ptotalud=flipud(ptotal);

number_start=find((ptotalud(:,2)-date_start)==min(abs(ptotalud(:,2)-date_start)));
number_end=find((ptotalud(:,2)-date_end)==min(abs(ptotalud(:,2)-date_end)));

for i=1:size(ptotalud,1)
    
    if ptotalud(i,4)>max_longitude
        ptotalud(i,4)=NaN;
        ptotalud(i,3)=NaN;
        ptotalud(i,2)=NaN;
    else
    end
    
     if ptotalud(i,3)>max_latitude
         ptotalud(i,4)=NaN;
        ptotalud(i,3)=NaN;
        ptotalud(i,2)=NaN;
     else
     end
     
end

% cut the periode 1 for study
show=ptotalud(1:(number_end-number_start+1),:);
datestrs=datestr(show(:,2)+datenum('1899-12-30 00:00:00'));
datenums=datenum(datestrs);


%% radar data


lon_radar=rlon(:);
lat_radar=rlat(:);
v=squeeze(rv(:,:,1));


%calculate tan of each direction 
angel_tan=(rlon(:,size(rlat,2))-rlon(:,size(rlat,2)-1))./(rlat(:,size(rlat,2))-rlat(:,size(rlat,2)-1));
diff=abs(angel_tan-tan((angel_limite-180)*pi/360));

%find the direction hich is the closest to the angel_limite 
result=find(diff==min(diff));

position_mask_1=find(rlat(:,size(rlat,2))>latOrg); % delete all the data in north(0°~180°, 270°~360°)
position_mask_2=find(rlon(:,size(rlat,2))<rlon(max(result),size(rlat,2)));%delete all the data on the leftside of angel_limite
v(position_mask_1,:)=NaN;
v(position_mask_2,:)=NaN;

v_radar=v(:);


%% creat figure
hF = figure('units','normalized','outerposition',[0 0 1 1]);

%axes 1
AxesDrifter = axes;
colormap(AxesDrifter,gray);

tracecotes
hold on

%part 1 drifter
scatter(show(:,4),show(:,3),10,datenums)
pcolorPlot=scatter(show(:,4),show(:,3),10,datenums);
% caxis(AxesDrifter,[min(datenums) max(datenums)]);
hold on

%axes 2
%create axes for the countourm axes
AxesRadar = axes;

%set visibility for axes to 'off' so it appears transparent
axis(AxesRadar,'off')

%set colormap for contourm axes
colormap(AxesRadar,cool);

%part 2 radar
% pcolor(rlon,rlat,rv(:,:,1));
% contourmPlot =pcolor(rlon,rlat,rv(:,:,1));
scatter(lon_radar,lat_radar,18,v_radar,'filled','d');
contourmPlot =scatter(lon_radar,lat_radar,18,v_radar,'filled','d');


%create color bar and set range for color
colormap(AxesRadar,'hot')

rv(isnan(rv))==0;
% caxis(AxesRadar,[min(min(rv(:,:,1))) max(max(rv(:,:,1)))]);

%link the two overlaying axes so they match at all times to remain accurate
linkaxes([AxesDrifter,AxesRadar]);
axis(AxesRadar,'off')


% details of colorbars
set([AxesDrifter,AxesRadar],'Position',[.17 .11 .685 .815]);

cb1 = colorbar(AxesDrifter,'Position',[.10 .11 .02 .815]);
limite_cb1=get(cb1,'Limits');
set(cb1,'YTick',linspace(round(limite_cb1(1)),round(limite_cb1(2)),10));
name=datestr(cb1.Ticks);
name=name(:,1:11);% dd-mmm-yyyy
set(cb1,'YTickLabel', {name(1,:),name(2,:),name(3,:),name(4,:),...
    name(5,:),name(6,:),name(7,:),name(8,:),...
   name(9,:),name(10,:)});


cb2 = colorbar(AxesRadar,'Position',[.88 .11 .02 .815]);


title(cb1,'date','FontSize',12);
title(cb2,'speed (m/s)','FontSize',12);
title('comparaison Drifter-Radar','FontSize',20);
xlabel(AxesDrifter,'longitude (°)','FontSize',15);
ylabel(AxesDrifter,'latitude (°)','FontSize',15);














