classdef MGRSConstants
    % Military Grid Reference System Constants
    properties ( Constant )
        % Minimum longitude (deg)
        MIN_LON double = -180.0

        % Maximum longitude (deg)
        MAX_LON double = 180.0

        % Minimum latitude (deg)
        MIN_LAT double = -80.0

        % Maximum latitude (deg)
        MAX_LAT double = 84.0

        % Minimum grid zone number
        MIN_ZONE_NUMBER uint8 = 1

        % Maximum grid zone number
        MAX_ZONE_NUMBER uint8 = 60

        % Grid zone width (deg)
        ZONE_WIDTH double = 6.0

        % Minimum grid band letter
        MIN_BAND_LETTER char = 'C'

        % Maximum grid band letter
        MAX_BAND_LETTER char = 'X'

        % Number of bands
        NUM_BANDS uint8 = 20

        % Grid band height for all but the MAX_BAND_LETTER 'X'
        BAND_HEIGHT double = 8.0

        % Grid band height for the MAX_BAND_LETTER 'X'
        MAX_BAND_HEIGHT double = 12.0

        % Last southern hemisphere band letter
        BAND_LETTER_SOUTH char = 'M'

        % First northern hemisphere band letter
        BAND_LETTER_NORTH char = 'N'

        % Min zone number in Svalbard grid zones
        MIN_SVALBARD_ZONE_NUMBER uint8 = 31

        % Max zone number in Svalbard grid zones
        MAX_SVALBARD_ZONE_NUMBER uint8 = 37

        % Band letter in Svalbard grid zones
        SVALBARD_BAND_LETTER char = mgrs.MGRSConstants.MAX_BAND_LETTER

        % Min zone number in Norway grid zones
        MIN_NORWAY_ZONE_NUMBER uint8 = 31

        % Max zone number in Norway grid zones
        MAX_NORWAY_ZONE_NUMBER uint8 = 32

        % Band letter in Norway grid zones
        NORWAY_BAND_LETTER char = 'V'

        % 100,000 m square column letters
        COLUMN_LETTERS = {'ABCDEFGH','JKLMNPQR','STUVWXYZ'}

        % 100,000 m square row letters
        ROW_LETTERS = {'ABCDEFGHJKLMNPQRSTUV','FGHJKLMNPQRSTUVABCDE'}
    end
end