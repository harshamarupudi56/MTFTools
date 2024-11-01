%% Load images 
close all;
clear U;
current_file_MTF = '/home/sriharsha.marupudi/Desktop/PCD/1112023/3DMTF/MTFTools-main/examples';
cd(current_file_MTF);
run Setup;

file = '/home/sriharsha.marupudi/Desktop/PCD/1112023/3DMTF/';
cd(file);
results_file = '/gpfs_projects/sriharsha.marupudi/PCD/Harsha/2024/February/2D_MTF_20240223/AC/Edge/200mA/above_33_keV_AC.tif'; % raw projection phantom 
results_file_open = '/gpfs_projects/sriharsha.marupudi/PCD/Harsha/2024/February/2D_MTF_20240223/AC/Open_Beam/200mA/above_33_keV_AC.tif'; %open beam  
results_file_pmma = '/gpfs_projects/sriharsha.marupudi/PCD/Harsha/2024/February/2D_MTF_20240223/AC/Open_Beam_PMMA/200mA/above_33_keV_AC.tif'; %open beam  
addpath('/home/sriharsha.marupudi/Desktop/PCD/1112023')
bpc = 1; % if 1 bad pixel correction 
crop = 1; % if 1 load image coordinates to compute ROI  
%% Load images 
img = double(tiffreadVolume(results_file)); % phantom 
img = average_frames(img,1,10); 

image_o = double(tiffreadVolume(results_file_open));% open beam 
image_o = average_frames(image_o,1,10); 

img_pmma = double(tiffreadVolume(results_file_pmma));% open beam pmma 
img_pmma = average_frames(img_pmma,1,10); 

%% Crop image 
imgSize = [0.3 0.3 0.3]/3; % 0.1 mm voxel size of image 
if crop == 1  % Load ROI coordinates 
    load('roi_coordinates_2D_MTF_200mA_high_1.mat', 'Co');

    % Define the ROI based on the loaded coordinates
    Lx = 80; Ly = 100;
    ROIx = Co(1)-Lx:Co(1)+Lx; 
    ROIy = Co(2)-Ly:Co(2)+Ly;
else
    % Select coordinates for ROI interactively 
    imshow(img, [min(img(:)), max(img(:))]);
    title('Select a rectangular region of interest');
   
    Co = round(ginput(1));
    Lx = 80; Ly = 100;
    ROIx = Co(1)-Lx:Co(1)+Lx; 
    ROIy = Co(2)-Ly:Co(2)+Ly;
end

% Crop the images
img_cropped = img(ROIy,ROIx);

% figure; 
% imshow(img_cropped, [min(img_cropped(:)), max(img_cropped(:))]);

% Save the ROI coordinates
save('roi_coordinates_2D_MTF_200mA_high_1.mat', 'Co');
img_o = image_o(ROIy,ROIx);                  


%% flat field correction 
img_o = mean(img_o,3);                         
% img = real((double(img_cropped) ./ img_o));
img = real(img_cropped./img_o); 
% imagesc(img); 

%% Bad pixel map correction 
if bpc ==1 
    % load PMMA 
    bad_pixel_map = img_pmma; 
    bad_pixel_map = bad_pixel_map(ROIy,ROIx,1);
    th = 1.3;
    % threshold for finding bad pixels 
    bad_pixel_map = get_bad_pixel_map_20240229(bad_pixel_map,th);
    figure;imagesc(bad_pixel_map); colormap gray 
    img = correct_images(img,bad_pixel_map);
    % figure;imagesc(img); colormap gray
end 
%% Apply edge rotation make image vertical 
angle = -90;  
img = imrotate(img,angle);

% Plot the rotated image
% figure;
% imshow(img, []);
% title('Rotated Edge Image');

%% Determine fit parameters and get edge 

thresh = otsuthresh(imhist(img)); %otsu method to identify threshold for segmentation 
[uBinary] = segnd_th(img, thresh); % edge identification 

% line fit for each-slice (force constant phase shift)
C = mtf.EsfCalc_Plane('uSzScale', imgSize(1:2)/imgSize(2));
C.fit(uBinary);
C.showFit(img, 3);

%% MTF calculation
pMtf = struct('diffMethod', 'gradient', 'maxFreq', 6);
pDetrend = struct('bDebug', 1, 'primaryLength', 8, 'marginLength', 16);
[esf, esfAxis] = C.apply(img);

% % %Hamming window, denoise esf 
winSize = 30; 
hammingWin = hamming(winSize);
hammingWin = hammingWin / sum(hammingWin);
esf = conv(esf, hammingWin, 'same');

%%

figure; plot(esfAxis, esf, '*','MarkerSize',1); 
% title('ESF 200 mA AC mode high Energy','FontSize',14); 
xlabel('# Pixel','FontSize',16); ylabel('Value','FontSize',16);
cd 2D_MTF_Curves/ 
print(gcf, '2D_ESF_200mA_high_AC_1', '-dpng', '-r300');
save('2D_ESF_200mA_high_AC_1.mat', 'esf','esfAxis');
cd ../

[mtfVal, mtfAxis] = mtf.sf2Mtf(esf, esfAxis, imgSize(1), pMtf, pDetrend);
figure; plot(mtfAxis, mtfVal,'-*'); 
xlim([0 1.5*1/(2*imgSize(1))]); ylim([0 1]); % x axis: 1.5*Nyquist
title('MTF'); xlabel('Frequency (cycle/mm)'); ylabel('MTF');

filename = sprintf('MTF_AC_200_high_1.png');  
cd 2D_MTF_Curves/ 
print(gcf, filename, '-dpng', '-r300');
save('2D_MTF_200mA_high_AC_1.mat', 'mtfVal','mtfAxis','bad_pixel_map','img');
cd ../