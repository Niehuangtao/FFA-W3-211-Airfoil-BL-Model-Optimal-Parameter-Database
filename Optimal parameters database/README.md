# FFA-W3-211 BL Optimal Parameter Database

Optimized Beddoes-Leishman dynamic stall model parameter database for the FFA-W3-211 airfoil.

# Condition-Indexed Optimized BL Parameter Database for the FFA-W3-211 Airfoil

This repository contains a condition-indexed optimized parameter database for the Beddoes-Leishman (BL) dynamic stall model applied to the FFA-W3-211 airfoil.

Each database entry corresponds to a prescribed pitching-motion condition and stores the corresponding optimized BL model parameter vector:

$[A_1, b_1, A_2, b_2, T_p, T_{f0}, T_{vl}, T_{v0}, \eta]$

The input indices of the database include the mean angle of attack, pitching amplitude, Reynolds number, and reduced frequency. The database can be used for direct parameter lookup or interpolation in unsteady aerodynamic prediction and aeroelastic simulations.

The experimental data used for parameter calibration were obtained from the paper [*The Experimental Characterisation of Dynamic Stall of the FFA-W3-211 Wind Turbine Airfoil*](https://doi.org/10.5194/wes-2025-121). The calibration was performed using a MATLAB program based on the BL model together with a genetic algorithm.
