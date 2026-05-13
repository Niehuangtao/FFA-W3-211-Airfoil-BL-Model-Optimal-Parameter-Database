function airfoildata = input_afdata(airfoilFile, chord)
%INPUT_AFDATA Read static airfoil data and constants used by the BL model.

    if nargin < 1 || isempty(airfoilFile)
        airfoilFile = 'FFA_W3_211.txt';
    end
    if nargin < 2 || isempty(chord)
        chord = 0.6;
    end

    if exist(airfoilFile, 'file') ~= 2
        error('BL:MissingAirfoilFile', 'Airfoil file not found: %s', airfoilFile);
    end

    data = readmatrix(airfoilFile);
    c = chord;
    CD0 = 1.5;
    CM0 = 0.01;
    alpha0 = find_a0(data);
    alpha1 = deg2rad(12);
    alpha2 = deg2rad(-10);
    CN1 = 1.7;
    CN2 = -0.65;
    slope = 7;
    mCN = slope;
    slope_M = mCN;
    xAC = 0.25;
    xcp_c = 0.2;

    airfoildata.CD0 = CD0;
    airfoildata.CM0 = CM0;
    airfoildata.alpha0 = alpha0;
    airfoildata.alpha1 = alpha1;
    airfoildata.alpha2 = alpha2;
    airfoildata.CN1 = CN1;
    airfoildata.CN2 = CN2;
    airfoildata.slope = slope;
    airfoildata.mCN = mCN;
    airfoildata.slope_M = slope_M;
    airfoildata.c = c;
    airfoildata.xAC = xAC;
    airfoildata.xcp_c = xcp_c;
end
