function result = BLPO_evaluate(param, setcase)
%BLPO_EVALUATE Run the BL model and compare it with user reference data.

param = double(param(:))';
if numel(param) ~= 24
    error("BLPO:ParameterSize", "BL parameter vector must contain 24 values.");
end

conditions = setcase.conditions;
airfoildata = setcase.airfoldata;
reference = setcase.reference;

[~, CN, ~, CD, CL, CM, alphaRad] = cal_DS(param, conditions, airfoildata);

model.time = conditions.t(:);
model.alphaDeg = rad2deg(alphaRad(:));
model.cl = CL(:);
model.cd = CD(:);
model.cm = CM(:);
model.cn = CN(:);

validTime = reference.time >= model.time(1) & reference.time <= model.time(end);
if nnz(validTime) < 3
    error("BLPO:ReferenceTimeRange", "Reference time range does not overlap the simulated condition.");
end

time = reference.time(validTime);
refCl = reference.cl(validTime);
fitCl = interp1(model.time, model.cl, time, "linear");
fitAlpha = interp1(model.time, model.alphaDeg, time, "linear");

metrics.rmseCl = local_rmse(fitCl, refCl);
metrics.rmseCd = NaN;
metrics.rmseCm = NaN;

if reference.hasCd
    refCd = reference.cd(validTime);
    fitCd = interp1(model.time, model.cd, time, "linear");
    metrics.rmseCd = local_rmse(fitCd, refCd);
else
    refCd = [];
    fitCd = [];
end

if reference.hasCm
    refCm = reference.cm(validTime);
    fitCm = interp1(model.time, model.cm, time, "linear");
    metrics.rmseCm = local_rmse(fitCm, refCm);
else
    refCm = [];
    fitCm = [];
end

result.param = param;
result.model = model;
result.fit.time = time;
result.fit.alphaDeg = fitAlpha;
result.fit.cl = fitCl;
result.fit.cd = fitCd;
result.fit.cm = fitCm;
result.reference.time = time;
result.reference.alphaDeg = fitAlpha;
result.reference.cl = refCl;
result.reference.cd = refCd;
result.reference.cm = refCm;
result.referenceInfo = reference;
period = 2 * pi / conditions.w;
displayEnd = time(end);

historyStart = max(time(1), displayEnd - 3 * period);
historyMask = time >= historyStart & time <= displayEnd;
if nnz(historyMask) < 3
    historyMask = true(size(time));
    historyStart = time(1);
end
modelHistoryMask = model.time >= historyStart & model.time <= displayEnd;
if nnz(modelHistoryMask) < 3
    modelHistoryMask = true(size(model.time));
end

lastCycleEnd = displayEnd;
lastCycleStart = max(time(1), displayEnd - period);
lastCycleMask = time >= lastCycleStart & time <= lastCycleEnd;
if nnz(lastCycleMask) < 3
    lastCycleMask = true(size(time));
    lastCycleStart = time(1);
    lastCycleEnd = time(end);
end
modelLastCycleMask = model.time >= lastCycleStart & model.time <= lastCycleEnd;
if nnz(modelLastCycleMask) < 3
    modelLastCycleMask = true(size(model.time));
end
result.display.lastCycleStart = lastCycleStart;
result.display.lastCycleEnd = lastCycleEnd;
result.display.lastCycleMask = lastCycleMask;
result.display.modelLastCycleMask = modelLastCycleMask;
result.display.historyStart = historyStart;
result.display.historyEnd = displayEnd;
result.display.historyMask = historyMask;
result.display.modelHistoryMask = modelHistoryMask;

metrics.areaCl = local_nonoverlap_area(model.alphaDeg(modelLastCycleMask), model.cl(modelLastCycleMask), ...
    result.reference.alphaDeg(lastCycleMask), result.reference.cl(lastCycleMask));
if ~isempty(result.reference.cm)
    metrics.areaCm = local_nonoverlap_area(model.alphaDeg(modelLastCycleMask), model.cm(modelLastCycleMask), ...
        result.reference.alphaDeg(lastCycleMask), result.reference.cm(lastCycleMask));
else
    metrics.areaCm = NaN;
end
metrics.areaTotal = metrics.areaCl;
if isfinite(metrics.areaCm)
    metrics.areaTotal = metrics.areaTotal + metrics.areaCm;
end
metrics.total = metrics.areaTotal;
result.metrics = metrics;
end

function value = local_rmse(a, b)
value = sqrt(mean((a(:) - b(:)).^2, "omitnan"));
if ~isfinite(value)
    value = realmax("double") / 10;
end
end

function value = local_nonoverlap_area(alphaModel, coeffModel, alphaRef, coeffRef)
alphaModel = alphaModel(:);
coeffModel = coeffModel(:);
alphaRef = alphaRef(:);
coeffRef = coeffRef(:);
modelValid = isfinite(alphaModel) & isfinite(coeffModel);
refValid = isfinite(alphaRef) & isfinite(coeffRef);
alphaModel = alphaModel(modelValid);
coeffModel = coeffModel(modelValid);
alphaRef = alphaRef(refValid);
coeffRef = coeffRef(refValid);
if numel(alphaModel) < 3 || numel(alphaRef) < 3
    value = realmax("double") / 10;
    return;
end

warningState = warning("off", "MATLAB:polyshape:repairedBySimplify");
cleanup = onCleanup(@() warning(warningState));
try
    modelShape = polyshape(alphaModel, coeffModel, "Simplify", true);
    refShape = polyshape(alphaRef, coeffRef, "Simplify", true);
    overlapShape = intersect(modelShape, refShape);
    unionShape = union(modelShape, refShape);
    value = area(unionShape) - area(overlapShape);
catch
    value = realmax("double") / 10;
end
if ~isfinite(value)
    value = realmax("double") / 10;
end
end
