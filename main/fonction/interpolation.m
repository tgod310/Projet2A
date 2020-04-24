function [model,radar] = interpolation(model,radar,shared)
% interp :interpolation function on model space and day mean of radar

%% Spatial Interpolation model
for i=1:length(model.time)
    model.interp_U(:,:,i)=interp2(model.lat,model.lon,model.U(:,:,1,i),shared.lat,shared.lon,'cubic'); % interpolation U
    model.interp_V(:,:,i)=interp2(model.lat,model.lon,model.V(:,:,1,i),shared.lat,shared.lon,'cubic'); % interpolation V
end

%% Daily mean of radar
s=length(shared.time); % number of days 
n=size(radar.Vr);
radar.interp_Vr=NaN(n(1),n(2),s);
for i=2:s-1
    i_min=find(radar.time>=(shared.time(i-1)+shared.time(i))/2,1);
    i_max=find(radar.time<=(shared.time(i)+shared.time(i+1))/2,1,'last');
%     i_min=find(radar.time>=floor(shared.time(i)), 1 ); % start of day
%     i_max=find(radar.time<=ceil(shared.time(i)), 1, 'last' ); % end of day  
    radar.interp_Vr(:,:,i)=mean(radar.Vr(:,:,i_min:i_max),3,'omitnan'); %  daily radar speed mean 
end
end