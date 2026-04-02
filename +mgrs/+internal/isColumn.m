function bool = isColumn(letter, zone)

    arguments
        letter char
        zone
    end

    letter = upper(letter);

    % Calc the zone modulo 3.
    zoneSet = mod(zone-1,3) + 1;

    bool = any(letter == mgrs.MGRSConstants.COLUMN_LETTERS{zoneSet});
end