close all;
clear U;

current_file_MTF = '/home/sriharsha.marupudi/Desktop/PCD/1112023/3DMTF/MTFTools-main/examples';
cd(current_file_MTF);
run Setup

results_file = '/home/sriharsha.marupudi/Desktop/PCD/1112023/3DMTF/results';

cd(results_file);

% Load previously saved coordinates if available
coordinates_file = 'sphere_coordinates_SP200_high_20240131_1_new.mat';
uSize = [0.3 0.3 0.3]/3; % 1 mm 1`
 

if exist(coordinates_file, 'file')
    load(coordinates_file, 'U');
else
    % Load image data
    load('data_SP200_20240131', 'img_low', 'img_hig');
    % Image = img_low_binned;
    Image = img_hig;


    for iu = 1:5
        is = round(size(Image,3)*0.5); % get the central slice
        figure(1);
        tt = sprintf('Sphere #%d', iu);
        imagesc(Image(:,:,is)); axis off; axis tight; axis equal;
        title(tt);
        M = round(ginput(1));
        x = M(1); y = M(2);
        ROI_size = round(15/uSize(1));
        roix = x-ROI_size:x+ROI_size;
        roiy = y-ROI_size:y+ROI_size;
        U(iu,:,:,:) = Image(roiy,roix,:);
    end

    % Save coordinates
    cd(results_file);
    save(coordinates_file, 'U');
    cd ../


end 
%%
close all
for iu = 1:5

    % segment
    u(:,:,:) = U(iu,:,:,:);

    th = 50;
    [uBinary] = segnd_th(u, th);
    C = mtf.EsfCalc_Sphere('uSzScale', uSize(1:3)/uSize(1), 'pPath', './datasets/FitPara_Sphere_Filter11_Cios.mat');
    C.fit(uBinary);

   
    pMtf = struct('diffMethod', 'gradient', 'maxFreq', 3);
    pDetrend = struct('bDebug', 0);
    
    coneAngs = linspace(0, 45, 3); % different measurement angle \phi
    legends = arrayfun(@(x) ['Cone Angle (\phi): ', num2str(x)], coneAngs, 'uni', 0);
    figure; 
    hold on
    %subplot(5,1,iu)
    hold on;
    for i = 1:length(coneAngs)
      % (\phi = coneAngs(i) degree; \phi_b = 5 degree, see our paper for definitions)
      pApply = {'coneRg', coneAngs(i) + [-5 5], 'thetaRg', [-pi pi]};
      [esf, esfAxis] = C.apply(u, pApply{:});
      [mtfVal, mtfAxis] = mtf.sf2Mtf(esf, esfAxis, uSize(1), pMtf, pDetrend);
      plot(mtfAxis, mtfVal,'-*'); 
    end
    xlim([0 1.5*1/(2*uSize(1))]); ylim([0 1]); % x axis: 1.5*Nyquist
    xlabel('f (cycle/mm)'); ylabel('MTF');
    legend(legends,'location','best');
    filename = sprintf('MTF_High_SP_200_%d_20240131_1.png', iu);  
    cd(results_file)
    cd MTF_Figs
    print(gcf, filename, '-dpng', '-r300');
    cd ../

    tt = sprintf('Sphere #%d',iu)
    title(tt)
end

