function collection = compare_optimal_result_ARE(para_local, para_default, setcase, outputDir)
%COMPARE_OPTIMAL_RESULT_ARE Legacy wrapper for ARE result collection.

    if nargin < 4 || isempty(outputDir)
        outputDir = pwd;
    end

    collection = compare_optimal_result('ARE', para_local, para_default, setcase, outputDir);
end
