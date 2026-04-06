classdef MGRS < mgrs.UTM
    %MGRS Military Grid Reference System coordinate class
    %   The MGRS class represents coordinates in the Military Grid Reference
    %   System, which extends the Universal Transverse Mercator (UTM) system
    %   with an additional grid overlay for more precise location specification.
    %
    %   MGRS coordinates consist of:
    %   - UTM zone number (1-60)
    %   - Latitude band letter (C-X, excluding I and O)
    %   - 100km grid square identifier (column and row letters)
    %   - Easting and northing within the 100km square (0-99,999 meters)
    %
    %   MGRS provides 1-meter precision within 100km x 100km grid squares.
    %
    %   Properties:
    %       zone      - UTM zone number (1-60)
    %       band      - Latitude band letter (C-X)
    %       column    - 100km square column letter
    %       row       - 100km square row letter
    %       easting   - Easting within 100km square (0-99,999 meters)
    %       northing  - Northing within 100km square (0-99,999 meters)
    %       hemisphere - North or South (derived from band)
    %
    %   Methods:
    %       MGRS      - Constructor
    %       mgrs.UTM  - Convert to UTM coordinates
    %       toLatLon  - Convert to latitude/longitude
    %       string    - Format as MGRS string
    %       eq        - Test equality with another MGRS object
    %
    %   Static Methods:
    %       fromLatLon     - Create from latitude/longitude
    %       fromLatLonPair - Create from [lat, lon] pairs
    %       fromString     - Parse MGRS string
    %
    %   Example:
    %       % Create MGRS coordinate for Null Island (0°N, 0°E)
    %       mgrsCoord = mgrs.MGRS.fromLatLon(0, 0);
    %       disp(string(mgrsCoord));  % "31N AA 66021 00000"
    %
    %       % Parse MGRS string
    %       mgrsCoord = mgrs.MGRS.fromString("31N AA 66021 00000");
    %       [lat, lon] = mgrsCoord.toLatLon();
    %
    %   See also: mgrs.UTM, mgrs.isMgrsString

    properties
        band (1,1) char = 'N'
        column (1,1) char = 'A'
        row (1,1) char = 'A'
    end

    methods

        function obj = MGRS(zone, band, column, row, easting, northing)

            arguments
                zone (1,1) uint8 {mustBeLessThanOrEqual(zone,60)} = 31
                band (1,1) char = 'N'
                column (1,1) char = 'A'
                row (1,1) char = 'A'
                easting (1,1) double {mustBeGreaterThanOrEqual(easting,0)} = 66021
                northing (1,1) double {mustBeGreaterThanOrEqual(northing,0)} = 0
            end

            obj.zone = zone;
            obj.band = band;
            obj.column = column;
            obj.row = row;
            obj.easting = easting;
            obj.northing = northing;

            if obj.band > mgrs.MGRSConstants.BAND_LETTER_SOUTH
                obj.hemisphere = "North";
            else
                obj.hemisphere = "South";
            end
        end

        function utmObj = mgrs.UTM(obj)
            if coder.target("MATLAB")
                if verLessThan('matlab', '24.2') %#ok<VERLESSMATLAB>
                    objSize = size(obj);
                    utmObj(objSize(1),objSize(2)) = mgrs.UTM();
                else
                    utmObj = createArray(size(obj), 'mgrs.UTM');
                end

                for ii = 1:numel(obj)
                    [zone, hemisphere, easting, northing] = mgrs.internal.mgrsToUtm(obj(ii).zone, obj(ii).band, obj(ii).column, obj(ii).row, obj(ii).easting, obj(ii).northing);
                    utmObj(ii) = mgrs.UTM(zone, hemisphere, easting, northing);
                end
            else
                [zone, hemisphere, easting, northing] = mgrs.internal.mgrsToUtm(obj.zone, obj.band, obj.column, obj.row, obj.easting, obj.northing);
                utmObj = mgrs.UTM(zone, hemisphere, easting, northing);
            end
        end

        function bool = eq(objA, objB)

            arguments
                objA 
                objB {mustBeMgrsScalarOrSameSize(objA,objB)}
            end

            bool = true(max(size(objA), size(objB)));
            bool(:) = bool(:) & [objA.zone]' == [objB.zone]';
            bool(:) = bool(:) & [objA.band]' == [objB.band]';
            bool(:) = bool(:) & [objA.column]' == [objB.column]';
            bool(:) = bool(:) & [objA.row]' == [objB.row]';
            bool(:) = bool(:) & floor([objA.easting]') == floor([objB.easting]');
            bool(:) = bool(:) & floor([objA.northing]') == floor([objB.northing]');

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

        function [latitude_deg, longitude_deg] = toLatLon(obj, gridPoint)

            arguments
                obj 
                gridPoint (1,1) mgrs.GridPoint = "center"
            end

            utmObj = mgrs.UTM(obj);
            [latitude_deg, longitude_deg] = utmObj.toLatLon(gridPoint);

        end

    end

    methods ( Static )

        function obj = fromLatLon(latitude_deg, longitude_deg)

            arguments
                latitude_deg double {mustBeVector}
                longitude_deg  double {mustBeVector}
            end

            utmObj = fromLatLon@mgrs.UTM(latitude_deg, longitude_deg);
            obj = mgrs.MGRS(utmObj);
            
        end

        function obj = fromLatLonPair(latitudeLongitudePair_deg)

            arguments
                latitudeLongitudePair_deg (:,2) double
            end

            utmObj = fromLatLonPair@mgrs.UTM(latitudeLongitudePair_deg);
            obj = mgrs.MGRS(utmObj);

        end

        function obj = fromString(mgrsString)

            arguments
                mgrsString string {mgrs.internal.mustBeMgrsString}
            end

            if coder.target("MATLAB")
                if verLessThan('matlab', '24.2') %#ok<VERLESSMATLAB>
                    mgrsSize = size(mgrsString);
                    obj(mgrsSize(1),mgrsSize(2)) = mgrs.MGRS();
                else
                    obj = createArray(size(mgrsString), 'mgrs.MGRS');
                end

                for ii = 1:numel(mgrsString)
                    [zone, band, column, row, easting, northing] = mgrs.internal.extractMgrsFromString(mgrsString(ii));
                    obj(ii) = mgrs.MGRS(zone, band, column, row, easting, northing);
                end
            else
                [zone, band, column, row, easting, northing] = mgrs.internal.extractMgrsFromString(mgrsString);
                obj = mgrs.MGRS(zone, band, column, row, easting, northing);
            end

        end

    end

end

function mustBeMgrsScalarOrSameSize(utmA, utmB)
    if ~isa(utmA,"mgrs.MGRS") || ~isa(utmB,"mgrs.MGRS")
        error( 'MGRS:notMgrsClass', ...
            'Both parameters must be objects of the mgrs.MGRS class' )
    end

    if ~isscalar(utmA) && ~isscalar(utmB) && any(size(utmA) ~= size(utmB))
        error( 'MGRS:sizeDimensionsMustMatch', ...
            'Arrays have incompatible sizes for this operation.' )
    end
end
