function tracecotes


% xlim=[5.2 10.06]; 
% ylim=[41.0 44.5];
% 
% xlim=[5.2 8]; 
% ylim=[41.0 43];



%% part 1
lonmin=4.5
lonmax=10.0
latmin=41.5
latmax=44.5
xlim=[lonmin lonmax]; 
ylim=[latmin latmax];

%% part 2
% lonmin=5.5
% lonmax=6.5
% latmin=42.5
% latmax=43.5
% xlim=[lonmin lonmax]; 
% ylim=[latmin latmax];

%%
% lonmin=5
% lonmax=8.0
% latmin=41.5
% latmax=44
% xlim=[lonmin lonmax]; 
% ylim=[latmin latmax];


%% 

% lecture des cotes
cotes=load('27154.dat');
xloncot=cotes(:,1); 
ylatcot=cotes(:,2);

xlabel('longitude'); 
ylabel('latitude');

% trace des cotes

lwc=1.5;
h0=plot(xloncot,ylatcot,'k');
set(h0,'linewidth',lwc);

axis([xlim ylim]);

end