function data = readoutfile(filename)
    data = readmatrix(filename, 'FileType', 'text', 'Range', 'A4');
end