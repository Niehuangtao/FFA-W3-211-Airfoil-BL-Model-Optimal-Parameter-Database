function reference = BLPO_read_reference(filename)
%BLPO_READ_REFERENCE Read 2-column experiment or 4-column CFD reference data.

arguments
    filename (1,1) string
end

if ~isfile(filename)
    error("BLPO:ReferenceNotFound", "Reference file does not exist: %s", filename);
end

data = readmatrix(filename);
data = data(any(~isnan(data), 2), :);
data = data(:, any(~isnan(data), 1));

if size(data, 2) < 2
    error("BLPO:ReferenceFormat", "Reference data must have 2 columns (time, Cl) or 4 columns (time, Cl, Cd, Cm).");
end

if size(data, 2) >= 4
    data = data(:, 1:4);
    valid = all(isfinite(data), 2);
    data = data(valid, :);
    reference.kind = "CFD";
    reference.cd = data(:, 3);
    reference.cm = data(:, 4);
else
    data = data(:, 1:2);
    valid = all(isfinite(data), 2);
    data = data(valid, :);
    reference.kind = "Experiment";
    reference.cd = [];
    reference.cm = [];
end

if size(data, 1) < 3
    error("BLPO:ReferenceTooShort", "Reference data must contain at least 3 numeric rows.");
end

[time, order] = sort(data(:, 1));
data = data(order, :);
[time, uniqueIdx] = unique(time, "stable");
data = data(uniqueIdx, :);

reference.file = filename;
reference.time = time;
reference.cl = data(:, 2);
reference.hasCd = size(data, 2) >= 4;
reference.hasCm = size(data, 2) >= 4;
reference.nRows = numel(time);
reference.nCols = size(data, 2);
end
