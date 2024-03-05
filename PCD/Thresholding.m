%% Thresholding 

function thresh = calculateThreshold(img, method)
    % Calculate threshold for image segmentation using the specified method
    switch method
        method 'otsu'
            hist = imhist(img); % Calculate histogram of input image
            thresh = otsuthresh(hist); % Calculate Otsu threshold
        method 'yen'
            level = graythresh(img) * 255;
            thresh = level;
        method 'triangle'
            level = graythresh(img) * 255;
            thresh = level;
        method 'isodata'
            level = graythresh(img) * 255;
            thresh = level;
        otherwise
            error('Invalid method. Use ''otsu'', ''yen'', ''triangle'', or ''isodata''.');
    end
end
