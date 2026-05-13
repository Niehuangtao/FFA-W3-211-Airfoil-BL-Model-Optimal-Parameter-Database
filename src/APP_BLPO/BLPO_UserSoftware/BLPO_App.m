classdef BLPO_App < handle
    %BLPO_APP Visual software for user-defined BL model optimization.

    properties
        Root
        Figure
        MeanEdit
        AmpEdit
        PhaseEdit
        ReEdit
        UEdit
        KEdit
        ChordEdit
        CyclesEdit
        StepsEdit
        ReferenceEdit
        PolarEdit
        OutputEdit
        ModeDropDown
        PopEdit
        GenEdit
        LocalSearchCheck
        ParallelCheck
        StatusLabel
        MetricsLabel
        ProgressGauge
        ProgressLabel
        TimeAxes
        PolarAxes
        CmTimeAxes
        CmPolarAxes
        ParameterTable
        LogArea
        LastSetcase
        LastResult
    end

    methods
        function app = BLPO_App(options)
            arguments
                options.Visible (1,1) string = "on"
            end

            app.Root = fileparts(mfilename("fullpath"));
            addpath(fullfile(app.Root, "functions"));
            app.buildUI(options.Visible);
            app.setDefaults();
            app.appendLog("BLPO software ready. Import 2-column experiment data or 4-column CFD data, then preview or optimize.");
        end

        function delete(app)
            if ~isempty(app.Figure) && isvalid(app.Figure)
                delete(app.Figure);
            end
        end

        function preview(app)
            app.onPreview();
        end

        function optimize(app)
            app.onOptimize();
        end

        function exportCurrent(app)
            app.onExport();
        end
    end

    methods (Access = private)
        function buildUI(app, visible)
            app.Figure = uifigure("Name", "BLPO Dynamic Stall Parameter Optimization", ...
                "Position", [80 60 1480 820], "Visible", visible);

            rootGrid = uigridlayout(app.Figure, [1 2]);
            rootGrid.ColumnWidth = {360, "1x"};
            rootGrid.RowHeight = {"1x"};
            rootGrid.Padding = [12 12 12 12];
            rootGrid.ColumnSpacing = 12;

            leftPanel = uipanel(rootGrid, "Title", "Case setup");
            leftPanel.Layout.Row = 1;
            leftPanel.Layout.Column = 1;
            leftGrid = uigridlayout(leftPanel, [27 2]);
            leftGrid.ColumnWidth = {145, "1x"};
            leftGrid.RowHeight = repmat({22}, 1, 27);
            leftGrid.Padding = [10 6 10 6];
            leftGrid.RowSpacing = 3;

            sectionLabel = uilabel(leftGrid, "Text", "Motion condition", "FontWeight", "bold");
            sectionLabel.Layout.Row = 1;
            sectionLabel.Layout.Column = [1 2];

            app.MeanEdit = app.addNumeric(leftGrid, 2, "Mean angle (deg)", 5);
            app.AmpEdit = app.addNumeric(leftGrid, 3, "Amplitude (deg)", 10);
            app.PhaseEdit = app.addNumeric(leftGrid, 4, "Phase (deg)", 0);
            app.ReEdit = app.addNumeric(leftGrid, 5, "Reynolds number", 1e6);
            app.UEdit = app.addNumeric(leftGrid, 6, "Velocity U (m/s)", 10);
            app.KEdit = app.addNumeric(leftGrid, 7, "Reduced freq. k", 0.31);
            app.ChordEdit = app.addNumeric(leftGrid, 8, "Chord c (m)", 1);
            app.CyclesEdit = app.addNumeric(leftGrid, 9, "Cycles", 10);
            app.StepsEdit = app.addNumeric(leftGrid, 10, "Steps per cycle", 500);

            dataTitle = uilabel(leftGrid, "Text", "Reference and output", "FontWeight", "bold");
            dataTitle.Layout.Row = 11;
            dataTitle.Layout.Column = [1 2];
            app.ReferenceEdit = app.addPathPicker(leftGrid, 12, "Reference file", @(~,~) app.onBrowseReference());
            app.PolarEdit = app.addPathPicker(leftGrid, 13, "Airfoil polar", @(~,~) app.onBrowsePolar());
            app.OutputEdit = app.addPathPicker(leftGrid, 14, "Output folder", @(~,~) app.onBrowseOutput());

            optTitle = uilabel(leftGrid, "Text", "Optimization", "FontWeight", "bold");
            optTitle.Layout.Row = 15;
            optTitle.Layout.Column = [1 2];
            modeLabel = uilabel(leftGrid, "Text", "Mode");
            modeLabel.Layout.Row = 16;
            modeLabel.Layout.Column = 1;
            app.ModeDropDown = uidropdown(leftGrid, "Items", ["full","lag","cl","cm"], "Value", "full");
            app.ModeDropDown.Layout.Row = 16;
            app.ModeDropDown.Layout.Column = 2;
            app.PopEdit = app.addNumeric(leftGrid, 17, "Population size", 24);
            app.GenEdit = app.addNumeric(leftGrid, 18, "Max generations", 8);
            app.LocalSearchCheck = uicheckbox(leftGrid, "Text", "Run local search after GA", "Value", true);
            app.LocalSearchCheck.Layout.Row = 19;
            app.LocalSearchCheck.Layout.Column = [1 2];
            app.ParallelCheck = uicheckbox(leftGrid, "Text", "Use parallel pool when available", "Value", false);
            app.ParallelCheck.Layout.Row = 20;
            app.ParallelCheck.Layout.Column = [1 2];

            previewButton = uibutton(leftGrid, "push", "Text", "Preview default model", ...
                "ButtonPushedFcn", @(~,~) app.onPreview());
            previewButton.Layout.Row = 21;
            previewButton.Layout.Column = [1 2];
            runButton = uibutton(leftGrid, "push", "Text", "Run optimization", ...
                "ButtonPushedFcn", @(~,~) app.onOptimize());
            runButton.Layout.Row = 22;
            runButton.Layout.Column = [1 2];
            exportButton = uibutton(leftGrid, "push", "Text", "Export last result", ...
                "ButtonPushedFcn", @(~,~) app.onExport());
            exportButton.Layout.Row = 23;
            exportButton.Layout.Column = [1 2];

            app.ProgressLabel = uilabel(leftGrid, "Text", "Progress: 0%");
            app.ProgressLabel.Layout.Row = 24;
            app.ProgressLabel.Layout.Column = [1 2];
            app.ProgressGauge = uigauge(leftGrid, "linear", "Limits", [0 100], "Value", 0);
            app.ProgressGauge.Layout.Row = 25;
            app.ProgressGauge.Layout.Column = [1 2];
            app.StatusLabel = uilabel(leftGrid, "Text", "Status: idle", "FontWeight", "bold");
            app.StatusLabel.Layout.Row = 26;
            app.StatusLabel.Layout.Column = [1 2];
            app.MetricsLabel = uilabel(leftGrid, "Text", "Objective: -");
            app.MetricsLabel.Layout.Row = 27;
            app.MetricsLabel.Layout.Column = [1 2];

            rightGrid = uigridlayout(rootGrid, [3 3]);
            rightGrid.Layout.Row = 1;
            rightGrid.Layout.Column = 2;
            rightGrid.RowHeight = {"1x", "1x", 130};
            rightGrid.ColumnWidth = {"1x", "1x", 300};
            rightGrid.Padding = [0 0 0 0];
            rightGrid.RowSpacing = 10;
            rightGrid.ColumnSpacing = 10;

            app.TimeAxes = uiaxes(rightGrid);
            app.TimeAxes.Layout.Row = 1;
            app.TimeAxes.Layout.Column = 1;
            title(app.TimeAxes, "Time-history comparison");
            xlabel(app.TimeAxes, "Time (s)");
            ylabel(app.TimeAxes, "C_L");
            grid(app.TimeAxes, "on");

            app.PolarAxes = uiaxes(rightGrid);
            app.PolarAxes.Layout.Row = 1;
            app.PolarAxes.Layout.Column = 2;
            title(app.PolarAxes, "Lift loop");
            xlabel(app.PolarAxes, "Angle of attack (deg)");
            ylabel(app.PolarAxes, "C_L");
            grid(app.PolarAxes, "on");

            app.CmTimeAxes = uiaxes(rightGrid);
            app.CmTimeAxes.Layout.Row = 2;
            app.CmTimeAxes.Layout.Column = 1;
            title(app.CmTimeAxes, "Moment time history");
            xlabel(app.CmTimeAxes, "Time (s)");
            ylabel(app.CmTimeAxes, "C_M");
            grid(app.CmTimeAxes, "on");

            app.CmPolarAxes = uiaxes(rightGrid);
            app.CmPolarAxes.Layout.Row = 2;
            app.CmPolarAxes.Layout.Column = 2;
            title(app.CmPolarAxes, "Moment loop");
            xlabel(app.CmPolarAxes, "Angle of attack (deg)");
            ylabel(app.CmPolarAxes, "C_M");
            grid(app.CmPolarAxes, "on");

            app.ParameterTable = uitable(rightGrid);
            app.ParameterTable.Layout.Row = [1 2];
            app.ParameterTable.Layout.Column = 3;
            app.ParameterTable.ColumnName = {"Parameter", "Value"};

            app.LogArea = uitextarea(rightGrid, "Editable", "off");
            app.LogArea.Layout.Row = 3;
            app.LogArea.Layout.Column = [1 3];
        end

        function edit = addNumeric(~, grid, row, label, defaultValue)
            lab = uilabel(grid, "Text", label);
            lab.Layout.Row = row;
            lab.Layout.Column = 1;
            edit = uieditfield(grid, "numeric", "Value", defaultValue);
            edit.Layout.Row = row;
            edit.Layout.Column = 2;
        end

        function edit = addPathPicker(~, grid, row, label, callback)
            lab = uilabel(grid, "Text", label);
            lab.Layout.Row = row;
            lab.Layout.Column = 1;
            sub = uigridlayout(grid, [1 2]);
            sub.Layout.Row = row;
            sub.Layout.Column = 2;
            sub.ColumnWidth = {"1x", 34};
            sub.Padding = [0 0 0 0];
            sub.ColumnSpacing = 4;
            edit = uieditfield(sub, "text");
            edit.Layout.Row = 1;
            edit.Layout.Column = 1;
            btn = uibutton(sub, "push", "Text", "...", "ButtonPushedFcn", callback);
            btn.Layout.Row = 1;
            btn.Layout.Column = 2;
        end

        function setDefaults(app)
            cfg = BLPO_sample_config();
            app.MeanEdit.Value = cfg.meanAngleDeg;
            app.AmpEdit.Value = cfg.amplitudeDeg;
            app.PhaseEdit.Value = cfg.phaseDeg;
            app.ReEdit.Value = cfg.Re;
            app.UEdit.Value = cfg.U;
            app.KEdit.Value = cfg.reducedFrequency;
            app.ChordEdit.Value = cfg.chord;
            app.CyclesEdit.Value = cfg.cycles;
            app.StepsEdit.Value = cfg.stepsPerCycle;
            app.ReferenceEdit.Value = fullfile(app.Root, "sample_data", "sample_reference_experiment_2col.csv");
            app.PolarEdit.Value = cfg.polarFile;
            app.OutputEdit.Value = fullfile(app.Root, "output");

            defaults = BLPO_default_parameters();
            app.ParameterTable.Data = [defaults.labels(:), num2cell(defaults.vector(:))];
        end

        function cfg = getConfig(app)
            cfg = BLPO_sample_config();
            cfg.meanAngleDeg = app.MeanEdit.Value;
            cfg.amplitudeDeg = app.AmpEdit.Value;
            cfg.phaseDeg = app.PhaseEdit.Value;
            cfg.Re = app.ReEdit.Value;
            cfg.U = app.UEdit.Value;
            cfg.reducedFrequency = app.KEdit.Value;
            cfg.chord = app.ChordEdit.Value;
            cfg.cycles = app.CyclesEdit.Value;
            cfg.stepsPerCycle = app.StepsEdit.Value;
            cfg.polarFile = app.PolarEdit.Value;
        end

        function setStatus(app, text)
            app.StatusLabel.Text = "Status: " + string(text);
            drawnow;
        end

        function setProgress(app, fraction, text)
            fraction = max(0, min(1, double(fraction)));
            percent = round(100 * fraction);
            app.ProgressGauge.Value = percent;
            app.ProgressLabel.Text = sprintf("Progress: %d%% - %s", percent, char(text));
            drawnow limitrate;
        end

        function appendLog(app, message)
            stamp = string(datetime("now", "Format", "HH:mm:ss"));
            line = stamp + "  " + string(message);
            app.LogArea.Value = [app.LogArea.Value; line];
            drawnow;
        end

        function setResult(app, result)
            app.LastResult = result;
            defaults = BLPO_default_parameters();
            if isfield(result, "initial")
                app.ParameterTable.ColumnName = {"Parameter", "Initial", "Optimized"};
                app.ParameterTable.Data = [defaults.labels(:), num2cell(result.initial.param(:)), num2cell(result.param(:))];
            else
                app.ParameterTable.ColumnName = {"Parameter", "Value"};
                app.ParameterTable.Data = [defaults.labels(:), num2cell(result.param(:))];
            end
            app.MetricsLabel.Text = sprintf("Area objective: %.5g | Cl %.5g | Cm %.5g", ...
                result.metrics.total, result.metrics.areaCl, result.metrics.areaCm);
            app.plotResult(result);
        end

        function plotResult(app, result)
            timeMask = app.timeDisplayMask(result);
            modelTimeMask = app.modelTimeDisplayMask(result);
            loopMask = app.loopDisplayMask(result);
            modelLoopMask = app.modelLoopDisplayMask(result);
            hasInitial = isfield(result, "initial");

            cla(app.TimeAxes);
            plot(app.TimeAxes, result.reference.time(timeMask), result.reference.cl(timeMask), "k-", "LineWidth", 1.4);
            hold(app.TimeAxes, "on");
            if hasInitial
                plot(app.TimeAxes, result.fit.time(timeMask), result.initial.fit.cl(timeMask), "Color", [0.35 0.35 0.35], "LineStyle", ":", "LineWidth", 1.2);
            end
            plot(app.TimeAxes, result.fit.time(timeMask), result.fit.cl(timeMask), "r--", "LineWidth", 1.3);
            if hasInitial
                legend(app.TimeAxes, "Ref Cl", "Init Cl", "Opt Cl", "Location", "best");
            else
                legend(app.TimeAxes, "Ref Cl", "BL Cl", "Location", "best");
            end
            title(app.TimeAxes, "Time-history comparison (last 3 cycles)");
            grid(app.TimeAxes, "on");

            cla(app.PolarAxes);
            [refAlpha, refCl] = app.closedLoop(result.reference.alphaDeg(loopMask), result.reference.cl(loopMask));
            plot(app.PolarAxes, refAlpha, refCl, "k-", "LineWidth", 1.4);
            hold(app.PolarAxes, "on");
            if hasInitial
                [initAlpha, initCl] = app.closedLoop(result.initial.model.alphaDeg(modelLoopMask), result.initial.model.cl(modelLoopMask));
                plot(app.PolarAxes, initAlpha, initCl, "Color", [0.35 0.35 0.35], "LineStyle", ":", "LineWidth", 1.2);
            end
            [optAlpha, optCl] = app.closedLoop(result.model.alphaDeg(modelLoopMask), result.model.cl(modelLoopMask));
            plot(app.PolarAxes, optAlpha, optCl, "r--", "LineWidth", 1.3);
            if hasInitial
                legend(app.PolarAxes, "Reference", "Initial", "Optimized", "Location", "best");
            else
                legend(app.PolarAxes, "Reference", "BL model", "Location", "best");
            end
            title(app.PolarAxes, "Lift loop (last cycle)");
            grid(app.PolarAxes, "on");

            cla(app.CmTimeAxes);
            if ~isempty(result.reference.cm)
                plot(app.CmTimeAxes, result.reference.time(timeMask), result.reference.cm(timeMask), "k-", "LineWidth", 1.4);
                hold(app.CmTimeAxes, "on");
                if hasInitial
                    plot(app.CmTimeAxes, result.fit.time(timeMask), result.initial.fit.cm(timeMask), "Color", [0.35 0.35 0.35], "LineStyle", ":", "LineWidth", 1.2);
                end
                plot(app.CmTimeAxes, result.fit.time(timeMask), result.fit.cm(timeMask), "r--", "LineWidth", 1.3);
                if hasInitial
                    legend(app.CmTimeAxes, "Ref Cm", "Init Cm", "Opt Cm", "Location", "best");
                else
                    legend(app.CmTimeAxes, "Ref Cm", "BL Cm", "Location", "best");
                end
            else
                if hasInitial
                    plot(app.CmTimeAxes, result.initial.model.time(modelTimeMask), result.initial.model.cm(modelTimeMask), "Color", [0.35 0.35 0.35], "LineStyle", ":", "LineWidth", 1.2);
                    hold(app.CmTimeAxes, "on");
                end
                plot(app.CmTimeAxes, result.model.time(modelTimeMask), result.model.cm(modelTimeMask), "r--", "LineWidth", 1.3);
                if hasInitial
                    legend(app.CmTimeAxes, "Initial", "Optimized", "Location", "best");
                else
                    legend(app.CmTimeAxes, "BL model", "Location", "best");
                end
            end
            title(app.CmTimeAxes, "Moment time history (last 3 cycles)");
            grid(app.CmTimeAxes, "on");

            cla(app.CmPolarAxes);
            if ~isempty(result.reference.cm)
                [refAlphaCm, refCm] = app.closedLoop(result.reference.alphaDeg(loopMask), result.reference.cm(loopMask));
                plot(app.CmPolarAxes, refAlphaCm, refCm, "k-", "LineWidth", 1.4);
                hold(app.CmPolarAxes, "on");
            end
            if hasInitial
                [initAlphaCm, initCm] = app.closedLoop(result.initial.model.alphaDeg(modelLoopMask), result.initial.model.cm(modelLoopMask));
                plot(app.CmPolarAxes, initAlphaCm, initCm, "Color", [0.35 0.35 0.35], "LineStyle", ":", "LineWidth", 1.2);
                hold(app.CmPolarAxes, "on");
            end
            [optAlphaCm, optCm] = app.closedLoop(result.model.alphaDeg(modelLoopMask), result.model.cm(modelLoopMask));
            plot(app.CmPolarAxes, optAlphaCm, optCm, "r--", "LineWidth", 1.3);
            if ~isempty(result.reference.cm)
                if hasInitial
                    legend(app.CmPolarAxes, "Reference", "Initial", "Optimized", "Location", "best");
                else
                    legend(app.CmPolarAxes, "Reference", "BL model", "Location", "best");
                end
            elseif hasInitial
                legend(app.CmPolarAxes, "Initial", "Optimized", "Location", "best");
            else
                legend(app.CmPolarAxes, "BL model", "Location", "best");
            end
            title(app.CmPolarAxes, "Moment loop (last cycle)");
            grid(app.CmPolarAxes, "on");
        end

        function mask = timeDisplayMask(~, result)
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

        function mask = modelTimeDisplayMask(~, result)
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

        function mask = loopDisplayMask(~, result)
            if isfield(result, "display") && isfield(result.display, "lastCycleMask")
                mask = result.display.lastCycleMask;
            else
                mask = true(size(result.reference.time));
            end
            if nnz(mask) < 3
                mask = true(size(result.reference.time));
            end
        end

        function mask = modelLoopDisplayMask(~, result)
            if isfield(result, "display") && isfield(result.display, "modelLastCycleMask")
                mask = result.display.modelLastCycleMask;
            else
                mask = true(size(result.model.time));
            end
            if nnz(mask) < 3
                mask = true(size(result.model.time));
            end
        end

        function [x, y] = closedLoop(~, x, y)
            x = x(:);
            y = y(:);
            if numel(x) >= 2 && (x(end) ~= x(1) || y(end) ~= y(1))
                x(end + 1) = x(1);
                y(end + 1) = y(1);
            end
        end

        function onBrowseReference(app)
            [file, path] = uigetfile({"*.csv;*.txt;*.dat;*.out", "Data files"; "*.*", "All files"}, "Select reference data");
            if isequal(file, 0)
                return;
            end
            app.ReferenceEdit.Value = fullfile(path, file);
        end

        function onBrowsePolar(app)
            [file, path] = uigetfile({"*.csv;*.txt;*.dat;*.out", "Polar files"; "*.*", "All files"}, "Select airfoil polar file");
            if isequal(file, 0)
                return;
            end
            app.PolarEdit.Value = fullfile(path, file);
        end

        function onBrowseOutput(app)
            path = uigetdir(app.OutputEdit.Value, "Select output folder");
            if isequal(path, 0)
                return;
            end
            app.OutputEdit.Value = path;
        end

        function onPreview(app)
            try
                app.setProgress(0, "starting preview");
                app.setStatus("building case");
                app.appendLog("Reading reference data and previewing baseline parameters.");
                app.setProgress(0.20, "reading inputs");
                cfg = app.getConfig();
                app.LastSetcase = BLPO_build_setcase(cfg, string(app.ReferenceEdit.Value));
                app.setProgress(0.50, "evaluating default model");
                params = BLPO_default_parameters();
                result = BLPO_evaluate(params.vector, app.LastSetcase);
                app.setProgress(0.80, "plotting result");
                app.setResult(result);
                app.setStatus("preview complete");
                app.setProgress(1.00, "preview complete");
                app.appendLog("Preview complete. Reference type: " + app.LastSetcase.reference.kind + ...
                    ", rows: " + string(app.LastSetcase.reference.nRows) + ".");
            catch ME
                app.setStatus("error");
                app.setProgress(0, "error");
                app.appendLog("Error: " + ME.message);
                uialert(app.Figure, ME.message, "BLPO preview error");
            end
        end

        function onOptimize(app)
            try
                app.setProgress(0, "starting optimization");
                app.setStatus("optimizing");
                app.appendLog("Optimization started. This may take several minutes for larger populations.");
                app.setProgress(0.03, "reading inputs");
                cfg = app.getConfig();
                app.LastSetcase = BLPO_build_setcase(cfg, string(app.ReferenceEdit.Value));
                app.setProgress(0.06, "building optimizer");
                [~, result, history] = BLPO_optimize(app.LastSetcase, ...
                    Mode=string(app.ModeDropDown.Value), ...
                    PopulationSize=app.PopEdit.Value, ...
                    MaxGenerations=app.GenEdit.Value, ...
                    UseParallel=app.ParallelCheck.Value, ...
                    RunLocalSearch=app.LocalSearchCheck.Value, ...
                    Display="iter", ...
                    ProgressFcn=@(fraction, message) app.setProgress(fraction, message));
                app.setProgress(0.97, "plotting and exporting");
                app.setResult(result);
                files = BLPO_export_results(result, string(app.OutputEdit.Value));
                app.setStatus("optimization complete");
                app.setProgress(1.00, "optimization complete");
                app.appendLog(sprintf("Optimization complete. Initial %.5g, final %.5g.", ...
                    history.initialFitness, result.metrics.total));
                app.appendLog("Results exported to " + string(app.OutputEdit.Value));
                app.appendLog("Figure: " + string(files.figure));
            catch ME
                app.setStatus("error");
                app.setProgress(0, "error");
                app.appendLog("Error: " + ME.message);
                uialert(app.Figure, ME.message, "BLPO optimization error");
            end
        end

        function onExport(app)
            try
                if isempty(app.LastResult)
                    app.onPreview();
                end
                files = BLPO_export_results(app.LastResult, string(app.OutputEdit.Value));
                app.setStatus("export complete");
                app.setProgress(1.00, "export complete");
                app.appendLog("Last result exported to " + string(app.OutputEdit.Value));
                app.appendLog("Metrics: " + string(files.metrics));
            catch ME
                app.setStatus("error");
                app.appendLog("Error: " + ME.message);
                uialert(app.Figure, ME.message, "BLPO export error");
            end
        end
    end
end
