classdef Hemisphere < uint32

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