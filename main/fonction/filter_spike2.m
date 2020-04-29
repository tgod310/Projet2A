function [drifter,data] = filter_spike2(drifter,data)
%filter_spike


%Remove NaN 
to_ignore= isnan(drifter.Vr)==1;
drifter.Vr_filter=drifter.Vr;
drifter.Vr_filter(to_ignore)=[];
drifter.time_drifter=drifter.time;
drifter.time_drifter(to_ignore)=[];

to_ignore1=isnan(data.closer_Vr)==1;
data.closer_Vr_filter=data.closer_Vr;
data.closer_Vr_filter(to_ignore1)=[];
drifter.time_radar=drifter.time;
drifter.time_radar(to_ignore1)=[];

%Remove spike >0.2 m/s
%For drifter
drifter.T=zeros(1,length(drifter.Vr_filter));
for i=1:length(drifter.Vr_filter)-1
    if drifter.T(i)==0
        if abs(drifter.Vr_filter(i)-drifter.Vr_filter(i+1))>0.2
        % i_Max= find(max(abs(drifter.Vr_filter(i)-drifter.Vr_filter(i-1)),abs(drifter.Vr_filter(i)-drifter.Vr_filter(i+1))));
            drifter.T(i+1)= 1;
        end
    end
    if drifter.T(i)==1
        a=i;
        while drifter.T(i-1)==1
            i=i-1;
        end
        if abs(drifter.Vr_filter(a+1)-drifter.Vr_filter(i-1))>0.2
           drifter.T(a+1) = 1;
        end
    end
end
drifter.Vr_filter2=drifter.Vr_filter;
drifter.Vr_filter2(drifter.T ~= 0)=[];
drifter.time_drifter2=drifter.time_drifter;
drifter.time_drifter2(drifter.T ~= 0)=[];

%for radar
data.T=zeros(1,length(data.closer_Vr_filter));
for i=1:length(data.closer_Vr_filter)-1
    if abs(data.closer_Vr_filter(i)-data.closer_Vr_filter(i+1))>0.35 && data.T(i) == 0
      if i<length(data.closer_Vr_filter)-2
        while data.closer_Vr_filter(i+1)==data.closer_Vr_filter(i+2) && i<length(data.closer_Vr_filter)-2
                data.T(i+1)=1;
                i=i+1;
        end
        data.T(i+1)= 1;
      else
        data.T(i+1)= 1;
      end
    
    end
end
data.closer_Vr_filter2=data.closer_Vr_filter;
data.closer_Vr_filter2(data.T ~= 0)=[];
drifter.time_radar2=drifter.time_radar;
drifter.time_radar2(data.T ~= 0)=[];


end

