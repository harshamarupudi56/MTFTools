% % 3D MTF from 3D sphere object
% % This script loads in a 3D volume dataset of a sphere and calculates the MTF along a particular direction (see `pApply` parameter below)
% current_file_MTF = '/storage/2023/benchtop/Harsha/3DMTF/MTFTools-main/examples'
% cd (current_file_MTF)
% close all
% %clear all
% %run Setup
% current_file_MTF = '/storage/2023/benchtop/Harsha/3DMTF/MTFTools-main/examples'
% 
% %% load data
% [u,uSize] = io.multLoadMat('./datasets/Sphere_Filter11_Cios.mat','u','uSize');
% th = 0.015;
%%
data_here = 1
if (data_here)
    
    % results_file = '/storage/2023/benchtop/Harsha/3DMTF/results';
    % cd (results_file)
    % %load('data_SP100_binned',"img_low_binned","img_hig_binned")
    % cd (current_file_MTF)
    % Image = img_low;

    uSize = [0.3 0.3 0.3]/3; % 1 mm

    % select ROI:
    is = round(size(Image,3)*0.5); % get the central slice
    figure
    imagesc(Image(:,:,is))  ; axis off; axis tight; axis equal
    M = round(ginput(1));
    %x = M(:,1); y = M(:,2);
    
    x = M(1); y = M(2);
    %eval(sprintf('u%d = Image(y(1):y(2),x(1):x(2),:)',iu));
    ROI_size = round(20/uSize(1));
    roix = x-ROI_size:x+ROI_size;
    roiy = y-ROI_size:y+ROI_size;

    close
    
    u = Image(roiy,roix,:);
    %u = img_low_binned(y(1):y(2),x(1):x(2),:);
    u(u<0) = 0;
    figure
    is = round(size(u,3)*0.5); % get the central slice
    imagesc(u(:,:,is))  ; axis off; axis tight; axis equal
    %close
    th = 50;
end
%%
% data_here = 0
% if (data_here)
%     results_file = '/storage/2023/benchtop/Harsha/3DMTF/results';
%     cd (results_file)
%     load('data_AC25',"img_low","img_hig")
%     cd (current_file_MTF)
% 
%     % select ROI:
%     is = round(size(img_low,3)*0.5); % get the central slice
%     figure
%     imagesc(img_low(:,:,is))  ; axis off; axis tight; axis equal
%     M = round(ginput(2));
%     x = M(:,1); y = M(:,2);
% 
%     close
% 
%     u = img_low(y(1):y(2),x(1):x(2),:);
%     u(u<th) = 0;
%     figure
%     imagesc(u(:,:,is))  ; axis off; axis tight; axis equal
%     close
%     uSize = [0.3 0.3 0.3]/3; % 0.1 mm
%     th = 50;
% end
%%
figure
for i = 1:size(u,3)
    imagesc(u(:,:,i))  ; axis off; axis tight; axis equal
    title(sprintf('slice# %d',i))
    pause(0.1)
end

%% determine fit parameters and save
% segmentation
[uBinary] = segnd_th(u, th);

% sphere fit
C = mtf.EsfCalc_Sphere('uSzScale', uSize(1:3)/uSize(1), 'pPath', './datasets/FitPara_Sphere_Filter11_Cios.mat');
C.fit(uBinary);
% display 10 (slices equally spaced from top to bottom) example sphere fit results
% slices that do not contain a sphere will be omitted
% sphere contour/edge will be shown in yellow
C.showFit(u, th); 


%% MTF calculation
pMtf = struct('diffMethod', 'gradient', 'maxFreq', 2); % define the numerical differentiation method and max frequency (unit: Nyquist)
pDetrend = struct('bDebug', 1); % enable debug mode for lsf detrending (also window/center) method

% uncomment one option below (for a particular direction)
% axial 
%pApply = {'iSlice', -1:1, 'thetaRg', [-pi pi]}; % use for axial MTF
pApply = {'coneRg', 0 + [-5 5], 'thetaRg', [-pi pi]};
% cone 45 degree (\phi = 45 degree; \phi_b = 5 degree, see our paper for definitions)
%pApply = {'coneRg', [40 50], 'thetaRg', [-pi pi]}; % use for MTF(phi = 45 deg)
% z (approximate) direction (\phi = 82.5 degree; \phi_b = 2.5 degree, see our paper for definitions)
% pApply = {'coneRg', [80 85], 'thetaRg', [-pi pi]}; % use for MTF(phi = 82.5 deg)(close to z, but avoids null-cone)


[esf, esfAxis] = C.apply(u, pApply{:}); % calculate ESF
[mtfVal, mtfAxis] = mtf.sf2Mtf(esf, esfAxis, uSize(1), pMtf, pDetrend); % calculate MTF

%%% visualization
figure; plot(mtfAxis, mtfVal,'-*'); 
xlim([0 1.5*1/(2*uSize(1))]); ylim([0 1]); % x axis: 1.5*Nyquist
title('MTF'); xlabel('f (cycle/mm)'); ylabel('MTF');


%% MTF calculation (multiple realization / errorbar)
nBin = 5; % number of realizations
pDetrend.bDebug = 0; % disable debug mode for lsf detrending (also window/center) method
[esfCel, esfAxisCel] = C.applyMult(nBin, u, pApply{:}); % compute the ESF from multiple realizations
[mtfVal, mtfAxis, ~, mtfError] = mtf.sf2Mtf_mult(esfCel, esfAxisCel, uSize(1), pMtf, pDetrend); % calculate MTF for each ESF realization

%%% visualization
figure; errorbar(mtfAxis, mtfVal, mtfError, '-*'); 
xlim([0 1.5*1/(2*uSize(1))]); ylim([0 1]); 
title('MTF (with errorbar)'); xlabel('f (cycle/mm)'); ylabel('MTF');

