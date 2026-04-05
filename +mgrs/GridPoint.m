classdef GridPoint < uint32
    %GRIDPOINT Grid cell reference point enumeration
    %   The GridPoint enumeration specifies reference points within a
    %   coordinate grid cell for latitude/longitude conversion.
    %
    %   Values:
    %       center    - Center of the grid cell (default)
    %       southwest - Southwest corner of the grid cell
    %       northwest - Northwest corner of the grid cell
    %       northeast - Northeast corner of the grid cell
    %       southeast - Southeast corner of the grid cell
    %
    %   Used with toLatLon() methods to get coordinates at specific
    %   positions within the 1m × 1m grid square.
    %
    %   Example:
    %       utmCoord = mgrs.UTM.fromLatLon(0, 0);
    %       [lat, lon] = utmCoord.toLatLon(mgrs.GridPoint.center);
    %       [lat_sw, lon_sw] = utmCoord.toLatLon(mgrs.GridPoint.southwest);
    %
    %   See also: mgrs.UTM.toLatLon, mgrs.MGRS.toLatLon

    enumeration
        center    (0)
        southwest (1)
        northwest (2)
        northeast (3)
        southeast (4)
    end

end