function value = BLPO_objective(param, setcase, options)
%BLPO_OBJECTIVE Scalar objective for GA/fmincon.

arguments
    param
    setcase struct
    options.Target (1,1) string {mustBeMember(options.Target, ["total","cl","cm"])} = "total"
end

try
    result = BLPO_evaluate(param, setcase);
    switch options.Target
        case "cl"
            value = result.metrics.areaCl;
        case "cm"
            value = result.metrics.areaCm;
        otherwise
            value = result.metrics.total;
    end
catch
    value = realmax("double") / 10;
end

if ~isfinite(value)
    value = realmax("double") / 10;
end
end
