function resolvedPath = resolve_reference_path(filename)
%RESOLVE_REFERENCE_PATH Resolve reference files from absolute, current, or reference_data paths.

    if exist(filename, 'file') == 2
        resolvedPath = filename;
        return;
    end

    referenceFolderPath = fullfile(pwd, 'reference_data', filename);
    if exist(referenceFolderPath, 'file') == 2
        resolvedPath = referenceFolderPath;
        return;
    end

    error('BL:MissingReferenceFile', 'Reference data file not found: %s', filename);
end
