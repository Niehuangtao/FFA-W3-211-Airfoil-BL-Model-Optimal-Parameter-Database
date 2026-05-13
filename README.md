# FFA-W3-211 Airfoil BL Dynamic Stall Parameter Optimization Project

This repository organizes a set of work around parameter calibration for the Beddoes-Leishman (BL) dynamic stall model of the FFA-W3-211 wind turbine airfoil. It includes a MATLAB optimization workflow, reference data processing, comparisons between different optimization objective functions, and an optimized parameter database for later lookup or interpolation.

The main goal of the project is to make the unsteady aerodynamic curves predicted by the BL model match CFD, experimental, OpenFAST, or other reference data as closely as possible under prescribed pitching-motion conditions. The optimized parameters are saved as structured results for further analysis and engineering use.

## Project Contents

```text
github_package/
|-- src/                         MATLAB BL parameter optimization program and results
|   |-- main.m                    Main entry point
|   |-- functions/                BL model, objective functions, genetic algorithm, and plotting functions
|   |-- reference_data/           Example reference data
|   |-- CFD_rlt/                  CFD / external aerodynamic data
|   |-- compare_DTW_ARE_MSE_GZ/   Comparison results for multiple objective functions
|   |-- 211/                      Typical FFA-W3-211 operating-condition optimization results
|   `-- README.md                 Program user guide
`-- Optimal parameters database/
    |-- BL_parameter_database.xlsx  Condition-indexed optimized BL parameter database
    `-- README.md                   Database description
```

## Main Work

The project mainly includes the following work:

- Builds a BL dynamic stall model parameter optimization workflow for the FFA-W3-211 airfoil.
- Uses a genetic algorithm to automatically calibrate BL model parameters.
- Supports reference data in either angle-coefficient curve format or time-series format.
- Compares several curve-matching objective functions, including `DTW`, `NOA`, `ARE`, and `MSE`.
- Exports optimized parameter files, curve data files, and comparison figures.
- Summarizes optimized parameters under different mean angles of attack, pitching amplitudes, Reynolds numbers, and frequencies into a database.

The current main program runs two optimization objectives by default:

- `DTW`: curve similarity optimization based on Dynamic Time Warping distance.
- `NOA`: closed-curve area-difference optimization based on Non-Overlapping Area.

The `ARE` and `MSE` functions are still kept in `src/functions/` for future method comparisons.

## Quick Start

The program should be run in MATLAB. The following toolboxes are recommended:

- Global Optimization Toolbox: used for the `ga` genetic algorithm.
- Signal Processing Toolbox: used for `dtw` calculation.
- Parallel Computing Toolbox: optional, used to accelerate parallel optimization.

Open MATLAB, switch to the program directory, and run:

```matlab
cd('D:\Desktop\github_package\src')
main
```

After the workflow finishes, MATLAB will print:

```text
BL optimization workflow completed.
```

By default, the following result files are generated in `src/`:

```text
BL_reference_optimal_parameters_DTW.mat
BL_reference_optimal_parameters_NOA.mat
data_collection_DTW.mat
data_collection_NOA.mat
opt_compare.png
opt_compare.pdf
```

For detailed instructions on running the program, input data formats, configuration options, and output variables, see `src/README.md`.

## Configuration Entry

The main configuration file is:

```text
src/functions/bl_default_config.m
```

Common configuration items include:

- Pitching-motion conditions: mean angle of attack, amplitude, Reynolds number, frequency, and chord length.
- Reference data path: CFD, experimental, or other external data files.
- Reference data type: angle-coefficient curve or time series.
- Lower bounds, upper bounds, and default values of the BL model parameters.
- Genetic algorithm population size, generation count, convergence tolerances, and parallel settings.
- Optimization objective functions to run.

For debugging, reduce `PopulationSize` and `MaxGenerations` first. After the data paths and plotting workflow are confirmed, restore the formal optimization settings.

## Optimized Parameter Database

`Optimal parameters database/BL_parameter_database.xlsx` stores condition-indexed optimized BL model parameters. Each parameter set corresponds to one pitching-motion condition. The index variables include:

- Mean angle of attack
- Pitching amplitude
- Reynolds number
- Reduced frequency

The parameter vector in the database follows this order:

$[A1, b1, A2, b2, Tp, Tf0, Tvl, Tv0, eta]$

The database can be used for unsteady aerodynamic prediction, aeroelastic simulation, or parameter lookup and interpolation under new operating conditions. A short database description is available in `Optimal parameters database/README.md`.

## Reference Data Source

The experimental data used for parameter calibration comes from:

[*The Experimental Characterisation of Dynamic Stall of the FFA-W3-211 Wind Turbine Airfoil*](https://doi.org/10.5194/wes-2025-121)

The program in this repository can also use CFD, OpenFAST, or other external reference data, making it possible to extend the optimization workflow to different airfoils, Reynolds numbers, and motion conditions.

## Use Cases

This project is suitable for:

- BL dynamic stall model parameter calibration.
- Analysis of how different curve-similarity metrics affect optimization results.
- Comparison between CFD / experimental aerodynamic data and engineering models.
- Unsteady aerodynamic modeling of wind turbine airfoils.
- BL parameter lookup, interpolation, and sensitivity analysis for later aeroelastic calculations.

## Notes

The `src/` directory contains many `.mat`, `.png`, and `.pdf` result files. Some subdirectories store historical optimization results for different operating conditions and objective functions. To reproduce the workflow, start with `src/main.m`. To use existing results or the parameter database, start with `Optimal parameters database/`.
