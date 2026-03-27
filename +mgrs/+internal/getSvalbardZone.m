function zoneNumber = getSvalbardZone(longitude_deg)

    arguments
        longitude_deg double {mustBeGreaterThanOrEqual(longitude_deg,-180), mustBeLessThanOrEqual(longitude_deg,180)}
    end

    % Get the minimum longitude of the Svalbard zone.
    minLongitude_deg = mgrs.gridZone.getZoneLimits(mgrs.MGRSConstants.MIN_SVALBARD_ZONE_NUMBER);

    % Get the zone number by rounding to the nearest whole zone value.
    zoneValue = mgrs.MGRSConstants.MIN_SVALBARD_ZONE_NUMBER + (longitude_deg - minLongitude_deg) / mgrs.MGRSConstants.ZONE_WIDTH;
    zoneNumber = uint8(round(zoneValue));

    % Only the odd longitude zones are used around Svalbard.
    zoneNumber(mod(zoneNumber,2) == 0) = zoneNumber(mod(zoneNumber,2) == 0) - 1;

end