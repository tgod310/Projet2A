function [f,P1,T_maxheures] = spectrum_drifter(drifter,data,Const)
%spectrum
if data.name =='m'
    
    
    Y = fft(drifter.U_filter2);
    L=length(drifter.U_filter2);
    P2 = abs(Y/L);
    P1 = P2(1:fix(L/2)+1);
    P1(2:end-1) = 2*P1(2:end-1);

    T=(drifter.time_drifter2(1)-drifter.time_drifter2(end))/length(drifter.time_drifter2); % in day   
    Fs=1/T;
    f = Fs*(0:(L/2))/L;
    i_Max= P1 ==max(P1(4:end));
    F_max=f(i_Max);
    T_maxheures=Const.d2h/F_max;
    
    
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
    T_maxheures=Const.d2h/F_max;
end
end

