classdef MGRS < mgrs.UTM
    %mgrs.MGRS Military Grid Reference System

    properties ( Dependent, SetAccess = private )
        band char
    end

    properties ( Dependent )
        column char
        row char
    end

    methods

        function utmObj = mgrs.UTM(obj)
            if coder.target("MATLAB")
                objSize = size(obj);
                utmObj(objSize(1),objSize(2)) = mgrs.UTM();

                for ii = 1:numel(obj)
                    utmObj(ii) = mgrs.UTM(obj(ii).zone, obj(ii).hemisphere, obj(ii).easting, obj(ii).northing);
                end
            else
                utmObj = mgrs.UTM(obj.zone, obj.hemisphere, obj.easting, obj.northing);
            end
        end

        function mgrsString = string(obj)
            if coder.target("MATLAB")
                mgrsString = strings(size(obj));
                for ii = 1:numel(obj)
                    truncEasting = mod(obj(ii).easting, 100000);
                    truncNorthing = mod(obj(ii).northing, 100000);
                    mgrsString(ii) = sprintf("%02d", obj(ii).zone) ...
                        + obj(ii).band ...
                        + " " ...
                        + obj(ii).column + obj(ii).row ...
                        + " " ...
                        + sprintf("%05.0f", truncEasting) ...
                        + " " ...
                        + sprintf("%05.0f", truncNorthing);
                end
            else
                truncEasting = mod(obj.easting, 100000);
                truncNorthing = mod(obj.northing, 100000);
                mgrsString = sprintf("%02d", obj.zone) ...
                    + obj.band ...
                    + " " ...
                    + obj.column + obj.row ...
                    + " " ...
                    + sprintf("%05.0f", truncEasting) ...
                    + " " ...
                    + sprintf("%05.0f", truncNorthing);
            end
        end

        function value = get.band(obj)
            latitude_deg = obj.toLatLon();
            if latitude_deg > mgrs.MGRSConstants.MAX_LAT
                value = mgrs.MGRSConstants.MAX_BAND_LETTER;
            elseif latitude_deg < mgrs.MGRSConstants.MIN_LAT
                value = mgrs.MGRSConstants.MIN_BAND_LETTER;
            else
                value = mgrs.gridZone.getBandLetter(latitude_deg);
            end
        end

        function value = get.column(obj)
            easting100k = mod(floor(obj.easting/100000), 8);
            zoneSet = mod(obj.zone-1,3) + 1;
            value = mgrs.MGRSConstants.COLUMN_LETTERS{zoneSet}(easting100k);
        end

        function value = get.row(obj)
            northing100k = mod(floor(obj.northing/100000), 20);
            zoneSet = mod(obj.zone-1,2) + 1;
            value = mgrs.MGRSConstants.ROW_LETTERS{zoneSet}(northing100k+1);
        end

    end

    methods ( Static )

        function obj = fromLatLon(latitude_deg, longitude_deg)
            utmObj = fromLatLon@mgrs.UTM(latitude_deg, longitude_deg);
            obj = mgrs.MGRS(utmObj);
        end

    end

end