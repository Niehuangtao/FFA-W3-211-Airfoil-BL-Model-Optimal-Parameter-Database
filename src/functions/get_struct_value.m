function value = get_struct_value(source, fieldName, defaultValue)
%GET_STRUCT_VALUE Read a struct field with a default fallback.

    if isstruct(source) && isfield(source, fieldName) && ~isempty(source.(fieldName))
        value = source.(fieldName);
    else
        value = defaultValue;
    end
end
