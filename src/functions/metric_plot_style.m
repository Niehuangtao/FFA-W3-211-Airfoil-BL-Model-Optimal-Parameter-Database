function style = metric_plot_style(metricName)
%METRIC_PLOT_STYLE Visual style for each optimization metric.

    metricName = normalize_metric_name(metricName);

    switch metricName
        case 'NOA'
            style.Label = 'NOA';
            style.LineStyle = '--';
            style.Marker = 'none';
            style.Color = [65 137 200] / 255;
        case 'DTW'
            style.Label = 'DTW';
            style.LineStyle = '*--';
            style.Marker = '*';
            style.Color = [165 165 141] / 255;
        case 'ARE'
            style.Label = 'ARE';
            style.LineStyle = 'o--';
            style.Marker = 'o';
            style.Color = [237 179 39] / 255;
        case 'MSE'
            style.Label = 'MSE';
            style.LineStyle = 'x--';
            style.Marker = 'x';
            style.Color = [65 137 200] / 255;
        otherwise
            style.Label = metricName;
            style.LineStyle = '--';
            style.Marker = 'none';
            style.Color = [0 0 0];
    end
end
