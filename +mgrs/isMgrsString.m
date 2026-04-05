function bool = isMgrsString(mgrsString)
    %ISMGRSSTRING Validate MGRS coordinate string format
    %   TF = ISMGRSTRING(STR) returns true if STR is a valid MGRS
    %   coordinate string, false otherwise. STR can be a string array.
    %
    %   Valid MGRS format: "ZZB CC EEEEE NNNNN"
    %   where:
    %       ZZ   - Zone number (1-60, 1 or 2 digits)
    %       B    - Band letter (C-X, excluding I and O)
    %       CC   - Column and row letters for 100km square
    %       EEEEE - 5-digit easting (0-99999)
    %       NNNNN - 5-digit northing (0-99999)
    %
    %   Spaces are ignored. The function validates zone numbers,
    %   band letters, column/row letters (zone-dependent), and digit counts.
    %
    %   Example:
    %       tf = mgrs.isMgrsString("31N AA 66021 00000");  % true
    %       tf = mgrs.isMgrsString("invalid");             % false
    %
    %   See also: mgrs.isUtmString, mgrs.MGRS.fromString

    arguments
        mgrsString string
    end

    % Erase all spaces
    mgrsString = erase(mgrsString, " ");

    % Check each string
    bool = true(size(mgrsString));
    for ii = 1:numel(mgrsString)
        % Confirm there are exactly three letters
        letters = isletter(mgrsString(ii));
        mgrsLetterPos = find(letters);
        bool(ii) = bool(ii) && (sum(letters) == 3);
        if ~bool(ii)
            continue
        end

        % Split at the letters to make zone and easting/northing strings
        zoneString = extractBefore(mgrsString(ii), mgrsLetterPos(1));
        eastingNorthingString = extractAfter(mgrsString(ii), mgrsLetterPos(3));

        % Confirm the zone string is either one or two digits and is a valid zone number.
        bool(ii) = bool(ii) && all(isstrprop(zoneString, "digit"));
        bool(ii) = bool(ii) && (strlength(zoneString) == 1 || strlength(zoneString) == 2);
        if bool(ii)
            zoneNumber = str2double(zoneString);
            bool(ii) = zoneNumber <= mgrs.MGRSConstants.MAX_ZONE_NUMBER && zoneNumber >= mgrs.MGRSConstants.MIN_ZONE_NUMBER;
        else
            continue
        end

        % Confirm band letter
        bandLetter = mgrsString(ii).extract(mgrsLetterPos(1));
        bool(ii) = bool(ii) && mgrs.internal.isBand(bandLetter);

        % Confirm column letter
        columnLetter = mgrsString(ii).extract(mgrsLetterPos(2));
        bool(ii) = bool(ii) && mgrs.internal.isColumn(columnLetter, zoneNumber);

        % Confirm row letter
        rowLetter = mgrsString(ii).extract(mgrsLetterPos(3));
        bool(ii) = bool(ii) && mgrs.internal.isRow(rowLetter, zoneNumber);

        % Confirm the easting/northing string is 13 digits exactly.
        bool(ii) = bool(ii) && all(isstrprop(eastingNorthingString, "digit"));
        bool(ii) = bool(ii) && (strlength(eastingNorthingString) == 10);
    end
end