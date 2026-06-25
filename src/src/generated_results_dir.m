function outputDir = generated_results_dir()
    outputDir = fullfile(project_root(), 'results', 'generated');
    if ~isfolder(outputDir)
        mkdir(outputDir);
    end
end
