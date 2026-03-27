function number = bandLetterToNumber(letter)

    arguments
        letter char {mgrs.internal.mustBeBand(letter)}
    end

    % Convert from the ASCII values for capital letters, starting with 'C'.
    bandCharCode = uint8(letter);

    % The MGRS standard does not use 'I' and 'O' for latitude bands to
    % avoid confusion with '1' and '0' respectively.

    % Shifting letters greater than 'O' down by 1.
    bandCharCode(bandCharCode > uint8('O')) = bandCharCode(bandCharCode > uint8('O')) - 1;

    % Shifting letters greater than 'I' down by 1.
    bandCharCode(bandCharCode > uint8('I')) = bandCharCode(bandCharCode > uint8('I')) - 1;

    % Shifting into the band number range.
    number = bandCharCode - uint8(mgrs.MGRSConstants.MIN_BAND_LETTER);

end