function [minLat_deg, maxLat_deg] = getBandLimits(bandLetter)
    %GETBANDLIMITS Get latitude limits for a band letter
    %   [MINLAT, MAXLAT] = GETBANDLIMITS(LETTER) returns the latitude
    %   bounds in degrees for the given MGRS band letter.
    %
    %   Input:
    %       LETTER - Band letter ('C' to 'X')
    %
    %   Output:
    %       MINLAT - Minimum latitude for the band (degrees)
    %       MAXLAT - Maximum latitude for the band (degrees)
    %
    %   Example:
    %       [minLat, maxLat] = mgrs.gridZone.getBandLimits('N');
    %       % minLat = 0, maxLat = 8
    %
    %   See also: mgrs.gridZone.getBandLetter, mgrs.gridZone.getZoneLimits

    arguments
        bandLetter char {mgrs.internal.mustBeBand(bandLetter)}
    end

    % Get the band number (0 to 19)
    bandNumber = double(mgrs.internal.bandLetterToNumber(bandLetter));

    % Calculate the minimum latitude.
    minLat_deg = mgrs.MGRSConstants.MIN_LAT + bandNumber * mgrs.MGRSConstants.BAND_HEIGHT;

    % Calculate the maximum latitude.
    maxLat_deg = mgrs.MGRSConstants.MIN_LAT + (bandNumber + 1) * mgrs.MGRSConstants.BAND_HEIGHT;

    % Calculate the maximum latitude for the maximum band, based on its 12
    % deg height.
    maxLat_deg(bandLetter == mgrs.MGRSConstants.MAX_BAND_LETTER) = minLat_deg(bandLetter == mgrs.MGRSConstants.MAX_BAND_LETTER) + mgrs.MGRSConstants.MAX_BAND_HEIGHT;

end
