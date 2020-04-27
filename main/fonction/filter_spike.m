function [drifter,data] = filter_spike(drifter,data)
%filter spikes over 20 cm/s
  ignore = isnan(drifter.Vr) == 1;
         drifter.Vrnotnan = drifter.Vr;
         drifter.Vrnotnan(ignore ~= 0)=[];
         
       Mean = mean(drifter.Vrnotnan);
       for m=1:length(drifter.Vr)
            if drifter.Vr(m)> Mean + 3 || drifter.Vr(m)< Mean -3
                drifter.Vr(m)=NaN ;
            end
       end
for i=1:length(drifter.U)-1
    
        if  abs(drifter.U(i)-drifter.U(i+1))> 0.2
         drifter.U(i+1)=NaN;
        end
         if abs(drifter.V(i)-drifter.V(i+1))> 0.2
         drifter.V(i+1)=NaN;
         end
       
       
         if isnan(drifter.Vr(i))==0  % if it is a number 
              if abs(drifter.Vr(i)-drifter.Vr(i+1))> 0.2 
                   b=i;
                   while abs(drifter.Vr(b)-drifter.Vr(i+1))> 0.2 && i<length(drifter.Vr)-1
                   if abs(drifter.Vr(i+1)-drifter.Vr(i+2))< abs(drifter.Vr(i)-drifter.Vr(i+1))
                       drifter.Vr(i)=NaN;
                       b=b+1;
                   else 
                       drifter.Vr(i+1)=NaN;
                   i=i+1;
                   end

              end
             
         end
         
         if isnan(drifter.Vr(i))==1 % if it is a NaN 
            if i>1
                if abs(drifter.Vr(i-1)-drifter.Vr(i+1))> 0.2 
                    b=i-1;
                    while abs(drifter.Vr(b)-drifter.Vr(i+1))> 0.2 && i<length(drifter.Vr)-1
                        drifter.Vr(i+1)=NaN;
                        i=i+1;
                    end
               
                end
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


