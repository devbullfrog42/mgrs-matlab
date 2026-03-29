function [zone, hemisphere, easting, northing] = latLonToUtm(latitude_deg, longitude_deg)
    % mgrs.internal.latLonToUtm converts latitude and longitude to UTM coordinate parameters
    % Adapted from NGA MGRS Java library https://github.com/ngageoint/mgrs-java

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

end