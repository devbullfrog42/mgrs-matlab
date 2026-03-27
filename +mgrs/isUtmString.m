function bool = isUtmString(utmString)

    arguments
        utmString string
    end

    matchingIndices = regexpi(utmString, '^\d{1,2}[NS] *\d{6} *\d{7}$','once');
    bool = cellfun(@(x) ~isempty(x), matchingIndices);
end