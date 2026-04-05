classdef Hemisphere < uint32
    %HEMISPHERE North/South hemisphere enumeration
    %   The Hemisphere enumeration represents the Northern or Southern
    %   hemisphere for coordinate systems.
    %
    %   Values:
    %       North - Northern hemisphere (latitude >= 0°)
    %       South - Southern hemisphere (latitude < 0°)
    %
    %   Methods:
    %       getInitial - Returns "N" or "S"
    %
    %   Static Methods:
    %       fromLatitude - Determine hemisphere from latitude
    %
    %   Example:
    %       hem = mgrs.Hemisphere.fromLatitude(45.0);  % North
    %       initial = hem.getInitial();  % "N"
    %
    %   See also: mgrs.UTM, mgrs.MGRS

    enumeration
        North (0)
        South (1)
    end

    methods ( Static )

        function obj = fromLatitude(latitude_deg)
            if latitude_deg >= 0
                obj = mgrs.Hemisphere.North;
            else
                obj = mgrs.Hemisphere.South;
            end
        end

    end

    methods

        function initial = getInitial(obj)
            if obj == mgrs.Hemisphere.North
                initial = "N";
            else
                initial = "S";
            end
        end

    end
    
end