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

        function [latitude_deg, longitude_deg] = toLatLon(obj)

            if coder.target("MATLAB")
                % Allocate latitude and longitude.
                latitude_deg = zeros(size(obj));
                longitude_deg = zeros(size(obj));

                for ii = 1:numel(size(obj))
                    [latitude_deg(ii), longitude_deg(ii)] = mgrs.internal.utmToLatLon( ...
                        obj(ii).zone, obj(ii).hemisphere, obj(ii).easting, obj(ii).northing );
                end
            else
                [latitude_deg, longitude_deg] = mgrs.internal.utmToLatLon( ...
                    obj.zone, obj.hemisphere, obj.easting, obj.northing );
            end

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
                    % This fixes a code generation check in R2024b.
                    obj = createArray(size(latitude_deg),'mgrs.UTM');
                else
                    % This is needed for older MATLAB, because createArray
                    % was added in R2024b.
                    latSize = size(latitude_deg);
                    obj(latSize(1),latSize(2)) = mgrs.UTM();
                end

                for ii = 1:numel(obj)
                    utmParameters = mgrs.internal.latLonToUtm(latitude_deg(ii), longitude_deg(ii));
                    obj(ii) = mgrs.UTM(utmParameters{:});
                end
            else
                assert( isscalar(latitude_deg) && isscalar(longitude_deg))

                utmParameters = mgrs.internal.latLonToUtm(latitude_deg, longitude_deg);
                obj = mgrs.UTM(utmParameters{:});
            end
        end

        function obj = fromUtmString(utmString)

            arguments
                utmString string {mustBeUtmString}
            end

            if coder.target("MATLAB")

            else

            end

        end

    end

end

function mustBeUtmString(utmString)
    bool = ~mgrs.isUtmString(utmString);
    if any(~bool)
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