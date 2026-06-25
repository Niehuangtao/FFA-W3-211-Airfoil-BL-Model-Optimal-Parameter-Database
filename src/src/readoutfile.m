function data = readoutfile(filename)
    filename = resolve_data_file(filename, 'cfd');
    data = readmatrix(filename, 'FileType', 'text', 'Range', 'A4');
end
