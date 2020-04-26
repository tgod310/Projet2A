function [drifter,data] = filter_spike(drifter,data)
%filter spikes over 20 cm/s

for i=1:length(drifter.U)-1
    
        if  abs(drifter.U(i)-drifter.U(i+1))> 0.2
         drifter.U(i)=NaN;
        end
         if abs(drifter.V(i)-drifter.V(i+1))> 0.2
         drifter.V(i)=NaN;
         end
         if data.name=='r'
            if abs(drifter.Vr(i)-drifter.Vr(i+1))> 0.2
            drifter.Vr(i)=NaN;
            end
         end
end 

if data.name=='r' 
    
   for k=1:length(data.closer_Vr)-1
       if  abs(data.closer_Vr(k)-data.closer_Vr(k+1))> 0.35
           
           while data.closer_Vr(k+1)==data.closer_Vr(k+2)
                data.closer_Vr(k+1)=NaN;
                k=k+1;
           end
           data.closer_Vr(k+1)=NaN;
       end
       if isnan(data.closer_Vr(k))==0 && isnan(data.closer_Vr(k+1))==1   % if k is not NaN and k+1 is NaN
          a=k;
           while isnan(data.closer_Vr(k+1))==1 && k<length(data.closer_Vr)-1
              k=k+1;
          end
          if abs(data.closer_Vr(a)-data.closer_Vr(k+1))>0.35
           while data.closer_Vr(k+1)==data.closer_Vr(k+2)
                data.closer_Vr(k+1)=NaN;
                k=k+1;
           end
           data.closer_Vr(k+1)=NaN;
          end    
       end
   end
end

end


