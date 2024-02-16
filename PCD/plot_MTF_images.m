mfilename = '/home/sriharsha.marupudi/TIGRE-master/MATLAB';
addpath(genpath(mfilename));
current_file = '/home/sriharsha.marupudi/Desktop/PCD/1112023/3DMTF/' ;
addpath(genpath(current_file));
mfilename = 'home/sriharsha.marupudi/Desktop/PCD/1112023/3DMTF/readingtools/';
addpath(genpath(mfilename));
use_par = 1; %use parralelisation
%% 

load('data_AC25.mat','img_low','img_hig')
img_low_AC_25 = img_low; 
img_hig_AC_25 = img_hig;
load('data_AC100.mat','img_low','img_hig')
img_low_AC_100 = img_low; 
img_hig_AC_100 = img_hig;
load('data_AC200.mat','img_low','img_hig')
img_low_AC_200 = img_low; 
img_hig_AC_200 = img_hig;
load('data_SP25.mat','img_low','img_hig')
img_low_SP_25 = img_low; 
img_hig_SP_25 = img_hig;
load('data_SP100.mat','img_low','img_hig')
img_low_SP_100 = img_low; 
img_hig_SP_100 = img_hig;
load('data_SP200.mat','img_low','img_hig')
img_low_SP_200 = img_low; 
img_hig_SP_200 = img_hig;



%% AC images
% Creating a figure for AC images
figure;
filenames_AC = {'AC25', 'AC100', 'AC200'};
img_low_AC = {img_low_AC_25, img_low_AC_100, img_low_AC_200};
img_hig_AC = {img_hig_AC_25, img_hig_AC_100, img_hig_AC_200};

for i = 1:numel(filenames_AC)
    AC_img_low = img_low_AC{i};
    AC_img_hig = img_hig_AC{i};
    
    centerSlice = round(size(AC_img_low, 3) / 2);
    
    subplot(2, 3, i); 
    imagesc(AC_img_low(:, :, centerSlice)); axis off; colormap gray; colorbar 
    title([ filenames_AC{i} ' - Low']); 
    
    subplot(2, 3, i + 3); 
    imagesc(AC_img_hig(:, :, centerSlice)); axis off; colormap gray; colorbar 
    title([ filenames_AC{i} ' - High']); 

    cd(results_file)
    set(gcf, 'WindowState', 'maximized');
    print(gcf, 'MTF_AC_Image.png', '-dpng', '-r300');
    cd ../
end

%SP Images 
figure;
filenames_SP = {'SP25', 'SP100', 'SP200'};
img_low_SP = {img_low_SP_25, img_low_SP_100, img_low_SP_200};
img_hig_SP = {img_hig_SP_25, img_hig_SP_100, img_hig_SP_200};

for i = 1:numel(filenames_SP)
    SP_img_low = img_low_SP{i};
    SP_img_hig = img_hig_SP{i};
    
    
    centerSlice = round(size(SP_img_low, 3) / 2);
    
    
    subplot(2, 3, i); 
    imagesc(SP_img_low(:, :, centerSlice)); axis off; colormap gray; colorbar 
    title([ filenames_SP{i} ' - Low']); 
    
    
    subplot(2, 3, i + 3); 
    imagesc(SP_img_hig(:, :, centerSlice)); axis off; colormap gray; colorbar 
    title([filenames_SP{i} ' - High']);
    cd(results_file)
    set(gcf, 'WindowState', 'maximized');
    print(gcf, 'MTF_SP_Image.png', '-dpng', '-r300');
    cd ../
end

