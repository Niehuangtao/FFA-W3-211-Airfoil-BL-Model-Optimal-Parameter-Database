# User Guide for the BL Model Parameter Optimization Program

This program is used to optimize the parameters of the BL dynamic stall model and compare the optimized model curves with reference data. The reference data can come from simulation, experiments, OpenFAST, or other external sources. The current main workflow compares two optimization objectives by default:

- `DTW`: curve similarity optimization based on Dynamic Time Warping distance.
- `NOA`: curve similarity optimization based on Non-Overlapping Area.

The `ARE` and `MSE` related functions are still kept in the `functions` directory for future method comparison, but `main.m` does not run them by default.

## 1. Runtime Environment

It is recommended to run the program in MATLAB. The program requires the following capabilities:

- `ga` genetic algorithm: usually requires the Global Optimization Toolbox.
- `dtw` function: usually requires the Signal Processing Toolbox.
- Parallel optimization is optional: if Parallel Computing Toolbox is not available, set `config.ga.UseParallel = false` in `functions/bl_default_config.m`.

## 2. File Structure

The main files and directories are:

```text
main.m                         Main entry point. Run this file directly.
functions/                     All computation, optimization, and plotting functions.
functions/bl_default_config.m  Main configuration file for case settings, paths, parameters, and GA options.
FFA_W3_211.txt                 Static airfoil data.
reference_data/                Reference data directory.
```

After execution, the following output files will be created or overwritten in the project root directory:

```text
BL_reference_optimal_parameters_DTW.mat
BL_reference_optimal_parameters_NOA.mat
data_collection_DTW.mat
data_collection_NOA.mat
opt_compare.png
opt_compare.pdf
```

## 3. Quick Start

1. Open MATLAB.
2. Change the current working directory to the project root, for example:

   ```matlab
   cd('D:\Desktop\src')
   ```

3. Run the main script:

   ```matlab
   main
   ```

4. Wait for the genetic algorithm to finish. After completion, MATLAB will print:

   ```text
   BL optimization workflow completed.
   ```

5. Check the output figures:

   ```text
   opt_compare.png
   opt_compare.pdf
   ```

## 4. Modifying the Case and Input Data

All commonly used settings are centralized in:

```text
functions/bl_default_config.m
```

### Input Data Overview

The program uses three categories of input:

| Input type | Default location | Data format | Purpose |
| --- | --- | --- | --- |
| Case configuration | `functions/bl_default_config.m` | MATLAB scalars or arrays | Defines mean angle of attack, amplitude, Reynolds number, frequency, chord length, number of steps, and related settings |
| Static airfoil data | `FFA_W3_211.txt` | Numeric text matrix | Used to compute static airfoil quantities such as zero-lift angle |
| Reference data | `reference_data/re1e6_9.6_f0.6.txt` | Numeric text matrix | Used as the optimization target curve and compared with the BL model output |

Plain numeric text files are recommended. Spaces, tabs, or commas are all acceptable because the program reads the file with MATLAB `readmatrix`.

### Modify Mean Angle, Amplitude, Reynolds Number, and Frequency

Edit the following fields in `bl_default_config.m`:

```matlab
config.case.meanangle = 9.6;
config.case.averageangle = 7;
config.case.Re = 1e6;
config.case.frequency = 0.6;
config.case.chord = 0.6;
```

These values are passed into `input_condition` to build the time series and kinematic variables required by the BL model. The most commonly used fields are:

| Setting | Data type | Unit / meaning |
| --- | --- | --- |
| `config.case.meanangle` | Scalar | Mean angle of attack, in degrees |
| `config.case.averageangle` | Scalar | Oscillation amplitude, in degrees |
| `config.case.Re` | Scalar | Reynolds number |
| `config.case.frequency` | Scalar | Pitch oscillation frequency, in Hz |
| `config.case.chord` | Scalar | Chord length, in m |
| `config.case.nCycles` | Positive integer | Total number of simulated cycles, default `10` |
| `config.case.nSteps` | Positive integer | Total number of time steps, default `5000` |
| `config.case.windowCycles` | `1 x 2` array | Cycle window used for fitting and plotting, default `[7 8]` |

### Modify the Reference Data File

Edit the following field in `bl_default_config.m`:

```matlab
config.files.reference = fullfile(projectRoot, 'reference_data', 're1e6_9.6_f0.6.txt');
```

The program now supports two reference data modes in one unified workflow:

| Mode | Configuration value | Data column format | Typical use case |
| --- | --- | --- | --- |
| Angle-coefficient | `alphaCoefficient` | `alpha, coefficient` | Default mode in the current main workflow, used for loop-shape fitting |
| Time series | `timeSeries` | `time, CL` or `time, CL, CD, CM` | Time-series reference fitting merged from the APP_BLPO workflow |

Switch between them in `bl_default_config.m`:

```matlab
config.reference.type = 'alphaCoefficient';   % alphaCoefficient or timeSeries
config.reference.coefficient = 'CN';          % CN, CL, CD, or CM for alphaCoefficient mode
config.reference.timeSeriesTargets = {'CL'};  % Sequential stage order for timeSeries mode
```

### Angle-Coefficient Mode

In angle-coefficient mode, the program reads the first two columns by default:

- Column 1: angle of attack, in degrees.
- Column 2: reference normal-force coefficient or the target coefficient used for fitting.

The data format can be `N x 2` or `N x M`, where `N` is the number of sampled points and `M >= 2`. Only the first two columns are used in this mode; extra columns are ignored.

Recommended file format:

```text
9.57364341085271    1.32803347280335
9.80620155038760    1.35313807531381
10.0387596899225    1.37405857740586
10.2325581395349    1.39497907949791
```

Corresponding MATLAB variable form:

```matlab
exp_data = [alpha_deg, CN_reference];
```

Column meaning:

| Column | Variable | Meaning |
| --- | --- | --- |
| 1 | `alpha_deg` | Angle of attack of the reference curve, in degrees |
| 2 | `CN_reference` | Reference normal-force coefficient, or the currently selected target coefficient |

### Time-Series Mode

Time-series mode is used to merge the time-series optimization capability from `APP_BLPO`. Example configuration:

```matlab
config.files.reference = fullfile(projectRoot, 'reference_data', 'sample_time_series_reference.csv');
config.reference.type = 'timeSeries';
config.reference.timeSeriesTargets = {'CL', 'CD', 'CM'};
```

Two file layouts are supported:

| Column layout | Meaning |
| --- | --- |
| `time, CL` | Fit only the lift coefficient time series |
| `time, CL, CD, CM` | Read lift, drag, and moment coefficient time series together |

In time-series mode:

- `timeSeriesTargets` defines the sequential optimization stages, not weights.
- For example, `{'CL', 'CD', 'CM'}` means optimize `CL` first, then use that result as the starting point for `CD`, and finally continue with `CM`.
- `DTW`, `MSE`, and `ARE` compare the current target coefficient directly on the same time grid at each stage.
- `NOA` maps time to angle of attack through the model kinematics first, then computes the non-overlapping area for the current target coefficient.
- If you set only `{'CL'}`, the program runs only one `CL` stage.
- If the reference file has only two columns, the program uses only `CL` even if `timeSeriesTargets` contains `CD` or `CM`.

### Modify the Static Airfoil Data File

Edit the following field in `bl_default_config.m`:

```matlab
config.files.airfoil = fullfile(projectRoot, 'FFA_W3_211.txt');
```

The static airfoil data is also a numeric text matrix. The current workflow uses at least the first two columns:

| Column | Meaning | Current use |
| --- | --- | --- |
| 1 | Static angle of attack, in degrees | Used to locate the zero-lift angle `alpha0` |
| 2 | Static lift coefficient or normal-force-related coefficient | Used together with column 1 to find the zero crossing |

Recommended format:

```text
alpha_deg    CL_or_CN
-12.0        -0.82
-10.0        -0.65
...
0.0           0.10
...
12.0          1.30
```

If the file contains more columns, the current main workflow does not use those extra columns directly.

## 5. Modify the Optimization Parameters

The parameter names, lower bounds, upper bounds, and default values are defined in `bl_default_config.m`:

```matlab
config.parameters.names = {'A1', 'b1', 'A2', 'b2', 'Tp', 'Tf0', 'Tvl', 'Tv0', 'yita'};
config.parameters.lower = [0, 0, 0, 0, 0, 0, 0, 0, 0.85];
config.parameters.upper = [0.8, 0.8, 0.8, 0.8, 10, 5, 15, 5, 0.95];
config.parameters.default = [0.3, 0.3, 0.3, 0.3, 5, 1, 8, 2, 0.95];
```

The three arrays must have the same length, and the default values must stay within the bounds.

## 6. Modify the Optimization Methods

The main workflow runs only the following methods by default:

```matlab
config.metrics = {'DTW', 'NOA'};
```

If you want to include the preserved comparison methods later, you can change it to:

```matlab
config.metrics = {'DTW', 'NOA', 'ARE', 'MSE'};
```

Note: the more methods you run, the longer the total runtime.

## 7. Modify the Genetic Algorithm Settings

The GA settings are defined in `bl_default_config.m`:

```matlab
config.ga.PopulationSize = 256;
config.ga.MaxGenerations = 50;
config.ga.FunctionTolerance = 1e-4;
config.ga.ConstraintTolerance = 1e-4;
config.ga.Display = 'iter';
config.ga.UseParallel = true;
```

If you only want to debug the workflow, you can reduce the computational cost temporarily:

```matlab
config.ga.PopulationSize = 32;
config.ga.MaxGenerations = 5;
config.ga.UseParallel = false;
```

Restore larger population sizes and generation counts for final optimization runs.

## 8. Output Files

The default output directory is the project root and is controlled by:

```matlab
config.outputDir = projectRoot;
```

If you want to save results to another location, change this path in `bl_default_config.m`.

### Optimized Parameter Files

Each optimization method generates one parameter file:

```text
BL_reference_optimal_parameters_DTW.mat
BL_reference_optimal_parameters_NOA.mat
```

These files contain:

| Variable | Data type | Meaning |
| --- | --- | --- |
| `paraLocal` | `1 x 9 double` | Optimized BL parameter vector |
| `fitnessOpt` | Scalar | Optimized objective function value, smaller is better |
| `defaultFitness` | Scalar | Objective function value for the default parameters |
| `exitflag` | Scalar | Exit flag returned by MATLAB `ga` |
| `gaOutput` | struct | Iteration information returned by MATLAB `ga` |
| `result` | struct | Structured summary of the optimization run |

Notes:

- For `alphaCoefficient` mode and single-stage `timeSeries` mode, `fitnessOpt` and `defaultFitness` both correspond to the single active target.
- For multi-stage `timeSeries` mode, the top-level `fitnessOpt` and `defaultFitness` correspond to the last stage target. The full stage history is stored in `result.stages`.
- `result.stageTargets` stores the stage order, for example `{'CL','CD','CM'}`.

The 9 parameters in `paraLocal` always follow this order:

| Index | Parameter |
| --- | --- |
| 1 | `A1` |
| 2 | `b1` |
| 3 | `A2` |
| 4 | `b2` |
| 5 | `Tp` |
| 6 | `Tf0` |
| 7 | `Tvl` |
| 8 | `Tv0` |
| 9 | `yita` |

Example:

```matlab
load('BL_reference_optimal_parameters_NOA.mat');
disp(paraLocal);
disp(fitnessOpt);
```

### Curve Data Files

Each optimization method also generates one curve data file:

```text
data_collection_DTW.mat
data_collection_NOA.mat
```

These files contain:

| Variable | Data type | Meaning |
| --- | --- | --- |
| `default_data` | `N x 2 double` | Main target curve obtained from the default parameters |
| `exp_data` | `N_ref x 2 double` | Reference curve |
| `DTW_data` | `N x 2 double` | Main target curve after DTW optimization, only in `data_collection_DTW.mat` |
| `NOA_data` | `N x 2 double` | Main target curve after NOA optimization, only in `data_collection_NOA.mat` |
| `collection` | struct | Structured curve data including `metric`, `optimized`, `default`, and `reference` |

The column definitions of these 2D matrices depend on the reference data mode:

| Mode | Column 1 | Column 2 |
| --- | --- | --- |
| `alphaCoefficient` | Angle of attack, in degrees | The coefficient specified by `config.reference.coefficient` |
| `timeSeries` | Time, in seconds | The last target coefficient in `config.reference.timeSeriesTargets` |

In `alphaCoefficient` mode, `N` is the number of BL model points inside the comparison window. With the default settings `nSteps = 5000`, `windowCycles = [7 8]`, and `nCycles = 10`, `N` is about `501`. In `timeSeries` mode, `N` is the number of reference rows overlapping with the model time range.

If multiple targets are loaded in `timeSeries` mode, such as `CL/CD/CM`, the full sequences are stored in:

```matlab
collection.timeSeries.reference.CL
collection.timeSeries.default.CL
collection.timeSeries.optimized.CL
collection.timeSeries.reference.CD
collection.timeSeries.default.CD
collection.timeSeries.optimized.CD
collection.timeSeries.reference.CM
collection.timeSeries.default.CM
collection.timeSeries.optimized.CM
```

In addition:

- `collection.primaryTarget` is the target coefficient represented by the exported 2-column curve.
- `collection.optimizationTargets` is the actual sequential stage order used in the optimization.

Example for loading and plotting the angle-coefficient mode results:

```matlab
load('data_collection_NOA.mat');

figure;
plot(exp_data(:,1), exp_data(:,2), 'k-', 'LineWidth', 1.5);
hold on;
plot(default_data(:,1), default_data(:,2), 'Color', [0.5 0.5 0.5]);
plot(NOA_data(:,1), NOA_data(:,2), 'r--', 'LineWidth', 1.5);
legend('Reference', 'Default', 'NOA');
xlabel('Angle of attack (deg)');
ylabel('C_N');
grid on;
```

### Comparison Figures

```text
opt_compare.png
opt_compare.pdf
```

The figure includes:

- `DTW`: DTW optimization result.
- `NOA`: non-overlapping-area optimization result.
- `Default`: result from the default parameters.
- `Reference`: reference data.

Figure file formats:

| File | Format | Typical use |
| --- | --- | --- |
| `opt_compare.png` | Raster image | Fast viewing and insertion into regular documents |
| `opt_compare.pdf` | Vector image | Papers, reports, and further editing |

## 9. Frequently Asked Questions

### The reference data file cannot be found

Check the path in `functions/bl_default_config.m`:

```matlab
config.files.reference = fullfile(projectRoot, 'reference_data', 're1e6_9.6_f0.6.txt');
```

Make sure the file exists and contains at least two numeric columns.

### Error because Parallel Computing Toolbox is not available

Change:

```matlab
config.ga.UseParallel = true;
```

to:

```matlab
config.ga.UseParallel = false;
```

### The optimization is too slow

For debugging, reduce:

```matlab
config.ga.PopulationSize
config.ga.MaxGenerations
```

After the workflow is confirmed to be correct, increase them again for the full optimization run.

### I only want to test the objective function without running a full optimization

Run the following in the MATLAB command window:

```matlab
addpath(fullfile(pwd, 'functions'));
config = bl_default_config(pwd);
setcase = build_bl_setcase(config.case, config.files);
fitness_metric(config.parameters.default, setcase, 'DTW')
fitness_metric(config.parameters.default, setcase, 'NOA')
```

This is a quick way to verify that the data path, model calculation, and objective function are working correctly.

## 10. Recommended Workflow

1. First confirm that the reference data file in `reference_data` is correct.
2. Set the case parameters and reference data file path in `bl_default_config.m`.
3. Run a quick debug case with a smaller `PopulationSize` and `MaxGenerations`.
4. Check whether the curve trend in `opt_compare.png` looks reasonable.
5. Restore the formal optimization settings and run `main.m`.
6. Use the optimized parameters and curve data in the `.mat` files for further analysis.
