function zoneNumber = getZoneNumber(latitude, longitude)
    %GETZONENUMBER Get UTM zone number from coordinates
    %   ZONE = GETZONENUMBER(LAT, LON) returns the UTM zone number
    %   for the given latitude and longitude coordinates. Handles
    %   special cases for Svalbard (zones 31-37) and Norway (zones 31-32).
    %
    %   Input:
    %       LAT - Latitude in degrees (-80 to 84)
    %       LON - Longitude in degrees (-180 to 180)
    %
    %   Output:
    %       ZONE - UTM zone number (1-60)
    %
    %   Example:
    %       zone = mgrs.gridZone.getZoneNumber(0, 0);  % 31
    %       zone = mgrs.gridZone.getZoneNumber(78, 15); % Svalbard: 33
    %
    %   See also: mgrs.gridZone.getZoneLimits, mgrs.gridZone.getBandLetter
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