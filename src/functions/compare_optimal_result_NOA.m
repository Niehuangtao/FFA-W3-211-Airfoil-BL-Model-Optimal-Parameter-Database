function collection = compare_optimal_result_NOA(para_local, para_default, setcase, outputDir)
%COMPARE_OPTIMAL_RESULT_NOA Wrapper for NOA result collection.

    if nargin < 4 || isempty(outputDir)
        outputDir = pwd;
    end

    collection = compare_optimal_result('NOA', para_local, para_default, setcase, outputDir);
end
