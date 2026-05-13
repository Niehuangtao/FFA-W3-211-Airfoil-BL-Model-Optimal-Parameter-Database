function BLPO_save_comparison_figure(result, filename)
%BLPO_SAVE_COMPARISON_FIGURE Save model/reference comparison plots.

arguments
    result struct
    filename (1,1) string
end

timeMask = local_time_mask(result);
modelTimeMask = local_model_time_mask(result);
loopMask = local_loop_mask(result);
modelLoopMask = local_model_loop_mask(result);
hasInitial = isfield(result, "initial");

fig = figure("Visible", "off", "Color", "w", "Position", [100 100 1200 760]);
tiledlayout(fig, 2, 2, "TileSpacing", "compact", "Padding", "compact");

nexttile;
plot(result.reference.time(timeMask), result.reference.cl(timeMask), "k-", "LineWidth", 1.5);
hold on;
if hasInitial
    plot(result.fit.time(timeMask), result.initial.fit.cl(timeMask), "Color", [0.35 0.35 0.35], "LineStyle", ":", "LineWidth", 1.3);
end
plot(result.fit.time(timeMask), result.fit.cl(timeMask), "r--", "LineWidth", 1.4);
grid on;
xlabel("Time (s)");
ylabel("C_L");
title(sprintf("Lift coefficient, last 3 cycles, area = %.5g", result.metrics.areaCl));
local_legend(hasInitial, true);

nexttile;
[refAlpha, refCl] = local_closed_loop(result.reference.alphaDeg(loopMask), result.reference.cl(loopMask));
plot(refAlpha, refCl, "k-", "LineWidth", 1.5);
hold on;
if hasInitial
    [initAlpha, initCl] = local_closed_loop(result.initial.model.alphaDeg(modelLoopMask), result.initial.model.cl(modelLoopMask));
    plot(initAlpha, initCl, "Color", [0.35 0.35 0.35], "LineStyle", ":", "LineWidth", 1.3);
end
[optAlpha, optCl] = local_closed_loop(result.model.alphaDeg(modelLoopMask), result.model.cl(modelLoopMask));
plot(optAlpha, optCl, "r--", "LineWidth", 1.4);
grid on;
xlabel("Angle of attack (deg)");
ylabel("C_L");
title("Lift loop, last cycle");
local_legend(hasInitial, true);

nexttile;
if ~isempty(result.reference.cm)
    plot(result.reference.time(timeMask), result.reference.cm(timeMask), "k-", "LineWidth", 1.5);
    hold on;
    if hasInitial
        plot(result.fit.time(timeMask), result.initial.fit.cm(timeMask), "Color", [0.35 0.35 0.35], "LineStyle", ":", "LineWidth", 1.3);
    end
    plot(result.fit.time(timeMask), result.fit.cm(timeMask), "r--", "LineWidth", 1.4);
    hasReference = true;
else
    if hasInitial
        plot(result.initial.model.time(modelTimeMask), result.initial.model.cm(modelTimeMask), "Color", [0.35 0.35 0.35], "LineStyle", ":", "LineWidth", 1.3);
        hold on;
    end
    plot(result.model.time(modelTimeMask), result.model.cm(modelTimeMask), "r--", "LineWidth", 1.4);
    hasReference = false;
end
grid on;
xlabel("Time (s)");
ylabel("C_M");
title(sprintf("Moment coefficient, last 3 cycles, area = %.5g", result.metrics.areaCm));
local_legend(hasInitial, hasReference);

nexttile;
if ~isempty(result.reference.cm)
    [refAlphaCm, refCm] = local_closed_loop(result.reference.alphaDeg(loopMask), result.reference.cm(loopMask));
    plot(refAlphaCm, refCm, "k-", "LineWidth", 1.5);
    hold on;
    hasReference = true;
else
    hasReference = false;
end
if hasInitial
    [initAlphaCm, initCm] = local_closed_loop(result.initial.model.alphaDeg(modelLoopMask), result.initial.model.cm(modelLoopMask));
    plot(initAlphaCm, initCm, "Color", [0.35 0.35 0.35], "LineStyle", ":", "LineWidth", 1.3);
    hold on;
end
[optAlphaCm, optCm] = local_closed_loop(result.model.alphaDeg(modelLoopMask), result.model.cm(modelLoopMask));
plot(optAlphaCm, optCm, "r--", "LineWidth", 1.4);
grid on;
xlabel("Angle of attack (deg)");
ylabel("C_M");
title("Moment loop, last cycle");
local_legend(hasInitial, hasReference);

exportgraphics(fig, filename, "Resolution", 180);
close(fig);
end

function mask = local_time_mask(result)
if isfield(result, "display") && isfield(result.display, "historyMask")
    mask = result.display.historyMask;
elseif isfield(result, "display") && isfield(result.display, "lastCycleMask")
    mask = result.display.lastCycleMask;
else
    mask = true(size(result.reference.time));
end
if nnz(mask) < 3
    mask = true(size(result.reference.time));
end
end

function mask = local_model_time_mask(result)
if isfield(result, "display") && isfield(result.display, "modelHistoryMask")
    mask = result.display.modelHistoryMask;
elseif isfield(result, "display") && isfield(result.display, "modelLastCycleMask")
    mask = result.display.modelLastCycleMask;
else
    mask = true(size(result.model.time));
end
if nnz(mask) < 3
    mask = true(size(result.model.time));
end
end

function mask = local_loop_mask(result)
if isfield(result, "display") && isfield(result.display, "lastCycleMask")
    mask = result.display.lastCycleMask;
else
    mask = true(size(result.reference.time));
end
if nnz(mask) < 3
    mask = true(size(result.reference.time));
end
end

function mask = local_model_loop_mask(result)
if isfield(result, "display") && isfield(result.display, "modelLastCycleMask")
    mask = result.display.modelLastCycleMask;
else
    mask = true(size(result.model.time));
end
if nnz(mask) < 3
    mask = true(size(result.model.time));
end
end

function [x, y] = local_closed_loop(x, y)
x = x(:);
y = y(:);
if numel(x) >= 2 && (x(end) ~= x(1) || y(end) ~= y(1))
    x(end + 1) = x(1);
    y(end + 1) = y(1);
end
end

function local_legend(hasInitial, hasReference)
if hasReference
    if hasInitial
        legend("Reference", "Initial", "Optimized", "Location", "best");
    else
        legend("Reference", "BL model", "Location", "best");
    end
elseif hasInitial
    legend("Initial", "Optimized", "Location", "best");
else
    legend("BL model", "Location", "best");
end
end
