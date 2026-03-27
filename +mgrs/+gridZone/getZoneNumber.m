function zoneNumber = getZoneNumber(latitude, longitude)
    zoneNumber = mgrs.internal.getUniformZone(longitude);
    bandLetter = mgrs.gridZone.getBandLetter(latitude);

    isSvalbardZone = mgrs.internal.isSvalbardZone(zoneNumber);
    isSvalbardBand = mgrs.internal.isSvalbardLetter(bandLetter);
    isSvalbard = isSvalbardZone & isSvalbardBand;

    isNorwayZone = mgrs.internal.isNorwayZone(zoneNumber);
    isNorwayBand = mgrs.internal.isNorwayLetter(bandLetter);
    isNorway = isNorwayZone & isNorwayBand;

    if any(isSvalbard)
        zoneNumber(isSvalbard) = mgrs.internal.getSvalbardZone(longitude(isSvalbard));
    end

    if any(isNorway)
        zoneNumber(isNorway) = mgrs.internal.getNorwayZone(longitude(isNorway));
    end
end