# mgrs-matlab

`mgrs-matlab` is a MATLAB package for working with the Military Grid Reference System (MGRS) and the Universal Transverse Mercator (UTM) coordinate system. It supports conversion between latitude/longitude, UTM, and MGRS representations, along with validation helpers and special handling for Norway and Svalbard grid zones.

## Features

- Convert latitude/longitude to UTM coordinates
- Convert latitude/longitude to MGRS coordinates
- Convert UTM to MGRS and MGRS to UTM
- Convert UTM and MGRS back to latitude/longitude
- Validate MGRS and UTM string formats
- Support for grid point reference positions within a 1m cell: center, southwest, northwest, northeast, southeast
- Full package documentation for MATLAB `help` and `doc`

## Package Contents

### Classes

- `mgrs.UTM` — Universal Transverse Mercator coordinate class
- `mgrs.MGRS` — Military Grid Reference System coordinate class
- `mgrs.GridPoint` — Enumeration of grid reference points within a square
- `mgrs.Hemisphere` — Enumeration for North and South hemispheres
- `mgrs.MGRSConstants` — Constant values used for zone, band, and grid calculations

### Functions

- `mgrs.isUtmString` — Validate UTM string format
- `mgrs.isMgrsString` — Validate MGRS string format

### Grid Zone Helpers

- `mgrs.gridZone.getZoneNumber` — Determine UTM zone from latitude/longitude
- `mgrs.gridZone.getBandLetter` — Determine MGRS band letter from latitude
- `mgrs.gridZone.getZoneLimits` — Get longitude bounds for a UTM zone
- `mgrs.gridZone.getBandLimits` — Get latitude bounds for an MGRS band

## Usage

### Convert latitude/longitude to UTM

```matlab
utmCoord = mgrs.UTM.fromLatLon(40.6892, -74.0445);
disp(string(utmCoord));
% Example output: "18N 580735 4504695"
```

### Convert latitude/longitude to MGRS

```matlab
mgrsCoord = mgrs.MGRS.fromLatLon(40.6892, -74.0445);
disp(string(mgrsCoord));
% Example output: "18T WL 80735 04695"
```

### Convert UTM to MGRS

```matlab
utmCoord = mgrs.UTM.fromString("18N 580735 4504695");
mgrsCoord = mgrs.MGRS(utmCoord);
```

### Convert MGRS to UTM

```matlab
mgrsCoord = mgrs.MGRS.fromString("18T WL 80735 04695");
utmCoord = mgrs.UTM(mgrsCoord);
```

### Convert UTM or MGRS to latitude/longitude

```matlab
[lat, lon] = utmCoord.toLatLon();
[lat, lon] = mgrsCoord.toLatLon(mgrs.GridPoint.center);
```

### Validate coordinate strings

```matlab
isValidUtm = mgrs.isUtmString("18N 580735 4504695");
isValidMgrs = mgrs.isMgrsString("18T WL 80735 04695");
```

## Installation

Copy the `+mgrs` package folder into a directory on the MATLAB path, or add the package folder to the path using:

```matlab
addpath('path/to/mgrs');
savepath;
```

## Testing

The repository includes `UTestMgrs.m`, a MATLAB unit test class covering example conversions and format validation. Run tests using:

```matlab
runtests('UTestMgrs')
```

## Notes

- This implementation uses WGS84-based UTM projection formulas
- Special region support is included for Norway and Svalbard
- The package includes comprehensive MATLAB help documentation for classes and functions
