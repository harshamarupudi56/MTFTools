% kernel = ones(3,3,3)/27;
% img_low_binned = conv(img_low,kernel,'same')      
% img_hig_binned = conv(img_hig,kernel,'same')     
% cd results/
% % save('data_AC200_binned',"img_low_binned","img_hig_binned",'-v7.3')
% cd ../
% disp('done binning')
% 
% figure(5)
%     for is = 1:size(img_low_binned,3); %is  = round(size(img_low,3)/2) ;% 100:160
%         subplot(1,2,1)
%         imagesc(img_low(:,:,is))  ; axis off; axis tight; axis equal; colormap gray
%         s = sprintf('Low %d slice',is)
%         title(s)
%         subplot(1,2,2)
%         imagesc(img_hig_binned(:,:,is))  ; axis off; axis tight; axis equal; colormap gray
%         s = sprintf('High %d slice',is)
%         title(s)
%         pause(0.1)
%     end
% 
% 
% kernel = ones(3,3,3)/27;
% img_low_binned =  rebin_3d(img_low,factor);
% img_hig_binned = rebin_3d(img_hig,factor);
% cd results/
% % save('data_AC200_binned',"img_low_binned","img_hig_binned",'-v7.3')
% cd ../
% disp('done binning')
% 
% figure(5)
%     for is = 1:size(img_low_binned,3); %is  = round(size(img_low,3)/2) ;% 100:160
%         subplot(1,2,1)
%         imagesc(img_low(:,:,is))  ; axis off; axis tight; axis equal; colormap gray
%         s = sprintf('Low %d slice',is)
%         title(s)
%         subplot(1,2,2)
%         imagesc(img_hig_binned(:,:,is))  ; axis off; axis tight; axis equal; colormap gray
%         s = sprintf('High %d slice',is)
%         title(s)
%         pause(0.1)
%     end


% factor = [0.3 0.3 0.3]'./(0.1);
% factor = factor';
% 
% % Binning using imfilter
% kernel = ones(3, 3)/9;
% img_low_binned_imfilter = imfilter(img_low, kernel, 'same');
% img_hig_binned_imfilter = imfilter(img_hig, kernel, 'same');
% 
% 
% % Binning using convn with a 3D kernel
% kernel = ones(3, 3, 3) / 27;
% img_low_binned = convn(img_low, kernel, 'same');
% img_hig_binned = convn(img_hig, kernel, 'same');
% 
% 
% % Binning using rebin_3d function
% img_low_binned_rebin_3d = rebin_3d(img_low, factor);
% img_hig_binned_rebin_3d = rebin_3d(img_hig, factor);
% 
% 
% % Plot original img_low
% figure;
% subplot(1, 4, 1);
% imagesc(img_low(:, :, round(size(img_low, 3)/2)));
% axis off; axis tight; axis equal; colormap gray;
% title('Original img\_low');
% 
% % Plot binned versions of img_low
% methods = {'imfilter', 'convn', 'rebin_3d'};
% for methodIdx = 1:numel(methods)
%     method = methods{methodIdx};
%     switch method
%         case 'imfilter'
%             kernel = ones(3, 3)/9;
%             img_low_binned = imfilter(img_low, kernel, 'same');
%         case 'convn'
%             kernel = ones(3, 3, 3) / 27;
%             img_low_binned = convn(img_low, kernel, 'same');
%         case 'rebin_3d'
%             factor = [0.3 0.3 0.3]'./(0.1);
%             factor = factor';
%             img_low_binned = rebin_3d(img_low, factor);
%     end
% 
%     subplot(1, 4, methodIdx + 1);
%     imagesc(img_low_binned(:, :, round(size(img_low_binned, 3)/2)));
%     axis off; axis tight; axis equal; colormap gray;
%     title(['Binned img\_low (' method ')']);
% end
% 
% % Plot original img_hig
% figure;
% subplot(1, 4, 1);
% imagesc(img_hig(:, :, round(size(img_hig, 3)/2)));
% axis off; axis tight; axis equal; colormap gray;
% title('Original img\_hig');
% 
% % Plot binned versions of img_hig
% for methodIdx = 1:numel(methods)
%     method = methods{methodIdx};
%     switch method
%         case 'imfilter'
%             kernel = ones(3, 3)/9;
%             img_hig_binned = imfilter(img_hig, kernel, 'same');
%         case 'convn'
%             kernel = ones(3, 3, 3) / 27;
%             img_hig_binned = convn(img_hig, kernel, 'same');
%         case 'rebin_3d'
%             factor = [0.3 0.3 0.3]'./(0.1);
%             factor = factor';
%             img_hig_binned = rebin_3d(img_hig, factor);
%     end
% 
%     subplot(1, 4, methodIdx + 1);
%     imagesc(img_hig_binned(:, :, round(size(img_hig_binned, 3)/2)));
%     axis off; axis tight; axis equal; colormap gray;
%     title(['Binned img\_hig (' method ')']);
% end
