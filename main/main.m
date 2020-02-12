%% -- MAIN -- %%

%% Initialisation
% Nettoyage des donnees
clear;close all;clc;

% Ajout du chemin des donnees etudiees
addpath('../../','../../NEMO','../../WERA','../../drifter/round1','../../drifter/round2');
% Ajout du chemin des fonctions
addpath('fonction')

% Origine des temps
time_origin='2010-01-01 00:00:00';

%% Début du programme

radar=read_RADAR('20190300001_20191002301_PEY_L1.nc');
model=read_MODEL('1_NIDOR_20190511_20190524_grid_U.nc','1_NIDOR_20190511_20190524_grid_V.nc');




