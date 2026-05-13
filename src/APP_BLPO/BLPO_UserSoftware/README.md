# BLPO Dynamic Stall Parameter Optimization Software

This folder is an independent user-facing version of the original `optimal_flow`
workflow. It keeps the mature BL model functions and adds user-defined working
conditions, flexible reference-data import, a MATLAB graphical interface, export
utilities and packaging scripts.

## Run

Open MATLAB in this folder and run:

```matlab
BLPO_AppLauncher
```

For a command-line workflow, run:

```matlab
run_BLPO_cli
```

If the sample files are missing, regenerate them with:

```matlab
BLPO_make_sample_data
```

## Reference Data

The software accepts two formats:

- Experiment data: `time, Cl`
- CFD data: `time, Cl, Cd, Cm`

CSV, TXT, DAT and OUT files are supported as long as `readmatrix` can parse the
numeric columns.

## Outputs

The export folder receives:

- `optimized_parameters.csv`
- `fit_metrics.csv`
- `comparison_data.csv`
- `BLPO_result.mat`
- `fit_comparison.png`

## Package

If MATLAB Compiler is installed, build a deployable application with:

```matlab
package_BLPO_app
```

The packaged files are written to `dist`.
