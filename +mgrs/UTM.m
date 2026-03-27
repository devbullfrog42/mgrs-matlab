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
            utmString = compose("%02d", obj.zone) ...
                + getInitial(obj.hemisphere) ...
                + " " ...
                + compose("%06.0f", obj.easting) ...
                + " " ...
                + compose("%07.0f", obj.northing);
        end

        function utmChar = char(obj)
            utmChar = char(string(obj));
        end

        function [latitude_deg, longitude_deg] = toLatLon(obj)
            north = obj.northing;
            if obj.hemisphere == mgrs.Hemisphere.South
                north = north - 10000000;
            end
            east = obj.easting;

            latitude_deg = (north / 6366197.724 / 0.9996 + (1 + 0.006739496742 * (cos( north / 6366197.724 / 0.9996 ))^2 - 0.006739496742 * sin( north / 6366197.724 / 0.9996 ) * cos( north / 6366197.724 / 0.9996 ) * (atan( cos( atan( (exp( (east - 500000) / (0.9996 * 6399593.625 / sqrt( (1 + 0.006739496742 * (cos( north / 6366197.724 / 0.9996 ))^2) )) * (1 - 0.006739496742 * ((east - 500000) / (0.9996 * 6399593.625 / sqrt( (1 + 0.006739496742 * (cos( north / 6366197.724 / 0.9996 ))^2) )))^2 / 2 * (cos( north / 6366197.724 / 0.9996 ))^2 / 3) ) - exp( -(east - 500000) / (0.9996 * 6399593.625 / sqrt( (1 + 0.006739496742 * (cos( north / 6366197.724 / 0.9996 ))^2) )) * (1 - 0.006739496742 * ((east - 500000) / (0.9996 * 6399593.625 / sqrt( (1 + 0.006739496742 * (cos( north / 6366197.724 / 0.9996 ))^2) )))^2 / 2 * (cos( north / 6366197.724 / 0.9996 ))^2 / 3) )) / 2 / cos( (north - 0.9996 * 6399593.625 * (north / 6366197.724 / 0.9996 - 0.006739496742 * 3 / 4 * (north / 6366197.724 / 0.9996 + sin( 2 * north /6366197.724 / 0.9996 ) / 2) + (0.006739496742 * 3 / 4)^2 * 5 / 3 * (3 * (north / 6366197.724 / 0.9996 + sin( 2 * north / 6366197.724 / 0.9996 ) / 2) + sin( 2 * north / 6366197.724 / 0.9996 ) * (cos( north / 6366197.724 / 0.9996 ))^2) / 4 - (0.006739496742 * 3 / 4)^3 * 35 / 27 * (5 * (3 * (north / 6366197.724 / 0.9996 + sin( 2 * north / 6366197.724 / 0.9996 ) / 2) + sin( 2 * north / 6366197.724 / 0.9996 ) * (cos( north / 6366197.724 / 0.9996 ))^2) / 4 + sin( 2 * north / 6366197.724 / 0.9996 ) * (cos( north / 6366197.724 / 0.9996 ))^2 * (cos( north / 6366197.724 / 0.9996 ))^2) / 3)) / (0.9996 * 6399593.625 / sqrt( (1 + 0.006739496742 * (cos( north / 6366197.724 / 0.9996 ))^2) )) * (1 - 0.006739496742 * ((east - 500000) / (0.9996 * 6399593.625 / sqrt( (1 + 0.006739496742 * (cos( north / 6366197.724 / 0.9996 ))^2) )))^2 / 2 * (cos( north / 6366197.724 / 0.9996 ))^2) + north / 6366197.724 / 0.9996 ) ) ) * tan( (north - 0.9996 * 6399593.625 * (north / 6366197.724 / 0.9996 - 0.006739496742 * 3 / 4 * (north / 6366197.724 / 0.9996 + sin( 2 * north / 6366197.724 / 0.9996 ) / 2) + (0.006739496742 * 3 / 4)^2 * 5 / 3 * (3 * (north / 6366197.724 / 0.9996 + sin( 2 * north / 6366197.724 / 0.9996 ) / 2) + sin( 2 * north / 6366197.724 / 0.9996 ) * (cos( north / 6366197.724 / 0.9996 ))^2) / 4 - (0.006739496742 * 3 / 4)^3 * 35 / 27 * (5 * (3 * (north / 6366197.724 / 0.9996 + sin( 2 * north / 6366197.724 / 0.9996 ) / 2) + sin( 2 * north / 6366197.724 / 0.9996 ) * (cos( north / 6366197.724 / 0.9996 ))^2) / 4 + sin( 2 * north / 6366197.724 / 0.9996 ) * (cos( north / 6366197.724 / 0.9996 ))^2 * (cos( north / 6366197.724 / 0.9996 ))^2) / 3)) / (0.9996 * 6399593.625 / sqrt( (1 + 0.006739496742 * (cos( north / 6366197.724 / 0.9996 ))^2) )) * (1 - 0.006739496742 * ((east - 500000) / (0.9996 * 6399593.625 / sqrt( (1 + 0.006739496742 * (cos( north / 6366197.724 / 0.9996 ))^2) )))^2 / 2 * (cos( north / 6366197.724 / 0.9996 ))^2) + north / 6366197.724 / 0.9996 ) ) - north / 6366197.724 / 0.9996) * 3 / 2) * (atan( cos( atan( (exp( (east - 500000) / (0.9996 * 6399593.625 / sqrt( (1 + 0.006739496742 * (cos( north / 6366197.724 / 0.9996 ))^2) )) * (1 - 0.006739496742 * ((east - 500000) / (0.9996 * 6399593.625 / sqrt( (1 + 0.006739496742 * (cos( north / 6366197.724 / 0.9996 ))^2) )))^2 / 2 * (cos( north / 6366197.724 / 0.9996 ))^2 / 3) ) - exp( -(east - 500000) / (0.9996 * 6399593.625 / sqrt( (1 + 0.006739496742 * (cos( north / 6366197.724 / 0.9996 ))^2) )) * (1 - 0.006739496742 * ((east - 500000) / (0.9996 * 6399593.625 / sqrt( (1 + 0.006739496742 * (cos( north / 6366197.724 / 0.9996 ))^2) )))^2 / 2 * (cos( north / 6366197.724 / 0.9996 ))^2 / 3) )) / 2 / cos( (north - 0.9996 * 6399593.625 * (north / 6366197.724 / 0.9996 - 0.006739496742 * 3 / 4 * (north / 6366197.724 / 0.9996 + sin( 2 * north / 6366197.724 / 0.9996 ) / 2) + (0.006739496742 * 3 / 4)^2 * 5 / 3 * (3 * (north / 6366197.724 / 0.9996 + sin( 2 * north / 6366197.724 / 0.9996 ) / 2) + sin( 2 * north / 6366197.724 / 0.9996 ) * (cos( north / 6366197.724 / 0.9996 ))^2) / 4 - (0.006739496742 * 3 / 4)^3 * 35 / 27 * (5 * (3 * (north / 6366197.724 / 0.9996 + sin( 2 * north / 6366197.724 / 0.9996 ) / 2) + sin( 2 * north / 6366197.724 / 0.9996 ) * (cos( north / 6366197.724 / 0.9996 ))^2) / 4 + sin( 2 * north / 6366197.724 / 0.9996 ) * (cos( north / 6366197.724 / 0.9996 ))^2 * (cos( north / 6366197.724 / 0.9996 ))^2) / 3)) / (0.9996 * 6399593.625 / sqrt( (1 + 0.006739496742 * (cos( north / 6366197.724 / 0.9996 ))^2) )) * (1 - 0.006739496742 * ((east - 500000) / (0.9996 * 6399593.625 / sqrt( (1 + 0.006739496742 * (cos( north / 6366197.724 / 0.9996 ))^2) )))^2 / 2 * (cos( north / 6366197.724 / 0.9996 ))^2) + north / 6366197.724 / 0.9996 ) ) ) * tan( (north - 0.9996 * 6399593.625 * (north / 6366197.724 / 0.9996 - 0.006739496742 * 3 / 4 * (north / 6366197.724 / 0.9996 + sin( 2 * north / 6366197.724 / 0.9996 ) / 2) + (0.006739496742 * 3 / 4)^2 * 5 / 3 * (3 * (north / 6366197.724 / 0.9996 + sin( 2 * north / 6366197.724 / 0.9996 ) / 2) + sin( 2 * north / 6366197.724 / 0.9996 ) * (cos( north / 6366197.724 / 0.9996 ))^2) / 4 - (0.006739496742 * 3 / 4)^3 * 35 / 27 * (5 * (3 * (north / 6366197.724 / 0.9996 + sin( 2 * north / 6366197.724 / 0.9996 ) / 2) + sin( 2 * north / 6366197.724 / 0.9996 ) * (cos( north / 6366197.724 / 0.9996 ))^2) / 4 + sin( 2 * north / 6366197.724 / 0.9996 ) * (cos( north / 6366197.724 / 0.9996 ))^2 * (cos( north / 6366197.724 / 0.9996 ))^2) / 3)) / (0.9996 * 6399593.625 / sqrt( (1 + 0.006739496742 * (cos( north / 6366197.724 / 0.9996 ))^2) )) * (1 - 0.006739496742 * ((east - 500000) / (0.9996 * 6399593.625 / sqrt( (1 + 0.006739496742 * (cos( north / 6366197.724 / 0.9996 ))^2) )))^2 / 2 * (cos( north / 6366197.724 / 0.9996 ))^2) + north / 6366197.724 / 0.9996 ) ) - north / 6366197.724 / 0.9996)) * 180/pi();

            longitude_deg = atan( (exp( (east - 500000) / (0.9996 * 6399593.625 / sqrt( (1 + 0.006739496742 * (cos( north / 6366197.724 / 0.9996 ))^2) )) * (1 - 0.006739496742 * ((east - 500000) / (0.9996 * 6399593.625 / sqrt( (1 + 0.006739496742 * (cos( north / 6366197.724 / 0.9996 ))^2) )))^2 / 2 * (cos( north / 6366197.724 / 0.9996 ))^2 / 3) ) - exp( -(east - 500000) / (0.9996 * 6399593.625 / sqrt( (1 + 0.006739496742 * (cos( north / 6366197.724 / 0.9996 ))^2) )) * (1 - 0.006739496742 * ((east - 500000) / (0.9996 * 6399593.625 / sqrt( (1 + 0.006739496742 * (cos( north / 6366197.724 / 0.9996 ))^2) )))^2 / 2 * (cos( north / 6366197.724 / 0.9996 ))^2 / 3) )) / 2 / cos( (north - 0.9996 * 6399593.625 * (north / 6366197.724 / 0.9996 - 0.006739496742 * 3 / 4 * (north / 6366197.724 / 0.9996 + sin( 2 * north / 6366197.724 / 0.9996 ) / 2) + (0.006739496742 * 3 / 4)^2 * 5 / 3 * (3 * (north / 6366197.724 / 0.9996 + sin( 2 * north / 6366197.724 / 0.9996 ) / 2) + sin( 2 * north / 6366197.724 / 0.9996 ) * (cos( north / 6366197.724 / 0.9996 ))^2) / 4 - (0.006739496742 * 3 / 4)^3 * 35 / 27 * (5 * (3 * (north / 6366197.724 / 0.9996 + sin( 2 * north / 6366197.724 / 0.9996 ) / 2) + sin( 2 * north / 6366197.724 / 0.9996 ) * (cos( north / 6366197.724 / 0.9996 ))^2) / 4 + sin( 2 * north / 6366197.724 / 0.9996 ) * (cos( north / 6366197.724 / 0.9996 ))^2 * (cos( north / 6366197.724 / 0.9996 ))^2) / 3)) / (0.9996 * 6399593.625 / sqrt( (1 + 0.006739496742 * (cos( north / 6366197.724 / 0.9996 ))^2) )) * (1 - 0.006739496742 * ((east - 500000) / (0.9996 * 6399593.625 / sqrt( (1 + 0.006739496742 * (cos( north / 6366197.724 / 0.9996 ))^2) )))^2 / 2 * (cos( north / 6366197.724 / 0.9996 ))^2) + north / 6366197.724 / 0.9996 ) ) * 180/pi()+double(obj.zone)*6-183;
        end

    end

    methods ( Static )

        function obj = fromLatLon(latitude_deg, longitude_deg)
            zone = double(mgrs.gridZone.getZoneNumber(latitude_deg, longitude_deg));

            hemisphere = mgrs.Hemisphere.fromLatitude(latitude_deg);

            easting = 0.5 * log( (1 + cos(latitude_deg * pi/180) * sin( longitude_deg * pi/180 - (6 * zone - 183) * pi/180)) / (1 - cos( latitude_deg * pi/180 ) * sin( longitude_deg * pi/180 - (6 * zone - 183) * pi/180 )) ) * 0.9996 * 6399593.62 / sqrt( (1 + (0.0820944379)^2 * (cos( latitude_deg * pi/180 ))^2) ) * (1 + (0.0820944379)^2 / 2 * ((0.5 * log( (1 + cos( latitude_deg * pi/180 ) * sin( longitude_deg * pi/180 - (6 * zone - 183) * pi/180 )) / (1 - cos( latitude_deg * pi/180 ) * sin( longitude_deg * pi/180 - (6 * zone - 183) * pi/180 )) )))^2 * (cos( latitude_deg * pi/180 ))^2 / 3) + 500000;

            northing = (atan( tan( latitude_deg * pi/180 ) / cos( (longitude_deg * pi/180 - (6 * zone -183) * pi/180) ) ) - latitude_deg * pi/180) * 0.9996 * 6399593.625 / sqrt( 1 + 0.006739496742 * (cos( latitude_deg * pi/180 ))^2 ) * (1 + 0.006739496742 / 2 * (0.5 * log( (1 + cos( latitude_deg * pi/180) * sin( (longitude_deg * pi/180 - (6 * zone - 183) * pi/180) )) / (1 - cos( latitude_deg * pi/180) * sin( (longitude_deg * pi/180 - (6 * zone - 183) * pi/180) )) ))^2 * (cos( latitude_deg * pi/180 ))^2) + 0.9996 * 6399593.625 * (latitude_deg * pi/180 - 0.005054622556 * (latitude_deg * pi/180 + sin( 2 * latitude_deg * pi/180 ) / 2) + 4.258201531e-05 * (3 * (latitude_deg * pi/180 + sin( 2 * latitude_deg * pi/180 ) / 2) + sin( 2 * latitude_deg * pi/180 ) * (cos( latitude_deg * pi/180 ))^2) / 4 - 1.674057895e-07 * (5 * (3 * (latitude_deg * pi/180 + sin( 2 * latitude_deg * pi/180 ) / 2) + sin( 2 * latitude_deg * pi/180 ) * (cos( latitude_deg * pi/180 ))^2) / 4 + sin( 2 * latitude_deg * pi/180 ) * (cos( latitude_deg * pi/180 ))^2 * (cos( latitude_deg * pi/180 ))^2) / 3);

            if hemisphere == mgrs.Hemisphere.South
                northing = northing + 10000000;
            end

            % Truncate to the South West corner of the 1 meter square.
            easting = floor(easting);
            northing = floor(northing);
            
            obj = mgrs.UTM(zone, hemisphere, easting, northing);
        end

    end
end