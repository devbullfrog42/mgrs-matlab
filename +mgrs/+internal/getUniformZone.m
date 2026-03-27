function zone = getUniformZone(longitude)

    arguments
        longitude double {mustBeGreaterThanOrEqual(longitude,-180), mustBeLessThanOrEqual(longitude,180)}
    end

    % import mgrs.MGRSConstants;

    zoneValue = (longitude - mgrs.MGRSConstants.MIN_LON) / mgrs.MGRSConstants.ZONE_WIDTH;
    zone = uint8(floor(zoneValue)) + 1;
    zone(zone == 61) = 60; % If the longitude is exactly 180, return 60, not 61.
end

