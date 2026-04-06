function mustBeMgrsString(mgrsString)
    bool = ~mgrs.isMgrsString(mgrsString);
    if any(bool)
        [badr, badc] = ind2sub(size(bool), find(bool));
        badList = string();
        for ii = 1:numel(badr)
            badList = badList + sprintf("    %s at subscript (%d,%d)", mgrsString(badr(ii),badc(ii)), badr(ii), badc(ii)) + newline;
        end
        error( 'MGRS:invalidMgrsStrings', ...
            'The following MGRS strings are invalid...\n%s', ...
            badList )
    end
end
