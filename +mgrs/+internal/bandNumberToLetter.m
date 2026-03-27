function letter = bandNumberToLetter(number)

    arguments
        number uint8 {mustBeLessThan(number,20)}
    end

    % Convert to the ASCII values for capital letters, starting with 'C'.
    bandCharCode = number + uint8(mgrs.MGRSConstants.MIN_BAND_LETTER);

    % The MGRS standard does not use 'I' and 'O' for latitude bands to
    % avoid confusion with '1' and '0' respectively.

    % Skip 'I' by adding 1 to any codes >= 'I'.
    bandCharCode(bandCharCode >= uint8('I')) = bandCharCode(bandCharCode >= uint8('I')) + 1;

    % Skip 'O' by adding 1 to any codes >= 'O'.
    bandCharCode(bandCharCode >= uint8('O')) = bandCharCode(bandCharCode >= uint8('O')) + 1;

    % Cast to ASCII characters.
    letter = char(bandCharCode);

end