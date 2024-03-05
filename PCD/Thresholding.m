%% Thresholding 

function thresh = calculateOtsuThreshold(img)
    % Calculate Otsu threshold for image segmentation
    hist = imhist(img); % Calculate histogram of the image
    thresh = otsuthresh(hist); % Calculate Otsu threshold
end


