function filePath = resolve_data_file(filename, subfolder)
    if nargin < 2
        subfolder = '';
    end

    if isfile(filename)
        filePath = filename;
        return
    end

    root = project_root();
    candidates = {
        fullfile(root, filename)
        fullfile(root, 'data', filename)
        fullfile(root, 'data', subfolder, filename)
        fullfile(root, 'data', 'airfoil', filename)
        fullfile(root, 'data', 'cfd', filename)
    };

    for i = 1:numel(candidates)
        if isfile(candidates{i})
            filePath = candidates{i};
            return
        end
    end

    error('Data file not found: %s', filename);
end
