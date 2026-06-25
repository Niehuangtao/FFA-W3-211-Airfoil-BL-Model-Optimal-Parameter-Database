# BL Model Parameter Optimization

MATLAB implementation for optimizing Beddoes-Leishman (BL) dynamic-stall model parameters against CFD-derived aerodynamic data.

## Repository Layout

```text
src/                 MATLAB functions for the BL model, objectives, constraints, and plotting
scripts/             Runnable scripts and original Live Scripts
scripts/live/        Original MATLAB Live Scripts kept for experiment history
data/airfoil/        Airfoil polar/input data
data/cfd/            CFD and OpenFAST comparison data
results/figures/     Existing comparison figures
results/optimization/ Historical optimization result folders
results/generated/   New outputs created by the runnable scripts
archive/             MATLAB autosave/backup files kept out of the source tree
```

## Requirements

- MATLAB
- Global Optimization Toolbox (`ga`)
- Signal Processing Toolbox (`dtw`)
- Parallel Computing Toolbox is optional but used when available by the optimization options.

## Quick Start

Open MATLAB in the repository root and run:

```matlab
scripts/run_optimization
```

The default script runs the MSE objective for the `re5e5_i9.4_f2.4.txt` CFD case. Change `objectiveName` in `scripts/run_optimization.m` to `DTW`, `ARE`, or `GZ` to run another objective.

Generated `.mat`, `.png`, and `.pdf` outputs are written to `results/generated/`.

## Notes

- Source files are under `src/`; `startup.m` adds this directory to the MATLAB path when the repository root is the current folder.
- Data-loading helpers resolve files from `data/airfoil/` and `data/cfd/`, so the core functions no longer depend on all files living in the root directory.
