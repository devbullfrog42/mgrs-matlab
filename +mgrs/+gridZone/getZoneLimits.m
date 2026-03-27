function [minLon_deg, maxLon_deg] = getZoneLimits(zoneNumber)

    arguments
        zoneNumber uint8 {mustBeLessThanOrEqual(zoneNumber,60)}
    end

    % Calculate the minimum longitude.
    minLon_deg = mgrs.MGRSConstants.MIN_LON + (double(zoneNumber) - 1) * mgrs.MGRSConstants.ZONE_WIDTH;

    % Calculate the maximum longitude.
    maxLon_deg = mgrs.MGRSConstants.MIN_LON + double(zoneNumber) * mgrs.MGRSConstants.ZONE_WIDTH;
    
end