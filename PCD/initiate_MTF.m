close all
clc
%read_data = 1; % put zeros if not
mfilename = '/home/sriharsha.marupudi/TIGRE-master/MATLAB';
addpath(genpath(mfilename));
current_file = '/home/sriharsha.marupudi/Desktop/PCD/1112023/3DMTF/' ;
addpath(genpath(current_file));
use_par = 1; %use parralelisation
use_par = 1; %use parralelisation

STC_file = '/home/sriharsha.marupudi/Desktop/PCD/1112023/STC/data/';

%%

%-2- Detector parameter
E          = [15       33] ; % Energy threshold in kev
pixel_size = 100           ; % pixel size in um


y1 = 580; y2 = 2617;
x1 = 166-60; x2 = 370+40 ;
center = [0.5*(x1+x2) 0.5*(y1+y2)];
roix   = x1:x2;
roiy   = y1:y2; 
center0        = 0.5*[513     3115]; % center for cropping (y,x)\
%center0        = [255     1557];
delta_c        = center0 - center;


% center0     = [255     1557]; % center for cropping (y,x)\
% width      = [45*2 1137*2]; % center for cropping (y,x)
% roix       = center(1)-width(1)/2:center(1)+width(1)/2 ;
% roiy       = center(2)-width(2)/2:center(2)+width(2)/2 ;

geo.nDetector=[length(roiy); length(roix)];

%-3- aquisitions
angles  = 0:1:360-1             ;
nb_proj = length(angles)        ; %nb of prejections 
angles  =-angles*(pi/180)       ; %% Bahaa's modification



