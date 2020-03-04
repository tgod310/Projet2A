function data_drifter = read_DRIFTER(name_file)
% read_MODEL permet de lire et ouvrir les fichiers netcdf de données de modeles.

opts = detectImportOptions(name_file);
dd = readmatrix(name_file);
data_drifter.ref = datenum(;

end

