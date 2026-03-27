function zoneNumber = getNorwayZone(longitude_deg)

    arguments
        longitude_deg double {mustBeGreaterThanOrEqual(longitude_deg,-180), mustBeLessThanOrEqual(longitude_deg,180)}
    end

    % Get the minimum longitude of the Norway zone.
    minLongitude_deg = mgrs.gridZone.getZoneLimits(mgrs.MGRSConstants.MIN_NORWAY_ZONE_NUMBER);

    % Start with the minimum Norway zone number.
    zoneNumber = ones(size(longitude_deg)) * mgrs.MGRSConstants.MIN_NORWAY_ZONE_NUMBER;

    % If more than halfway through the minimum Norway zone jump to the
    % maximum Norway zone.
    zoneNumber(longitude_deg >= minLongitude_deg + mgrs.MGRSConstants.ZONE_WIDTH / 2) ...
        = zoneNumber(longitude_deg >= minLongitude_deg + mgrs.MGRSConstants.ZONE_WIDTH / 2) + 1;
    
end