function plot_bl_metric_comparison(collections, setcase, plotConfig, outputDir)
%PLOT_BL_METRIC_COMPARISON Plot optimized curves against default and reference data.

    if nargin < 3 || isempty(plotConfig)
        plotConfig = struct();
    end
    if nargin < 4 || isempty(outputDir)
        outputDir = pwd;
    end

    metricNames = fieldnames(collections);
    if isempty(metricNames)
        error('BL:NoCollections', 'No metric collections are available to plot.');
    end

    stride = get_struct_value(plotConfig, 'sampleStride', 10);
    fontSize = get_struct_value(plotConfig, 'fontSize', 15);
    lineWidth = get_struct_value(plotConfig, 'lineWidth', 1.2);
    fileBaseName = get_struct_value(plotConfig, 'fileBaseName', 'opt_compare');

    fig = figure('Color', 'w');
    ax = axes(fig);
    hold(ax, 'on');
    firstMetric = metricNames{1};
    firstCollection = collections.(firstMetric);
    isLoopData = ~isfield(firstCollection, 'mode') || strcmp(firstCollection.mode, 'alphaCoefficient');

    for iMetric = 1:numel(metricNames)
        metricName = metricNames{iMetric};
        if isLoopData
            curve = close_curve(collections.(metricName).optimized, stride);
        else
            curve = sample_curve(collections.(metricName).optimized, stride);
        end
        style = metric_plot_style(metricName);
        plot(ax, curve(:, 1), curve(:, 2), style.LineStyle, ...
            'LineWidth', lineWidth, ...
            'Color', style.Color, ...
            'Marker', style.Marker, ...
            'DisplayName', style.Label);
    end

    if isLoopData
        defaultCurve = close_curve(firstCollection.default, stride);
        refCurve = close_curve(firstCollection.reference, 1);
    else
        defaultCurve = sample_curve(firstCollection.default, stride);
        refCurve = sample_curve(firstCollection.reference, stride);
    end

    plot(ax, defaultCurve(:, 1), defaultCurve(:, 2), ...
        'LineWidth', lineWidth, ...
        'Color', [107 112 92] / 255, ...
        'DisplayName', 'Default');
    plot(ax, refCurve(:, 1), refCurve(:, 2), ...
        'LineWidth', lineWidth, ...
        'Color', [58 9 100] / 255, ...
        'DisplayName', 'Reference');

    conditions = setcase.conditions;
    title(ax, sprintf('$\\alpha_0=%.1f^\\circ$, $A=%d^\\circ$, $Re=%.0E$, $k=%.3f$', ...
        setcase.meanangle, setcase.averageangle, conditions.Re, conditions.k), ...
        'Interpreter', 'latex', ...
        'FontName', 'Times New Roman', ...
        'FontSize', fontSize);

    xlabel(ax, firstCollection.xLabel, 'FontName', 'Times New Roman', 'FontSize', fontSize);
    ylabel(ax, firstCollection.yLabel, 'FontName', 'Times New Roman', 'FontSize', fontSize);
    legend(ax, 'Location', 'northwest', 'FontName', 'Times New Roman');
    grid(ax, 'on');
    box(ax, 'on');

    pngFile = fullfile(outputDir, sprintf('%s.png', fileBaseName));
    pdfFile = fullfile(outputDir, sprintf('%s.pdf', fileBaseName));
    saveas(fig, pngFile);
    exportgraphics(fig, pdfFile, 'ContentType', 'vector');
end
