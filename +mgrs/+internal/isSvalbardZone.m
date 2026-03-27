function bool = isSvalbardZone(zoneNumber)
    bool = zoneNumber >= mgrs.MGRSConstants.MIN_SVALBARD_ZONE_NUMBER ...
        & zoneNumber <= mgrs.MGRSConstants.MAX_SVALBARD_ZONE_NUMBER;
end