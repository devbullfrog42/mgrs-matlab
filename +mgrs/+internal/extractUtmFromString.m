function [zone, hemisphere, easting, northing] = extractUtmFromString(utmString)
    
    arguments
        utmString (1,1) string
    end

    % Erase all spaces
    utmString = erase(utmString, ' ');

    % Find the hemisphere letter.
    letterPosition = find(isletter(utmString));

    % Get zone.
    zoneStr = extractBefore(utmString, letterPosition);
    zone = uint8(str2double(zoneStr));

    % Get the hemisphere.
    if matches(utmString.extract(letterPosition), 'N', 'IgnoreCase', true)
        hemisphere = mgrs.Hemisphere.North;
    else
        hemisphere = mgrs.Hemisphere.South;
    end
    
    eastingNorthingString = extractAfter(utmString, letterPosition);

    % Get easting
    eastingStr = extractBefore(eastingNorthingString, 7);
    easting = str2double(eastingStr);

    % Get northing
    northingStr = extractAfter(eastingNorthingString, 6);
    northing = str2double(northingStr);
    
end