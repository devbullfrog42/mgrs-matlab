function [zone, band, column, row, easting, northing] = extractMgrsFromString(mgrsString)

    arguments
        mgrsString (1,1) string
    end

    % Erase all spaces.
    mgrsString = erase(mgrsString, ' ');

    % Find the band, column & row letters.
    letters = isletter(mgrsString);
    mgrsLetterPos = find(letters);

    % Get zone.
    zoneStr = extractBefore(mgrsString, mgrsLetterPos(1));
    zone = uint8(str2double(zoneStr));

    % Get band.
    band = char(mgrsString.extract(mgrsLetterPos(1)));

    % Get column.
    column = char(mgrsString.extract(mgrsLetterPos(2)));

    % Get row.
    row = char(mgrsString.extract(mgrsLetterPos(3)));

    eastingNorthingString = extractAfter(mgrsString, mgrsLetterPos(3));

    % Get easting
    eastingStr = extractBefore(eastingNorthingString, 6);
    easting = str2double(eastingStr);

    % Get northing
    northingStr = extractAfter(eastingNorthingString, 5);
    northing = str2double(northingStr);

end