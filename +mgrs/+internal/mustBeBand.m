function mustBeBand(letter)
    if ~all(mgrs.internal.isBand(letter))
        error('MGRS:illegalBandLetter', 'An MGRS/UTM grid zone band letter may not be ''A'', ''B'', ''I'', ''O'', ''Y'' or ''Z''.')
    end
end
