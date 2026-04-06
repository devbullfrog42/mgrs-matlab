function mustBeUtmString(utmString)
    bool = ~mgrs.isUtmString(utmString);
    if any(bool)
        [badr, badc] = ind2sub(size(bool), find(bool));
        badList = string();
        for ii = 1:numel(badr)
            badList = badList + sprintf("    %s at subscript (%d,%d)", utmString(badr(ii),badc(ii)), badr(ii), badc(ii)) + newline;
        end
        error( 'MGRS:invalidUtmStrings', ...
            'The following UTM strings are invalid...\n%s', ...
            badList )
    end
end
