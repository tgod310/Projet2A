function [ drifter_name ] = drifter_list( PATH_ORI )
% MARMAIN 
% 2012/08/07
%   To create a list of drifter nc file 
%   INPUT:  PATH_ORI: where the files are stored
%           
%   OUTPUT: drifter_name.long: the list of file with full path
%           drifter_name.short: the list of short name (without path)


flist=dir([PATH_ORI '/*.xlsx']);

for i=1:size(flist,1);
        
        drifter_name.long(i,:)=fullfile(PATH_ORI,flist(i,1).name);

        drifter_name.short(i,:)=flist(i,1).name;

end



end

