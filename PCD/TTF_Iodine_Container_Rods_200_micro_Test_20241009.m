close all
clear all
clc
restoredefaultpath
mfilename = '/home/sriharsha.marupudi/TIGRE-master/MATLAB';
addpath(genpath(mfilename));
mfilename = 'home/sriharsha.marupudi/Desktop/PCD/1112023/Gel_Phantom/readingtools/';
addpath(genpath(mfilename));
use_par = 1; %use parralelisation
addpath '/home/sriharsha.marupudi/Desktop/PCD/1112023'
results_file = '/home/sriharsha.marupudi/Desktop/PCD/1112023/Gel_Phantom/results/';
current_file_MTF = '/home/sriharsha.marupudi/Desktop/PCD/1112023/3DMTF/MTFTools-main/examples';
cd(current_file_MTF);
run Setup; 
current_file = '/home/sriharsha.marupudi/Desktop/PCD/1112023/' ;
addpath(genpath(current_file));
cd(current_file); 

cd Gel_Phantom/results/
load('data_Iodine_Container_15cm_Phantom_Recon_20241008',"img_low")
cd ../ 
%% Crop Image
uSize = [0.2430 0.2430 0.2430]/3; % 0.1 mm voxel size of image
figure; imagesc(img_low(:,:,125)); colormap gray; axis off; axis tight; axis equal;
img = img_low;

use_saved_coordinates = 1;  

if use_saved_coordinates == 1

    if exist('roi_coordinates_data_Iodine_Container_15cm_Phantom_Recon_Binned_20241008_ttf_2.mat', 'file')
        load('roi_coordinates_data_Iodine_Container_15cm_Phantom_Recon_Binned_20241008_ttf_2.mat', 'Co');
    else
        error('Saved coordinates file does not exist.');
    end
else
    Co = round(ginput(1));  
    save('roi_coordinates_data_Iodine_Container_15cm_Phantom_Recon_Binned_20241008_ttf_2.mat', 'Co');
end

Lx = 90; Ly = 90;
ROIx = Co(1)-Lx:Co(1)+Lx; ROIy = Co(2)-Ly:Co(2)+Ly;
img_cropped = img(ROIy, ROIx, :);
 

%% Threshold 
img = img_cropped;
th = 55; 
% th = otsuthresh(imhist(img)); %otsu method to identify threshold for segmentation 
img = img(:,:,120:130);

[uBinary] = segnd_th(img, th); % edge identification 
C = mtf.EsfCalc_CircRod('uSzScale', uSize(1:2)/uSize(1));
C.fit(uBinary);
C.showFit(img,10);
%% MTF 
iSlice = 1:10; 
thetaRg = []; % deg2rad([-180 -90]); % empty, average all directions within the axial plane
pMtf = struct('diffMethod', 'gradient', 'maxFreq', 2);
pDetrend = struct('bDebug', 1);
[esf, esfAxis] = C.apply(img, thetaRg, iSlice);
% 
winSize = 30;  % apodization 
hammingWin = hamming(winSize);
hammingWin = hammingWin / sum(hammingWin);
esf = conv(esf, hammingWin, 'same');
figure; plot(esfAxis,esf)

[mtfVal, mtfAxis] = mtf.sf2Mtf(esf, esfAxis, uSize(1), pMtf, pDetrend);

%%% visualization
figure; plot(mtfAxis, mtfVal,'-*'); 
% xlim([0 1.5*1/(2*uSize(1))]); 
xlim([0 2])
ylim([0 1]); % x axis: 1.5*Nyquist
title('MTF'); xlabel('f (cycle/mm)'); ylabel('MTF');

save('data_Iodine_Container_15cm_Phantom_Recon_Binned_20241008_ttf_2.mat', 'mtfAxis','mtfVal');

%% Plot together 
load('data_Iodine_Container_15cm_Phantom_Recon_Binned_20241008_ttf_1.mat', 'mtfAxis', 'mtfVal');
mtfAxis_1 = mtfAxis; mtfVal_1 = mtfVal;

load('data_Iodine_Container_15cm_Phantom_Recon_Binned_20241008_ttf_2.mat', 'mtfAxis', 'mtfVal');
mtfAxis_2 = mtfAxis; mtfVal_2 = mtfVal;

load('data_Iodine_Container_15cm_Phantom_Recon_Binned_20241008_ttf_3.mat', 'mtfAxis', 'mtfVal');
mtfAxis_3 = mtfAxis; mtfVal_3 = mtfVal;

load('data_Iodine_Container_15cm_Phantom_Recon_Binned_20241008_ttf_4.mat', 'mtfAxis', 'mtfVal');
mtfAxis_4 = mtfAxis; mtfVal_4 = mtfVal;

figure;
hold on;

plot(mtfAxis_1, mtfVal_1, '-*', 'DisplayName', 'Rod 10 mm 1 ', 'Color', [0 0.4470 0.7410]); % Blue
plot(mtfAxis_2, mtfVal_2, '-o', 'DisplayName', 'Rod 5 mm 2', 'Color', [0.8500 0.3250 0.0980]); % Red
plot(mtfAxis_3, mtfVal_3, '-s', 'DisplayName', 'Rod 10 mm 3', 'Color', [0.9290 0.6940 0.1250]); % Yellow
plot(mtfAxis_4, mtfVal_4, '-s', 'DisplayName', 'Rod 5 mm 4', 'Color', [0 1 0]); % Green

% Set the axis limits and labels
% ylim([0 1]);
xlabel('Spatial Frequency (cycles/mm)');
ylabel('TTF');
title('TTF for Different Inserts (Water)');
legend show;

hold off;

% cd Gel_Phantom/results/
% print(gcf, 'Iodine_Container_Rods_200_micro_Test_TTF', '-dpng', '-r300');
cd ../
% cd ../

%% f10 and f50 
load('data_Iodine_Container_15cm_Phantom_Recon_Binned_20241008_ttf_1.mat', 'mtfAxis', 'mtfVal');
mtfAxis_1 = mtfAxis; mtfVal_1 = mtfVal;

load('data_Iodine_Container_15cm_Phantom_Recon_Binned_20241008_ttf_2.mat', 'mtfAxis', 'mtfVal');
mtfAxis_2 = mtfAxis; mtfVal_2 = mtfVal;

load('data_Iodine_Container_15cm_Phantom_Recon_Binned_20241008_ttf_3.mat', 'mtfAxis', 'mtfVal');
mtfAxis_3 = mtfAxis; mtfVal_3 = mtfVal;

load('data_Iodine_Container_15cm_Phantom_Recon_Binned_20241008_ttf_4.mat', 'mtfAxis', 'mtfVal');
mtfAxis_4 = mtfAxis; mtfVal_4 = mtfVal;


f10_values = [];
f50_values = [];

xQuery = linspace(0, max([mtfAxis_1, mtfAxis_2, mtfAxis_3, mtfAxis_4]), 1000);

calculate_f_values = @(mtfAxis, mtfVal) struct(...
    'f10', interp1(mtfVal, mtfAxis, 0.1, 'linear', 'extrap'), ...
    'f50', interp1(mtfVal, mtfAxis, 0.5, 'linear', 'extrap'));

f_10_50_1 = calculate_f_values(mtfAxis_1, mtfVal_1);
f_10_50_2 = calculate_f_values(mtfAxis_2, mtfVal_2);
f_10_50_3 = calculate_f_values(mtfAxis_3, mtfVal_3);
f_10_50_4 = calculate_f_values(mtfAxis_4, mtfVal_4);

f10_values = [f10_values; f_10_50_1.f10, f_10_50_2.f10, f_10_50_3.f10, f_10_50_4.f10];
f50_values = [f50_values; f_10_50_1.f50, f_10_50_2.f50, f_10_50_3.f50, f_10_50_4.f50];

figure;
hold on;

plot(mtfAxis_1, mtfVal_1, '-*', 'DisplayName', 'Rod 10 mm 1 ', 'Color', [0 0.4470 0.7410]); % Blue
plot(mtfAxis_2, mtfVal_2, '-o', 'DisplayName', 'Rod 5 mm 2', 'Color', [0.8500 0.3250 0.0980]); % Red
plot(mtfAxis_3, mtfVal_3, '-s', 'DisplayName', 'Rod 10 mm 3', 'Color', [0.9290 0.6940 0.1250]); % Yellow
plot(mtfAxis_4, mtfVal_4, '-s', 'DisplayName', 'Rod 5 mm 4', 'Color', [0 1 0]); % Green

x_limits = xlim;
plot(x_limits, [0.1, 0.1], '--k', 'LineWidth', 1.5, 'DisplayName', 'TTF = 0.1 (f_{10})');
plot(x_limits, [0.5, 0.5], '--r', 'LineWidth', 1.5, 'DisplayName', 'TTF = 0.5 (f_{50})');


% Set the axis limits and labels
ylim([0 1]);
xlabel('Spatial Frequency (cycles/mm)');
ylabel('TFF');
title('TTF for Different Water Inserts with f_{10} and f_{50}');
legend show;

hold off;

fprintf('f_{10} values:\n');
fprintf('  Rod 10 mm 1: %.3f cycle/mm\n', f_10_50_1.f10);
fprintf('  Rod 5 mm 2: %.3f cycle/mm\n', f_10_50_2.f10);
fprintf('  Rod 10 mm 3: %.3f cycle/mm\n', f_10_50_3.f10);
fprintf('  Rod 5 mm 4: %.3f cycle/mm\n', f_10_50_4.f10);

fprintf('\nf_{50} values:\n');
fprintf('  Rod 10 mm 1: %.3f cycle/mm\n', f_10_50_1.f50);
fprintf('  Rod 5 mm 2: %.3f cycle/mm\n', f_10_50_2.f50);
fprintf('  Rod 10 mm 3: %.3f cycle/mm\n', f_10_50_3.f50);
fprintf('  Rod 5 mm 4: %.3f cycle/mm\n', f_10_50_4.f50);

