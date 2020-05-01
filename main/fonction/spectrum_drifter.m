function [f,P1,F_maxheures] = spectrum_drifter(drifter,data,Const)
%spectrum
if data.name =='m'
    drifter.i_notNaN=not(isnan(drifter.U));
    drifter.Unotnan=drifter.U(drifter.i_notNaN);
    Y = fft(drifter.Unotnan);
    L=length(drifter.Unotnan);
    P2 = abs(Y/L);
    P1 = P2(1:fix(L/2)+1);
    P1(2:end-1) = 2*P1(2:end-1);

    T=(drifter.time(1)-drifter.time(end))/length(drifter.time); % in day  
    Fs=1/T;
    f = Fs*(0:(L/2))/L;
    i_Max= find(P1(2:end)==max(P1(2:end)));
    F_max=f(i_Max+1);
    F_maxheures=F_max*Const.d2h;
end

if data.name =='r'
    
    Y = fft(drifter.Vr_filter2);
    L=length(drifter.Vr_filter2);
    P2 = abs(Y/L);
    P1 = P2(1:fix(L/2)+1);
    P1(2:end-1) = 2*P1(2:end-1);

    T=(drifter.time_drifter2(1)-drifter.time_drifter2(end))/length(drifter.time_drifter2); % in day  
    Fs=1/T;
    f = Fs*(0:(L/2))/L;
    i_Max= P1 ==max(P1(4:end));
    F_max=f(i_Max);
    F_maxheures=F_max*Const.d2h;
end
end

