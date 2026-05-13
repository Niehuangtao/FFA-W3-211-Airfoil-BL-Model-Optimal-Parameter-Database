function airfoildata = BLPO_default_airfoil(options)
%BLPO_DEFAULT_AIRFOIL Build airfoil constants used by cal_DS.

arguments
    options.PolarFile (1,1) string = ""
    options.Chord (1,1) double = 1
    options.CD0 (1,1) double = 1.5
    options.CM0 (1,1) double = 0.01
    options.Alpha1Deg (1,1) double = 15
    options.Alpha2Deg (1,1) double = -12
    options.CN1 (1,1) double = 1.65
    options.CN2 (1,1) double = -1
    options.Slope (1,1) double = 6.8
    options.XAC (1,1) double = 0.25
    options.XCPC (1,1) double = 0.2
end

if strlength(options.PolarFile) > 0 && isfile(options.PolarFile)
    polar = readmatrix(options.PolarFile);
    polar = polar(all(~isnan(polar), 2), :);
    alpha0 = find_a0(polar);
else
    alpha0 = 0;
end

airfoildata.CD0 = options.CD0;
airfoildata.CM0 = options.CM0;
airfoildata.alpha0 = alpha0;
airfoildata.alpha1 = deg2rad(options.Alpha1Deg);
airfoildata.alpha2 = deg2rad(options.Alpha2Deg);
airfoildata.CN1 = options.CN1;
airfoildata.CN2 = options.CN2;
airfoildata.slope = options.Slope;
airfoildata.mCN = options.Slope;
airfoildata.slope_M = options.Slope;
airfoildata.c = options.Chord;
airfoildata.xAC = options.XAC;
airfoildata.xcp_c = options.XCPC;
end
