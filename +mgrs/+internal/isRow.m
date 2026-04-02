function bool = isRow(letter, zone)

    arguments
        letter char
        zone
    end

    letter = upper(letter);

    % Calc the zone modulo 2.
    zoneSet = mod(zone-1,2) + 1;

    bool = any(letter == mgrs.MGRSConstants.ROW_LETTERS{zoneSet});
end