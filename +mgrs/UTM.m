classdef UTM < matlab.mixin.CustomDisplay
    %UTM Universal Transverse Mercator coordinate class
    %   The UTM class represents coordinates in the Universal Transverse
    %   Mercator coordinate system, a 2D Cartesian coordinate system that
    %   divides the Earth into 60 zones, each 6° wide in longitude.
    %
    %   UTM coordinates consist of:
    %   - Zone number (1-60, covering 180°W to 180°E)
    %   - Hemisphere (North or South)
    %   - Easting (meters from central meridian, with 500km false easting)
    %   - Northing (meters from equator, with 10Mm false northing for South)
    %
    %   UTM provides meter-level precision for mapping applications.
    %
    %   Properties:
    %       zone       - UTM zone number (1-60)
    %       hemisphere - North or South hemisphere
    %       easting    - East-west coordinate in meters
    %       northing   - North-south coordinate in meters
    %
    %   Methods:
    %       UTM         - Constructor
    %       mgrs.MGRS   - Convert to MGRS coordinates
    %       toLatLon    - Convert to latitude/longitude
    %       toLatLonPair - Convert to [lat, lon] pairs
    %       string      - Format as UTM string
    %       eq          - Test equality with another UTM object
    %
    %   Static Methods:
    %       fromLatLon     - Create from latitude/longitude
    %       fromLatLonPair - Create from [lat, lon] pairs
    %       fromString     - Parse UTM string
    %
    %   Example:
    %       % Create UTM coordinate for Null Island (0°N, 0°E)
    %       utmCoord = mgrs.UTM.fromLatLon(0, 0);
    %       disp(string(utmCoord));  % "31N 166021 0000000"
    %
    %       % Parse UTM string
    %       utmCoord = mgrs.UTM.fromString("31N 166021 0000000");
    %       [lat, lon] = utmCoord.toLatLon();
    %
    %   See also: mgrs.MGRS, mgrs.isUtmString

    properties
        zone (1,1) uint8 {mustBeLessThanOrEqual(zone,60)} = 31
        hemisphere (1,1) mgrs.Hemisphere = "North"
        easting (1,1) double {mustBeGreaterThanOrEqual(easting,0)} = 166021
        northing (1,1) double {mustBeGreaterThanOrEqual(northing,0)} = 0
    end

    methods

        function obj = UTM(zone, hemisphere, easting, northing)

            arguments
                zone (1,1) uint8 {mustBeLessThanOrEqual(zone,60)} = 31
                hemisphere (1,1) mgrs.Hemisphere = "North"
                easting (1,1) double {mustBeGreaterThanOrEqual(easting,0)} = 166021
                northing (1,1) double {mustBeGreaterThanOrEqual(northing,0)} = 0
            end

            obj.zone = zone;
            obj.hemisphere = hemisphere;
            obj.easting = easting;
            obj.northing = northing;

            % If UTM coordinate is outside valid latitudes, set object to
            % general polar region value.
            if (obj.hemisphere == mgrs.Hemisphere.North && northing > 9328000) ...
                    || (obj.hemisphere == mgrs.Hemisphere.South && northing < 1119000)
                if obj.hemisphere == mgrs.Hemisphere.North
                    latitude_deg = obj.toLatLon("southwest");
                else
                    latitude_deg = obj.toLatLon("northwest");
                end

                if latitude_deg > mgrs.MGRSConstants.MAX_LAT
                    % North polar region
                    obj.zone = 0;
                    obj.hemisphere = "North";
                    obj.easting = 0;
                    obj.northing = 0;
                elseif latitude_deg < mgrs.MGRSConstants.MIN_LAT
                    % South polar region
                    obj.zone = 0;
                    obj.hemisphere = "South";
                    obj.easting = 0;
                    obj.northing = 0;
                end
            end
        end

        function mgrsObj = mgrs.MGRS(obj)
            if coder.target("MATLAB")
                if verLessThan('matlab', '24.2') %#ok<VERLESSMATLAB>
                    objSize = size(obj);
                    mgrsObj(objSize(1),objSize(2)) = mgrs.MGRS();
                else
                    mgrsObj = createArray(size(obj), 'mgrs.MGRS');
                end

                for ii = 1:numel(obj)
                    [zone, band, column, row, easting, northing] = mgrs.internal.utmToMgrs( ...
                        obj(ii).zone, obj(ii).hemisphere, obj(ii).easting, obj(ii).northing ); %#ok<PROP>
                    mgrsObj(ii) = mgrs.MGRS(zone, band, column, row, easting, northing); %#ok<PROP>
                end
            else
                [zone, band, column, row, easting, northing] = mgrs.internal.utmToMgrs( ...
                    obj.zone, obj.hemisphere, obj.easting, obj.northing ); %#ok<PROP>
                mgrsObj = mgrs.MGRS(zone, band, column, row, easting, northing); %#ok<PROP>
            end
        end

        function bool = eq(objA, objB)

            arguments
                objA 
                objB {mustBeUtmScalarOrSameSize(objA,objB)}
            end

            bool = true(max(size(objA), size(objB)));
            bool(:) = bool(:) & [objA.zone]' == [objB.zone]';
            bool(:) = bool(:) & [objA.hemisphere]' == [objB.hemisphere]';
            bool(:) = bool(:) & floor([objA.easting]') == floor([objB.easting]');
            bool(:) = bool(:) & floor([objA.northing]') == floor([objB.northing]');

        end

        function utmString = string(obj)
            if coder.target("MATLAB")
                utmString = strings(size(obj));
                for ii = 1:numel(obj)
                    utmString(ii) = sprintf("%02d", obj(ii).zone) ...
                        + getInitial(obj(ii).hemisphere) ...
                        + " " ...
                        + sprintf("%06.0f", obj(ii).easting) ...
                        + " " ...
                        + sprintf("%07.0f", obj(ii).northing);
                end
            else
                utmString = sprintf("%02d", obj.zone) ...
                    + getInitial(obj.hemisphere) ...
                    + " " ...
                    + sprintf("%06.0f", obj.easting) ...
                    + " " ...
                    + sprintf("%07.0f", obj.northing);
            end
        end

        function utmChar = cellstr(obj)
            utmChar = cellstr(string(obj));
        end

        function utmChar = char(obj)
            utmChar = char(string(obj));
        end

        function [latitude_deg, longitude_deg] = toLatLon(obj, gridPoint)

            arguments
                obj 
                gridPoint (1,1) mgrs.GridPoint = "center"
            end

            % Defined the easting & northing shift for the returned
            % latitude and longitude.
            if gridPoint == mgrs.GridPoint.southwest
                eastingShift = 0.0;
                northingShift = 0.0;
            elseif gridPoint == mgrs.GridPoint.northwest
                eastingShift = 0.0;
                northingShift = 1.0;
            elseif gridPoint == mgrs.GridPoint.northeast
                eastingShift = 1.0;
                northingShift = 1.0;
            elseif gridPoint == mgrs.GridPoint.southeast
                eastingShift = 1.0;
                northingShift = 0.0;
            else % center
                eastingShift = 0.5;
                northingShift = 0.5;
            end

            if coder.target("MATLAB")
                % Allocate latitude and longitude.
                latitude_deg = zeros(size(obj));
                longitude_deg = zeros(size(obj));

                for ii = 1:numel(obj)
                    [latitude_deg(ii), longitude_deg(ii)] = mgrs.internal.utmToLatLon( ...
                        obj(ii).zone, obj(ii).hemisphere, obj(ii).easting + eastingShift, obj(ii).northing + northingShift );
                end
            else
                [latitude_deg, longitude_deg] = mgrs.internal.utmToLatLon( ...
                    obj.zone, obj.hemisphere, obj.easting, obj.northing );
            end

        end

        function latitudeLongitudePair_deg = toLatLonPair(obj, gridPoint)

            arguments
                obj 
                gridPoint (1,1) mgrs.GridPoint = "center"
            end

            [latitude_deg, longitude_deg] = obj.toLatLon(gridPoint);
            latitudeLongitudePair_deg = [latitude_deg(:) longitude_deg(:)];

        end

    end

    methods ( Access = protected )

        function displayScalarObject(obj)
            classLink = matlab.mixin.CustomDisplay.getClassNameForHeader(obj);
            header = "  " + classLink + " coordinate" + newline;
            disp(header)

            disp("    " + string(obj) + newline)

            footer = obj.getFooter();
            disp(footer)
        end

        function displayNonScalarObject(obj)
            dimStr = matlab.mixin.CustomDisplay.convertDimensionsToString(obj);
            classLink = matlab.mixin.CustomDisplay.getClassNameForHeader(obj);
            header = "  " + dimStr + " " + classLink + " array" + newline;
            disp(header)

            disp(string(obj))

            footer = obj.getFooter();
            disp(footer)
        end

    end

    methods ( Static )

        function obj = fromLatLon(latitude_deg, longitude_deg)

            arguments
                latitude_deg double {mustBeVector}
                longitude_deg double {mustBeVector}
            end

            if coder.target("MATLAB")
                % Assert that latitude_deg and longitude_deg must be the same length.
                assert( numel(latitude_deg) == numel(longitude_deg), ...
                    'MGRS:inputsDifferentSizes', ...
                    'The inputs latitude_deg and longitude_deg must be vectors of the same length.' )

                % Allocate UTM object array
                if verLessThan('matlab','24.2') %#ok<VERLESSMATLAB>
                    % This is needed for older MATLAB, because createArray
                    % was added in R2024b.
                    latSize = size(latitude_deg);
                    obj(latSize(1),latSize(2)) = mgrs.UTM();
                else
                    % This fixes a code generation check in R2024b.
                    obj = createArray(size(latitude_deg),'mgrs.UTM');
                end

                for ii = 1:numel(obj)
                    [zone, hemisphere, easting, northing] = mgrs.internal.latLonToUtm(latitude_deg(ii), longitude_deg(ii));
                    obj(ii) = mgrs.UTM(zone, hemisphere, easting, northing);
                end
            else
                assert( isscalar(latitude_deg) && isscalar(longitude_deg))

                [zone, hemisphere, easting, northing] = mgrs.internal.latLonToUtm(latitude_deg, longitude_deg);
                obj = mgrs.UTM(zone, hemisphere, easting, northing);
            end

        end

        function obj = fromLatLonPair(latitudeLongitudePair_deg)

            arguments
                latitudeLongitudePair_deg (:,2) double
            end

            latitude_deg = latitudeLongitudePair_deg(:,1);
            longitude_deg = latitudeLongitudePair_deg(:,2);

            obj = mgrs.UTM.fromLatLon(latitude_deg, longitude_deg);

        end

        function obj = fromString(utmString)

            arguments
                utmString string {mgrs.internal.mustBeUtmString}
            end

            if coder.target("MATLAB")
                if verLessThan('matlab', '24.2') %#ok<VERLESSMATLAB>
                    utmSize = size(utmString);
                    obj(utmSize(1),utmSize(2)) = mgrs.UTM();
                else
                    obj = createArray(size(utmString), 'mgrs.UTM');
                end

                for ii = 1:numel(utmString)
                    [zone, hemisphere, easting, northing] = mgrs.internal.extractUtmFromString(utmString(ii));
                    obj(ii) = mgrs.UTM(zone, hemisphere, easting, northing);
                end
            else
                [zone, hemisphere, easting, northing] = mgrs.internal.extractUtmFromString(utmString);
                obj = mgrs.UTM(zone, hemisphere, easting, northing);
            end

        end

    end

end

function mustBeUtmScalarOrSameSize(utmA, utmB)
    if ~isa(utmA,"mgrs.UTM") || ~isa(utmB,"mgrs.UTM")
        error( 'MGRS:notUtmClass', ...
            'Both parameters must be objects of the mgrs.UTM class' )
    end

    if ~isscalar(utmA) && ~isscalar(utmB) && any(size(utmA) ~= size(utmB))
        error( 'MGRS:sizeDimensionsMustMatch', ...
            'Arrays have incompatible sizes for this operation.' )
    end
end
