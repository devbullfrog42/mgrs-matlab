function [minLon_deg, maxLon_deg] = getZoneLimits(zoneNumber)
    %GETZONELIMITS Get longitude limits for a zone number
    %   [MINLON, MAXLON] = GETZONELIMITS(ZONE) returns the longitude
    %   bounds in degrees for the given UTM zone number.
    %
    %   Input:
    %       ZONE - UTM zone number (1-60)
    %
    %   Output:
    %       MINLON - Minimum longitude for the zone (degrees)
    %       MAXLON - Maximum longitude for the zone (degrees)
    %
    %   Example:
    %       [minLon, maxLon] = mgrs.gridZone.getZoneLimits(31);
    %       % minLon = 0, maxLon = 6
    %
    %   See also: mgrs.gridZone.getZoneNumber, mgrs.gridZone.getBandLimits

    arguments
        zoneNumber uint8 {mustBeLessThanOrEqual(zoneNumber,60)}
    end

    % Calculate the minimum longitude.
    minLon_deg = mgrs.MGRSConstants.MIN_LON + (double(zoneNumber) - 1) * mgrs.MGRSConstants.ZONE_WIDTH;

    % Calculate the maximum longitude.
    maxLon_deg = mgrs.MGRSConstants.MIN_LON + double(zoneNumber) * mgrs.MGRSConstants.ZONE_WIDTH;
    
end