function [zone, hemisphere, easting, northing] = mgrsToUtm(zone, band, column, row, easting, northing)
    % mgrs.internal.mgrsToUtm convers MGRS coordinate parameters to UTM coordinate parameters

    if band > mgrs.MGRSConstants.BAND_LETTER_SOUTH
        hemisphere = mgrs.Hemisphere.North;
    else
        hemisphere = mgrs.Hemisphere.South;
    end

    % Combine MGRS column and easting into UTM easting.
    zoneSetCol = mod(zone-1,3) + 1;
    easting100k = strfind(mgrs.MGRSConstants.COLUMN_LETTERS{zoneSetCol}, column);
    easting = easting100k * 100000 + easting;

    % Combine MGRS row and northing into UTM northing.
    % Calc all possible UTM northings for the given MGRS row and northing.
    zoneSetRow = mod(zone-1,2) + 1;
    allNorthing2000k = 0:20:80;
    allNorthing100k = allNorthing2000k + strfind(mgrs.MGRSConstants.ROW_LETTERS{zoneSetRow}, row) - 1;
    allNorthing = allNorthing100k * 100000 + northing;
    % Find valid UTM northing using the band latitude limits.
    [minLatitude_deg, maxLatitude_deg] = mgrs.gridZone.getBandLimits(band);
    for ii = 1:numel(allNorthing)
        latitude_deg = mgrs.internal.utmToLatLon(zone, hemisphere, easting, allNorthing(ii));
        if latitude_deg >= minLatitude_deg && latitude_deg <= maxLatitude_deg
            northing = allNorthing(ii);
            break
        end

        if ii == numel(allNorthing)
            error( 'MGRS:InvalidMgrsCoordinate', ...
                'Could not resolve the correct UTM northing from the given MGRS coordinate.' )
        end
    end

end