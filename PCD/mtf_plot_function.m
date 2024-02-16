function plotMultipleCoordinates(coordinates_files)
    uSize = [0.3 0.3 0.3] / 3; % 1 mm
    close all;

    U = cell(1, numel(coordinates_files));
    legends = cell(1, numel(coordinates_files));

    for fileIdx = 1:numel(coordinates_files)
        coordinates_file = coordinates_files{fileIdx};

        if exist(coordinates_file, 'file')
            loaded_data = load(coordinates_file, 'U');
            U{fileIdx} = loaded_data.U(1, :, :, :); % Store only the first set of coordinates

            [~, filename, ~] = fileparts(coordinates_file);

            % Extract label (e.g., 'SP', 'AC') and value from the filename
            [label, value] = extractLabelAndValue(filename);

            if ~isempty(label) && ~isempty(value)
                legends{fileIdx} = [label, value];
            else
                error('Label and/or value not found in the filename.');
            end
        else
            error('Coordinates file does not exist.');
        end
    end

    % Plotting MTFs for each set of coordinates on a single plot
    figure;
    hold on;

    for fileIdx = 1:numel(U)
        coordinates_data = U{fileIdx};

        u = squeeze(coordinates_data);
        th = 50;
        [uBinary] = segnd_th(u, th);
        C = mtf.EsfCalc_Sphere('uSzScale', uSize(1:3) / uSize(1), 'pPath', './datasets/FitPara_Sphere_Filter11_Cios.mat');
        C.fit(uBinary);

        pMtf = struct('diffMethod', 'gradient', 'maxFreq', 3);
        pDetrend = struct('bDebug', 0);

        coneAngs = 0; % Use a single angle, 0 degrees

        for i = 1:length(coneAngs)
            pApply = {'coneRg', coneAngs(i) + [-5 5], 'thetaRg', [-pi pi]};
            [esf, esfAxis] = C.apply(u, pApply{:});
            [mtfVal, mtfAxis] = mtf.sf2Mtf(esf, esfAxis, uSize(1), pMtf, pDetrend);

            % Check if the label is 'SP' and apply the line style conditionally
            if strcmp(legends{fileIdx}(1:2), 'SP')
                plot(mtfAxis, mtfVal, 'LineWidth', 2, 'LineStyle', '--');
            else
                plot(mtfAxis, mtfVal, 'LineWidth', 2);
            end
        end
    end

    % Display legend
    xlim([0,3]);
    ylim([0 1]);
    xlabel('f (lp/mm)');
    ylabel('MTF');
    % title('MTF AC and SP for Low Energy Threshold')
    legend(legends, 'location', 'best');
    hold off;
end

function [label, value] = extractLabelAndValue(filename)
    % Extract label (e.g., 'SP', 'AC') and value from the filename
    labelPattern = '(SP|AC)'; % Add more labels as needed
    valuePattern = '\d+';

    labelMatch = regexp(filename, labelPattern, 'match');
    valueMatch = regexp(filename, valuePattern, 'match');

    if ~isempty(labelMatch) && ~isempty(valueMatch)
        label = labelMatch{1};
        value = valueMatch{1};
    else
        label = '';
        value = '';
    end
end


% function plotMultipleCoordinates(coordinates_files)
%     uSize = [0.3 0.3 0.3] / 3; % 1 mm
%     close all;
% 
%     U = cell(1, numel(coordinates_files));
%     legends = cell(1, numel(coordinates_files));
% 
%     for fileIdx = 1:numel(coordinates_files)
%         coordinates_file = coordinates_files{fileIdx};
% 
%         if exist(coordinates_file, 'file')
%             loaded_data = load(coordinates_file, 'U');
%             U{fileIdx} = loaded_data.U(1, :, :, :); % Store only the first set of coordinates
% 
%             [~, filename, ~] = fileparts(coordinates_file);
% 
%             % Extract label (e.g., 'SP', 'AC') and value from the filename
%             [label, value] = extractLabelAndValue(filename);
% 
%             if ~isempty(label) && ~isempty(value)
%                 legends{fileIdx} = [label, value];
%             else
%                 error('Label and/or value not found in the filename.');
%             end
%         else
%             error('Coordinates file does not exist.');
%         end
%     end
% 
%     % Plotting MTFs for each set of coordinates on a single plot
%     figure;
%     hold on;
% 
%     for fileIdx = 1:numel(U)
%         coordinates_data = U{fileIdx};
% 
%         u = squeeze(coordinates_data);
%         th = 50;
%         [uBinary] = segnd_th(u, th);
%         C = mtf.EsfCalc_Sphere('uSzScale', uSize(1:3) / uSize(1), 'pPath', './datasets/FitPara_Sphere_Filter11_Cios.mat');
%         C.fit(uBinary);
% 
%         pMtf = struct('diffMethod', 'gradient', 'maxFreq', 3);
%         pDetrend = struct('bDebug', 0);
% 
%         coneAngs = 0; % Use a single angle, 0 degrees
% 
%         for i = 1:length(coneAngs)
%             pApply = {'coneRg', coneAngs(i) + [-5 5], 'thetaRg', [-pi pi]};
%             [esf, esfAxis] = C.apply(u, pApply{:});
%             [mtfVal, mtfAxis] = mtf.sf2Mtf(esf, esfAxis, uSize(1), pMtf, pDetrend);
%             plot(mtfAxis, mtfVal,'LineWidth', 2);
%         end
%     end
% 
% 
%     % Display legend
%     xlim([0,3]);
%     ylim([0 1]);
%     xlabel('f (lp/mm)');
%     ylabel('MTF');
%     legend(legends, 'location', 'best');
%     hold off;
% end
% 
% function [label, value] = extractLabelAndValue(filename)
%     % Extract label (e.g., 'SP', 'AC') and value from the filename
%     labelPattern = '(SP|AC)'; % Add more labels as needed
%     valuePattern = '\d+';
% 
%     labelMatch = regexp(filename, labelPattern, 'match');
%     valueMatch = regexp(filename, valuePattern, 'match');
% 
%     if ~isempty(labelMatch) && ~isempty(valueMatch)
%         label = labelMatch{1};
%         value = valueMatch{1};
%     else
%         label = '';
%         value = '';
%     end
% end




