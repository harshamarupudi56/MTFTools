%%Plot Material Decomposition Images 
close all
mfilename='/home/sriharsha.marupudi/TIGRE-master/MATLAB';
addpath(genpath(mfilename));
current_file = '/home/sriharsha.marupudi/Desktop/PCD/1112023';
addpath(genpath(current_file));
current_file = '/home/sriharsha.marupudi/Desktop/PCD/1112023/readingtools/';
addpath(genpath(current_file));
cd results/
%% 

load('2D_reconstruction_material_decomp_AC_25ma_2','im_low','im_high')
im_low_AC_25 = im_low; 
im_high_AC_25 = im_high;
load('2D_reconstruction_material_decomp_AC_100ma_2','im_low','im_high')
im_low_AC_100 = im_low; 
im_high_AC_100 = im_high;
load('2D_reconstruction_material_decomp_AC_200ma_2','im_low','im_high')
im_low_AC_200 = im_low; 
im_high_AC_200 = im_high;
load('2D_reconstruction_material_decomp_SP_25ma_2','im_low','im_high')
im_low_SP_25 = im_low; 
im_high_SP_25 = im_high;
load('2D_reconstruction_material_decomp_SP_100ma_2','im_low','im_high')
im_low_SP_100 = im_low; 
im_high_SP_100 = im_high;
load('2D_reconstruction_material_decomp_SP_200ma_2','im_low','im_high')
im_low_SP_200 = im_low; 
im_high_SP_200 = im_high;
%%
% AC images
figure;
filenames_AC = {'AC25', 'AC100', 'AC200'};
im_low_AC = {im_low_AC_25, im_low_AC_100, im_low_AC_200};
im_high_AC = {im_high_AC_25, im_high_AC_100, im_high_AC_200};

centerSlice = 200;

for i = 1:numel(filenames_AC)
    AC_im_low = im_low_AC{i};
    AC_im_high = im_high_AC{i};
    
    subplot(2, 3, i); 
    imagesc(AC_im_low); axis off; colormap gray; colorbar 
    title([ filenames_AC{i} ' - Low']); 
    
    subplot(2, 3, i + 3); 
    imagesc(AC_im_high); axis off; colormap gray; colorbar 
    title([ filenames_AC{i} ' - High']); 


end
set(gcf, 'WindowState', 'maximized');
saveas(gcf, ['Material_Decomposition_STC_AC_plot.png']);

%SP Images
figure;
filenames_SP = {'SP25', 'SP100', 'SP200'};
im_low_SP = {im_low_SP_25, im_low_SP_100, im_low_SP_200};
im_high_SP = {im_high_SP_25, im_high_SP_100, im_high_SP_200};

 

for i = 1:numel(filenames_SP)
    SP_im_low = im_low_SP{i};
    SP_im_high = im_high_SP{i};
    
    subplot(2, 3, i); 
    imagesc(SP_im_low); axis off; colormap gray; colorbar 
    title([ filenames_SP{i} ' - Low']); 
    
    subplot(2, 3, i + 3); 
    imagesc(SP_im_high); axis off; colormap gray; colorbar 
    title([ filenames_SP{i} ' - High']); 


end

set(gcf, 'WindowState', 'maximized');
saveas(gcf, ['Material_Decomposition_STC_SP_plot.png']);

