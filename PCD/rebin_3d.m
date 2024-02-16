function rebinned = rebin_3d(data, factor)
% Rebins a 3D array by a given factor in each dimension.

new_shape = floor(size(data) ./ factor);

rebinned = zeros(new_shape);

for i = 1:new_shape(1)
    for j = 1:new_shape(2)
        for k = 1:new_shape(3)
            orig_i = (i-1) * factor(1) + 1 : i * factor(1);
            orig_j = (j-1) * factor(2) + 1 : j * factor(2);
            orig_k = (k-1) * factor(3) + 1 : k * factor(3);
            
            rebinned(i,j,k) = mean(mean(mean(data(orig_i, orig_j, orig_k))));
        end
    end
end
