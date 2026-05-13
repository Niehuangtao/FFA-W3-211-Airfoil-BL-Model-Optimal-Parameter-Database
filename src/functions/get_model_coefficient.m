function values = get_model_coefficient(model, coefficientName)
%GET_MODEL_COEFFICIENT Return a named coefficient vector from a model response.

    coefficientName = upper(strtrim(char(coefficientName)));

    switch coefficientName
        case 'CN'
            values = model.CN;
        case 'CL'
            values = model.CL;
        case 'CD'
            values = model.CD;
        case 'CM'
            values = model.CM;
        otherwise
            error('BL:UnknownCoefficient', 'Unsupported coefficient name: %s', coefficientName);
    end

    values = values(:);
end
