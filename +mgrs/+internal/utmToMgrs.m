function [zone, band, column, row, easting, northing] = utmToMgrs(zone, hemisphere, easting, northing)
    % mgrs.internal.utmToMgrs converts UTM coordinate parameters to MGRS coordinate parameters

    latitude_deg = mgrs.internal.utmToLatLon(zone, hemisphere, easting, northing);
    % Band
    band = mgrs.gridZone.getBandLetter(latitude_deg);

    % Easting and column
    easting100k = mod(floor(easting/100000), 8);
    zoneSetCol = mod(zone-1,3) + 1;
    column = mgrs.MGRSConstants.COLUMN_LETTERS{zoneSetCol}(easting100k);
    easting = mod(easting, 100000);

    % Northing and row
    northing100k = mod(floor(northing/100000), 20);
    zoneSetRow = mod(zone-1,2) + 1;
    row = mgrs.MGRSConstants.ROW_LETTERS{zoneSetRow}(northing100k+1);
    northing = mod(northing, 100000);
    
end