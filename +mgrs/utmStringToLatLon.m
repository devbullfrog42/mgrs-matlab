function [latitude_deg, longitude_deg] = utmStringToLatLon(utmString, gridPoint)
%utmStringToLatLon Convert a UTM string directly to latitude and longitude
%   [LAT, LON] = MGRS.UTMSTRINGTOLATLON(UTMSTRING) parses the UTM coordinate
%   string UTMSTRING and converts it to latitude and longitude using the
%   coordinate center point.
%
%   [LAT, LON] = MGRS.UTMSTRINGTOLATLON(UTMSTRING, GRIDPOINT) specifies the
%   grid point within the UTM square to use when converting. GRIDPOINT may be
%   one of the values from mgrs.GridPoint.
%
%   Example:
%       [lat, lon] = mgrs.utmStringToLatLon("31N 166021 0000000");
%
%   See also: mgrs.UTM.fromString, mgrs.UTM.toLatLon,
%   mgrs.GridPoint, mgrs.isUtmString

    arguments
        utmString string {mgrs.internal.mustBeUtmString}
        gridPoint (1,1) mgrs.GridPoint = "center"
    end

    utmObj = mgrs.UTM.fromString(utmString);
    [latitude_deg, longitude_deg] = utmObj.toLatLon(gridPoint);
end
