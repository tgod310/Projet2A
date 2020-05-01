function [drifter,data] = filter_spike2(drifter,data)
%filter_spike

if data.name=='r'
%Remove NaN 
to_ignore= isnan(drifter.Vr)==1;
drifter.Vr_filter=drifter.Vr;
drifter.Vr_filter(to_ignore)=[];
drifter.time_drifter=drifter.time;
drifter.time_drifter(to_ignore)=[];


to_ignore1=isnan(data.closer_Vr)==1 ;
data.closer_Vr_filter=data.closer_Vr;
data.closer_Vr_filter(to_ignore1)=[];
drifter.time_radar=drifter.time;
drifter.time_radar(to_ignore1)=[];

%Remove > Mean 
Mean_drifter = mean(drifter.Vr_filter);
to_ignore2= drifter.Vr_filter > Mean_drifter + 3 | drifter.Vr_filter < Mean_drifter - 3;
drifter.Vr_filter(to_ignore2)=[];
drifter.time_drifter(to_ignore2)=[];

Mean_data = mean(data.closer_Vr_filter);
to_ignore3 = data.closer_Vr_filter > Mean_data + 3 | data.closer_Vr_filter < Mean_data - 3 ;
data.closer_Vr_filter(to_ignore3)=[];
drifter.time_radar(to_ignore3)=[];

%Remove spike >0.2 m/s
%For drifter
drifter.T=zeros(1,length(drifter.Vr_filter));
for i=1:length(drifter.Vr_filter)-1
    if i == 1 
        if abs(drifter.Vr_filter(i)-drifter.Vr_filter(i+1))>0.2
            A = [abs(drifter.Vr_filter(i)-Mean_drifter),abs(drifter.Vr_filter(i+1)-Mean_drifter)];
            Min = find(A == min(A));
            if Min == 1 
                drifter.T(i+1)=1;
            else 
                drifter.T(i)=1;
            end
        end
    else
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
end

