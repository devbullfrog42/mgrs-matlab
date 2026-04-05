function bool = isUtmString(utmString)
    %ISUTMSTRING Validate UTM coordinate string format
    %   TF = ISUTMSTRING(STR) returns true if STR is a valid UTM
    %   coordinate string, false otherwise. STR can be a string array.
    %
    %   Valid UTM format: "ZZH EEEEEE NNNNNNN"
    %   where:
    %       ZZ  - Zone number (1-60, 1 or 2 digits)
    %       H   - Hemisphere ('N' or 'S')
    %       EEEEEE - 6-digit easting (with leading zeros)
    %       NNNNNNN - 7-digit northing (with leading zeros)
    %
    %   Spaces are ignored. The function validates zone numbers,
    %   hemisphere letters, and digit counts.
    %
    %   Example:
    %       tf = mgrs.isUtmString("31N 166021 0000000");  % true
    %       tf = mgrs.isUtmString("invalid");             % false
    %
    %   See also: mgrs.isMgrsString, mgrs.UTM.fromString

    arguments
        utmString string
    end

    % Erase all spaces
    utmString = erase(utmString, " ");

    % Check each string
    bool = true(size(utmString));
    for ii = 1:numel(utmString)
        % Confirm there is only one letter
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

        % Confirm the zone string is either one or two digits and is a valid zone number.
        bool(ii) = bool(ii) && all(isstrprop(zoneString, "digit"));
        bool(ii) = bool(ii) && (strlength(zoneString) == 1 || strlength(zoneString) == 2);
        if bool(ii)
            zoneNumber = str2double(zoneString);
            bool(ii) = zoneNumber <= mgrs.MGRSConstants.MAX_ZONE_NUMBER && zoneNumber >= mgrs.MGRSConstants.MIN_ZONE_NUMBER;
        end

        % Confirm the easting/northing string is 13 digits exactly.
        bool(ii) = bool(ii) && all(isstrprop(eastingNorthingString, "digit"));
        bool(ii) = bool(ii) && (strlength(eastingNorthingString) == 13);
    end

end