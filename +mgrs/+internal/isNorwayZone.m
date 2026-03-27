function bool = isNorwayZone(zoneNumber)
    bool = zoneNumber >= mgrs.MGRSConstants.MIN_NORWAY_ZONE_NUMBER ...
        & zoneNumber <= mgrs.MGRSConstants.MAX_NORWAY_ZONE_NUMBER;
end