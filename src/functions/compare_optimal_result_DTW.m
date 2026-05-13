function collection = compare_optimal_result_DTW(para_local, para_default, setcase, outputDir)
%COMPARE_OPTIMAL_RESULT_DTW Legacy wrapper for DTW result collection.

    if nargin < 4 || isempty(outputDir)
        outputDir = pwd;
    end

    collection = compare_optimal_result('DTW', para_local, para_default, setcase, outputDir);
end
