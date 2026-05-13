function BLPO_AppLauncher()
%BLPO_APPLAUNCHER Start the BLPO visual software.

root = fileparts(mfilename("fullpath"));
addpath(fullfile(root, "functions"));
if ~isfile(fullfile(root, "sample_data", "sample_reference_experiment_2col.csv"))
    BLPO_make_sample_data();
end
BLPO_App(Visible="on");
end
