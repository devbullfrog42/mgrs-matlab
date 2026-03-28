function bool = isUtmString(utmString)

    arguments
        utmString string
    end

    % Erase all spaces
    utmString = erase(utmString, " ");

    % Check each string
    bool = true(size(utmString));
    for ii = 1:numel(utmString)
        % Confirm there is only on letter
        letters = isletter(utmString(ii));
        bool(ii) = bool(ii) && (sum(letters) == 1);
        if ~bool(ii)
            continue
        end

        % Confirm the letter is either 'N' or 'S'
        hemisphereLetterPos = find(letters);
        hemisphereLetter = utmString(ii).extract(hemisphereLetterPos);
        bool(ii) = bool(ii) && (any(strcmpi(hemisphereLetter, ["N" "S"])));
        if ~bool(ii)
            continue
        end

        % Split at the letter to make zone and easting/northing strings
        zoneString = extractBefore(utmString(ii), hemisphereLetterPos);
        eastingNorthingString = extractAfter(utmString(ii), hemisphereLetterPos);

        % Confirm the zone string is either one or two digits.
        bool(ii) = bool(ii) && all(isstrprop(zoneString, "digit"));
        bool(ii) = bool(ii) && (strlength(zoneString) == 1 || strlength(zoneString) == 2);

        % Confirm the easting/northing string is 13 digits exactly.
        bool(ii) = bool(ii) && all(isstrprop(eastingNorthingString, "digit"));
        bool(ii) = bool(ii) && (strlength(eastingNorthingString) == 13);
    end

end