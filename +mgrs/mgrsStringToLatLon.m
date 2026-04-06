function [latitude_deg, longitude_deg] = mgrsStringToLatLon(mgrsString, gridPoint)
%mgrsStringToLatLon Convert an MGRS string directly to latitude and longitude
%   [LAT, LON] = MGRS.MGRSSTRINGTOLATLON(MGRSSTRING) parses the MGRS coordinate
%   string MGRSSTRING and converts it to latitude and longitude using the
%   coordinate center point.
%
%   [LAT, LON] = MGRS.MGRSSTRINGTOLATLON(MGRSSTRING, GRIDPOINT) specifies the
%   grid point within the MGRS square to use when converting. GRIDPOINT may be
%   one of the values from mgrs.GridPoint.
%
%   Example:
%       [lat, lon] = mgrs.mgrsStringToLatLon("31N AA 66021 00000");
%
%   See also: mgrs.MGRS.fromString, mgrs.MGRS.toLatLon,
%   mgrs.GridPoint, mgrs.isMgrsString

    arguments
        mgrsString string {mgrs.internal.mustBeMgrsString}
        gridPoint (1,1) mgrs.GridPoint = "center"
    end

    mgrsObj = mgrs.MGRS.fromString(mgrsString);
    [latitude_deg, longitude_deg] = mgrsObj.toLatLon(gridPoint);
end
