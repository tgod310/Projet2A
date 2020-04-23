function [f,P1,F_maxheures] = spectre_drifter(drifter)
%spectre

    Y = fft(drifter.U);
    L=length(drifter.U);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);

    T=(drifter.time(1)-drifter.time(end))/length(drifter.time); % in day  
    Fs=1/T;
    f = Fs*(0:(L/2))/L;
    i_Max= find(P1(2:end)==max(P1(2:end)));
    F_max=f(i_Max+1);
    F_maxheures=F_max*24;


end

