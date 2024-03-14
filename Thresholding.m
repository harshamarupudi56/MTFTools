function thresh = calculateThreshold(img, method, varargin)
    switch method 
        case 'otsu'
            hist = imhist(img); 
            thresh = otsuthresh(hist); 
        case 'yen'
            level = graythresh(img) * 255; 
            thresh = level; 
        case 'triangle'
            % Calculate histogram
            hist = imhist(img);
            
            % Find peak (maximum) of histogram
            [histMax, peak] = max(hist);
            
            % Find the farthest end of the histogram
            [~, maxIndex] = max(abs(1:length(hist) - peak));
            if peak < maxIndex
                endHist = length(hist);
            else
                endHist = 1;
            end
            
            % Calculate slope and intercept of the line
            slope = (histMax - 0) / (peak - endHist);
            intercept = -slope * peak;
            
            % Calculate distances between each histogram point and the line
            distances = abs((1:length(hist)) * slope + intercept - hist');
            
            % Find threshold at the point of maximum distance
            [~, threshIndex] = max(distances);
            thresh = threshIndex - 1; 

        case 'isodata'
            hist = imhist(img);
            bin_centers = (0:255)';
            counts = double(hist);
            counts = single(counts / sum(counts));
            csuml = cumsum(counts);
            csumh = 1 - csuml;
            intensity_sum = counts .* bin_centers;
            csum_intensity = cumsum(intensity_sum);
            lower = csum_intensity(1:end-1) ./ csuml(1:end-1);
            higher = (csum_intensity(end) - csum_intensity(1:end-1)) ./ csumh(1:end-1);
            all_mean = (lower + higher) / 2.0;
            bin_width = bin_centers(2) - bin_centers(1);
            distances = all_mean - bin_centers(1:end-1);
            thresholds = bin_centers(1:end-1) .* ((distances >= 0) & (distances < bin_width));
            thresh = thresholds(1);
        case 'adapt'
            if numel(varargin) < 1
                sensitivity = 0.5; % Default sensitivity
            else
                sensitivity = varargin{1};
            end
            thresh = adaptthresh(img, sensitivity) * 255;  

        case 'median'
            thresh = median(img(:));
    end
end
