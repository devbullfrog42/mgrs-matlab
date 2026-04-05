function letter = getBandLetter(latitude_deg)
    %GETBANDLETTER Get latitude band letter from latitude
    %   LETTER = GETBANDLETTER(LAT) returns the MGRS latitude band
    %   letter (C-X) for the given latitude. Bands are 8° high except
    %   for the X band which is 12° high.
    %
    %   Input:
    %       LAT - Latitude in degrees (-90 to 90)
    %
    %   Output:
    %       LETTER - Band letter ('C' to 'X')
    %
    %   Example:
    %       band = mgrs.gridZone.getBandLetter(0);   % 'N'
    %       band = mgrs.gridZone.getBandLetter(80);  % 'X'
    %
    %   See also: mgrs.gridZone.getBandLimits, mgrs.gridZone.getZoneNumber

    arguments
        latitude_deg double {mustBeGreaterThanOrEqual(latitude_deg,-90), mustBeLessThanOrEqual(latitude_deg,90)}
    end

    % Scale latitude degrees to the band values 0 to 20 and the round down
    % to integer values.
    bandValue = (latitude_deg - mgrs.MGRSConstants.MIN_LAT) / mgrs.MGRSConstants.BAND_HEIGHT;
    bandNumber = uint8(floor(bandValue));

    % Correct for the 'X' band being 12 deg in width, instead of the 8 deg
    % of all the other bands.
    bandNumber(bandNumber >= mgrs.MGRSConstants.NUM_BANDS) = bandNumber(bandNumber >= mgrs.MGRSConstants.NUM_BANDS) - 1;
    
    letter = mgrs.internal.bandNumberToLetter(bandNumber);
end