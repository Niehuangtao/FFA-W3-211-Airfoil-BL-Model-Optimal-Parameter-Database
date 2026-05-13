function varargout = read_reference_data(filename, referenceConfig)
%READ_REFERENCE_DATA Read alpha-coefficient or time-series reference data.

    if nargin < 2 || isempty(referenceConfig)
        referenceConfig = struct();
    end

    filename = resolve_reference_path(filename);
    data = readmatrix(filename);
    data = data(any(~isnan(data), 2), :);
    data = data(:, any(~isnan(data), 1));

    if size(data, 2) < 2
        error('BL:InvalidReferenceData', ...
            'Reference data file must contain at least two numeric columns: %s', filename);
    end

    referenceType = get_struct_value(referenceConfig, 'type', 'alphaCoefficient');
    referenceType = lower(strtrim(char(referenceType)));

    switch referenceType
        case {'alphacoefficient', 'alpha-coefficient', 'anglecoefficient', 'angle-coefficient'}
            reference = read_alpha_coefficient_reference(filename, data, referenceConfig);

        case {'timeseries', 'time-series', 'time'}
            reference = read_time_series_reference(filename, data, referenceConfig);

        case 'auto'
            if size(data, 2) >= 4
                reference = read_time_series_reference(filename, data, referenceConfig);
            else
                reference = read_alpha_coefficient_reference(filename, data, referenceConfig);
            end

        otherwise
            error('BL:UnknownReferenceType', ...
                'Unsupported reference data type: %s', referenceType);
    end

    if nargout <= 1
        varargout{1} = reference;
    else
        varargout{1} = reference.x;
        varargout{2} = reference.y;
    end
end

function reference = read_alpha_coefficient_reference(filename, data, referenceConfig)
    data = data(:, 1:2);
    data = data(all(isfinite(data), 2), :);

    if size(data, 1) < 3
        error('BL:ReferenceTooShort', ...
            'Alpha-coefficient reference data must contain at least three rows.');
    end

    coefficientName = upper(strtrim(char(get_struct_value(referenceConfig, 'coefficient', 'CN'))));

    reference.file = filename;
    reference.type = 'alphaCoefficient';
    reference.xName = 'alpha';
    reference.yName = coefficientName;
    reference.alpha = data(:, 1);
    reference.coeff = data(:, 2);
    reference.x = reference.alpha;
    reference.y = reference.coeff;
    reference.nRows = size(data, 1);
    reference.nCols = size(data, 2);
end

function reference = read_time_series_reference(filename, data, referenceConfig)
    if size(data, 2) >= 4
        data = data(:, 1:4);
    else
        data = data(:, 1:2);
    end
    data = data(all(isfinite(data), 2), :);

    if size(data, 1) < 3
        error('BL:ReferenceTooShort', ...
            'Time-series reference data must contain at least three rows.');
    end

    [time, order] = sort(data(:, 1));
    data = data(order, :);
    [time, uniqueIdx] = unique(time, 'stable');
    data = data(uniqueIdx, :);

    targets = normalize_time_series_targets(get_struct_value(referenceConfig, 'timeSeriesTargets', {'CL'}), size(data, 2));

    reference.file = filename;
    reference.type = 'timeSeries';
    reference.xName = 'time';
    reference.yName = targets{1};
    reference.time = time(:);
    reference.CL = data(:, 2);
    reference.hasCL = true;
    reference.hasCD = size(data, 2) >= 4;
    reference.hasCM = size(data, 2) >= 4;
    reference.CD = [];
    reference.CM = [];

    if reference.hasCD
        reference.CD = data(:, 3);
        reference.CM = data(:, 4);
    end

    reference.targets = targets;
    reference.x = reference.time;
    reference.y = reference.(targets{1});
    reference.nRows = numel(reference.time);
    reference.nCols = size(data, 2);
end

function targets = normalize_time_series_targets(rawTargets, nCols)
    if ischar(rawTargets) || isstring(rawTargets)
        targets = cellstr(upper(string(rawTargets)));
    else
        targets = cellfun(@(x) upper(strtrim(char(x))), rawTargets, 'UniformOutput', false);
    end

    targets = unique(targets, 'stable');
    targets = targets(ismember(targets, {'CL', 'CD', 'CM'}));
    if isempty(targets)
        targets = {'CL'};
    end

    if nCols < 4
        targets = intersect(targets, {'CL'}, 'stable');
    end
    if isempty(targets)
        targets = {'CL'};
    end
end
