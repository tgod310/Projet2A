function [drifter] = filter_spike(drifter,data)
%filter spikes over 20 cm/s

for i=1:length(drifter.U)
    if i==1 
        if abs(drifter.U(i)-drifter.U(i+1))> 0.2
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
    elseif i==length(drifter.U) 
        if abs(drifter.U(i)-drifter.U(i-1))> 0.2
            drifter.U(i)=NaN;
        end
         if abs(drifter.V(i)-drifter.V(i-1))> 0.2
            drifter.V(i)=NaN;
         end
         if data.name=='r'
            if abs(drifter.Vr(i)-drifter.Vr(i-1))> 0.2
            drifter.Vr(i)=NaN;
            end
         end   
    else
        if abs(drifter.U(i)-drifter.U(i-1))> 0.2 || abs(drifter.U(i)-drifter.U(i+1))> 0.2
         drifter.U(i)=NaN;
        end
         if abs(drifter.V(i)-drifter.V(i-1))> 0.2 || abs(drifter.V(i)-drifter.V(i+1))> 0.2
         drifter.V(i)=NaN;
         end
         if data.name=='r'
            if abs(drifter.Vr(i)-drifter.Vr(i-1))> 0.2 || abs(drifter.Vr(i)-drifter.Vr(i+1))> 0.2
            drifter.Vr(i)=NaN;
            end
         end
    end
end

end


