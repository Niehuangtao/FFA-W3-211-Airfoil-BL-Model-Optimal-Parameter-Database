function package_BLPO_app()
%PACKAGE_BLPO_APP Build a deployable BLPO application with MATLAB Compiler.

root = fileparts(mfilename("fullpath"));
addpath(fullfile(root, "functions"));
if ~isfolder(fullfile(root, "dist"))
    mkdir(fullfile(root, "dist"));
end

if isempty(which("mcc"))
    error("MATLAB Compiler is required to package the application.");
end

old = pwd;
cleanup = onCleanup(@() cd(old));
cd(root);

mcc("-m", "BLPO_AppLauncher.m", ...
    "-a", fullfile(root, "functions"), ...
    "-a", fullfile(root, "sample_data"), ...
    "-d", fullfile(root, "dist"), ...
    "-o", "BLPO");

disp("Packaged files written to " + string(fullfile(root, "dist")));
end
