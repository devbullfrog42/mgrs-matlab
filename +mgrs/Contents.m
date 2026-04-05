% Contents of mgrs package
%
% Classes:
%   MGRS          - Military Grid Reference System coordinate class
%   UTM           - Universal Transverse Mercator coordinate class
%   GridPoint     - Enumeration for grid cell reference points
%   Hemisphere    - Enumeration for North/South hemispheres
%   MGRSConstants - Constants used in MGRS/UTM calculations
%
% Functions:
%   isMgrsString  - Validate MGRS coordinate string format
%   isUtmString   - Validate UTM coordinate string format
%
% Grid Zone Functions:
%   getBandLetter     - Get latitude band letter from latitude
%   getBandLimits     - Get latitude limits for a band letter
%   getZoneNumber     - Get UTM zone number from coordinates
%   getZoneLimits     - Get longitude limits for a zone number
%
% See also: help, doc