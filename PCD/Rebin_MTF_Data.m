close all;
clear U;

current_file_MTF = '/home/sriharsha.marupudi/Desktop/PCD/1112023/3DMTF/MTFTools-main/examples';
cd(current_file_MTF);
run Setup

results_file = '/home/sriharsha.marupudi/Desktop/PCD/1112023/3DMTF/results';

cd(results_file);
load('data_AC25_20240131', 'img_low', 'img_hig');
current_file = '/home/sriharsha.marupudi/Desktop/PCD/1112023';
cd(current_file)
img_low = img_low;
img_hig = img_hig; 

%%
factor = [2,2,2]; 
img_low_binned_rebin_3d_2 = rebin_3d(img_low, factor);
img_hig_binned_rebin_3d_2 = rebin_3d(img_hig, factor);

cd results/
save('data_AC25_20240131_rebin2',"img_low_binned_rebin_3d_2","img_hig_binned_rebin_3d_2",'-v7.3')
cd ../
disp('done saving')

%%
factor = [4,4,4]; 
img_low_binned_rebin_3d_4 = rebin_3d(img_low, factor);
img_hig_binned_rebin_3d_4 = rebin_3d(img_hig, factor);

cd results/
save('data_AC25_20240131_rebin4',"img_low_binned_rebin_3d_4","img_hig_binned_rebin_3d_4",'-v7.3')
cd ../
disp('done saving')



%%
is_center_2 = round(size(img_hig_binned_rebin_3d_2, 3) / 2);

figure(1)

subplot(1,3,1)
imagesc(img_low(:,:,is_center_2))  ; axis off; axis tight; axis equal; colormap gray
title('Original Low Image')

subplot(1,3,2)
imagesc(img_low_binned_rebin_3d_2(:,:,is_center_2))  ; axis off; axis tight; axis equal; colormap gray
title('Binned Low Image')

subplot(1,3,3)
imagesc(img_hig_binned_rebin_3d_2(:,:,is_center_2))  ; axis off; axis tight; axis equal; colormap gray
title('Binned High Image')

is_center_4 = round(size(img_hig_binned_rebin_3d_4, 3) / 2);

cd results/
print(gcf, 'AC25_20240131_Binned_2x2.png', '-dpng', '-r300')
cd ../
disp('done saving')
%%
% Plotting for binning factor [4,4,4]
figure(2)

subplot(1,3,1)
imagesc(img_low(:,:,is_center_4))  ; axis off; axis tight; axis equal; colormap gray
title('Original Low Image')

subplot(1,3,2)
imagesc(img_low_binned_rebin_3d_4(:,:,is_center_4))  ; axis off; axis tight; axis equal; colormap gray
title('Binned Low Image')

subplot(1,3,3)
imagesc(img_hig_binned_rebin_3d_4(:,:,is_center_4))  ; axis off; axis tight; axis equal; colormap gray
title('Binned High Image')

cd results/
print(gcf, 'AC25_20240131_Binned_4x4.png', '-dpng', '-r300')
cd ../
disp('done saving')


% figure;
% plot(img_low, 'b', 'LineWidth', 2);
% hold on;
% plot(img_low_binned_rebin_3d_4, 'r', 'LineWidth', 2);
% legend('Original', 'Binned');
% title('Intensity Profile Comparison');
% xlabel('Pixel Position');
% ylabel('Intensity');
% 
% 
% 
% figure;
% plot(img_low, 'b', 'LineWidth', 2);
% hold on;
% plot(img_low_binned_rebin_3d_2, 'r', 'LineWidth', 2);
% legend('Original', 'Binned');
% title('Intensity Profile Comparison');
% xlabel('Pixel Position');
% ylabel('Intensity');
