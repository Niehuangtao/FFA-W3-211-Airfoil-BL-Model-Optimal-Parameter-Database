function collection = compare_optimal_result_MSE(para_local, para_default, setcase, outputDir)
%COMPARE_OPTIMAL_RESULT_MSE Legacy wrapper for MSE result collection.

    if nargin < 4 || isempty(outputDir)
        outputDir = pwd;
    end

    collection = compare_optimal_result('MSE', para_local, para_default, setcase, outputDir);
end
