classdef UTM
    %UTM Universal Tranverse Mercator Coordinate System
    %   Detailed explanation goes here

    properties
        zone (1,1) uint8 {mustBeGreaterThanOrEqual(zone,0), mustBeLessThanOrEqual(zone,60)} = 30
        hemisphere (1,1) mgrs.Hemisphere = "North"
        easting (1,1) double {mustBeGreaterThanOrEqual(easting,0)} = 833978.577
        northing (1,1) double {mustBeGreaterThanOrEqual(northing,0)} = 0.000
    end

    methods

        function obj = UTM(zone, hemisphere, easting, northing)

            arguments
                zone (1,1) uint8 {mustBeGreaterThan(zone,0), mustBeLessThanOrEqual(zone,60)} = 30
                hemisphere (1,1) mgrs.Hemisphere = "North"
                easting (1,1) double {mustBeGreaterThanOrEqual(easting,0)} = 833978.577
                northing (1,1) double {mustBeGreaterThanOrEqual(northing,0)} = 0.000
            end

            obj.zone = zone;
            obj.hemisphere = hemisphere;
            obj.easting = easting;
            obj.northing = northing;
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

        function [latitudeBounds_deg, longitudeBounds_deg] = getLatLonBounds(obj)

            % Convert to latitude and longitude.
            [latSW, lonSW] = obj.toLatLon("southwest");
            [latNE, lonNE] = obj.toLatLon("northeast");

            % Output the latitude and longitude bounds.
            latitudeBounds_deg = [latSW(:) latNE(:)];
            longitudeBounds_deg = [lonSW(:) lonNE(:)];
            
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
                latitudeLongitudePair_deg (2,:) double
            end

            latitude_deg = latitudeLongitudePair_deg(:,1);
            longitude_deg = latitudeLongitudePair_deg(:,2);

            obj = mgrs.UTM.fromLatLon(latitude_deg, longitude_deg);

        end

        function obj = fromUtmString(utmString)

            arguments
                utmString string {mustBeUtmString}
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

function mustBeUtmString(utmString)
    bool = ~mgrs.isUtmString(utmString);
    if any(bool)
        [badr, badc] = ind2sub(size(bool), find(bool));
        badList = string();
        for ii = 1:numel(badr)
            badList = badList + sprintf("    %s at subscript (%d,%d)", utmString(badr(ii),badc(ii)), badr(ii), badc(ii)) + newline;
        end
        error( 'MGRS:invalidUtmStrings', ...
            'The following UTM strings are invalid...\n%s', ...
            badList )
    end
end