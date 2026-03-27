function bool = isBand(letter)

    arguments
        letter char
    end

    letter = upper(letter);

    % 'A' is not a grid zone band letter.
    illegalLetters = letter == 'A';

    % 'B' is not a grid zone band letter.
    illegalLetters = letter == 'B' | illegalLetters;

    % 'I' is not a grid zone band letter.
    illegalLetters = letter == 'I' | illegalLetters;

    % 'O' is not a grid zone band letter.
    illegalLetters = letter == 'O' | illegalLetters;

    % 'Y' is not a grid zone band letter.
    illegalLetters = letter == 'Y' | illegalLetters;

    % 'Z' is not a grid zone band letter.
    illegalLetters = letter == 'Z' | illegalLetters;

    bool = ~illegalLetters;

end