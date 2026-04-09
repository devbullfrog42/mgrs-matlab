classdef TestMgrs < matlab.unittest.TestCase

    properties (Constant)

        testLatitudeBands = struct( ...
            'letter', {'C','C','D','E','F','G','H','J','K','L','M','N','P','Q','R','S','T','U','V','W','X','X'}, ...
            'latitude_deg', {-85,-79,-71,-63,-55,-47,-39,-31,-23,-15,-7,1,9,17,25,33,41,49,57,65,73,85} )

        latitudeBandsBounds = struct( ...
            'letter', {'C','D','E','F','G','H','J','K','L','M','N','P','Q','R','S','T','U','V','W','X'}, ...
            'minLatBound', {-80,-72,-64,-56,-48,-40,-32,-24,-16,-8,0,8,16,24,32,40,48,56,64,72}, ...
            'maxLatBound', {-72,-64,-56,-48,-40,-32,-24,-16,-8,0,8,16,24,32,40,48,56,64,72,84} )

        longitudeZonesBounds = struct( ...
            'minLonBound', {-180,-174,-168,-162,-156,-150,-144,-138,-132,-126,-120,-114,-108,-102,-96,-90,-84,-78,-72,-66,-60,-54,-48,-42,-36,-30,-24,-18,-12,-6,0,6,12,18,24,30,36,42,48,54,60,66,72,78,84,90,96,102,108,114,120,126,132,138,144,150,156,162,168,174}, ...
            'maxLonBound', {-174,-168,-162,-156,-150,-144,-138,-132,-126,-120,-114,-108,-102,-96,-90,-84,-78,-72,-66,-60,-54,-48,-42,-36,-30,-24,-18,-12,-6,0,6,12,18,24,30,36,42,48,54,60,66,72,78,84,90,96,102,108,114,120,126,132,138,144,150,156,162,168,174,180} )

        % Test coordinate locations
        %  1. "Null" island
        %  2. United States Capital Building
        %  3. St. John's Church (Johanneskirken) in Bergen, Norway
        %  4. Cordillera del Paine mountains in Patagonia, Chile
        %  5. Statue of Liberty, NYC, USA
        %  6. Eiffel Tower, Paris, France
        %  7. Sydney Opera House, Sydney, Australia
        %  8. Mount Everest, Nepal
        %  9. Tokyo Tower, Tokyo, Japan
        % 10. Christ the Redeemer, Rio de Janeiro, Brazil
        % 11. Greenwich Observatory, London, United Kingdom
        % 12. Table Mountain, Cape Town, South Africa
        % 13. Burj Khalifa, Dubai, United Arab Emirates
        % 14. Hollywood Sign, Los Angeles, USA
        testCoordinates = struct( ...
            'lat',  {0.0, 38.89012258965883, 60.389206862042705, -50.994763993878266, ...
            40.6892, 48.8584, -33.8568, 27.9881, 35.6586, -22.9519, 51.4779, -33.9249, 25.1972, 34.1341}, ...
            'lon',  {0.0, -77.00902904474066, 5.319198457757746, -72.99966528495905, ...
            -74.0445, 2.2945, 151.2153, 86.9250, 139.7454, -43.2105, -0.0015, 18.4241, 55.2744, -118.3215}, ...
            'utm',  {"31N 166021 0000000", "18N 325758 4306501", "32N 297181 6700424", "18S 640372 4348852", ...
            "18N 580735 4504695", "31N 448252 5411954", "56S 334900 6252288", "45N 492624 3095886", ...
            "54N 386437 3946808", "23S 683476 7460687", "30N 708213 5707235", "34S 261881 6243182", ...
            "40N 326132 2787898", "11N 378150 3777813"}, ...
            'mgrs', {'31N AA 66021 00000', "18S UJ 25758 06501", "32V KN 97181 00424", "18F XJ 40372 48852", ...
            "18T WL 80735 04695", "31U DQ 48252 11954", "56H LH 34900 52288", "45R VL 92624 95886", ...
            "54S UE 86437 46808", "23K PQ 83476 60687", "30U YC 08213 07235", "34H BH 61881 43182", ...
            "40R CN 26132 87898", "11S LT 78150 77813"} )

    end

    methods (Test)

        function testLatLonToUtmString(testCase)
            testData = testCase.testCoordinates;
            for ii = 1:numel(testData)
                testUtm = mgrs.UTM.fromLatLon(testData(ii).lat, testData(ii).lon);
                testCase.verifyMatches( ...
                    string(testUtm), ...
                    testData(ii).utm, ...
                    sprintf('Geolocation %f deg, %f deg converts to UTM string "%s" instead of the expected "%s".', ...
                    testData(ii).lat, testData(ii).lon, string(testUtm), testData(ii).utm) )
            end
        end

        function testLatLonToMgrsString(testCase)
            testData = testCase.testCoordinates;
            for ii = 1:numel(testData)
                testMgrs = mgrs.MGRS.fromLatLon(testData(ii).lat, testData(ii).lon);
                testCase.verifyMatches( ...
                    string(testMgrs), ...
                    testData(ii).mgrs, ...
                    sprintf('Geolocation %f deg, %f deg converts to MGRS string "%s" instead of the expected "%s".', ...
                    testData(ii).lat, testData(ii).lon, string(testMgrs), testData(ii).mgrs) )
            end
        end

        function testUtmStringToLatLon(testCase)
            testData = testCase.testCoordinates;
            utmStrings = [testData.utm];

            [latitude_deg, longitude_deg] = mgrs.utmStringToLatLon(utmStrings);
            [expectedLatitude_deg, expectedLongitude_deg] = mgrs.UTM.fromString(utmStrings).toLatLon();

            testCase.verifyEqual(latitude_deg, expectedLatitude_deg, ...
                'mgrs.utmStringToLatLon did not return the expected latitude values.');
            testCase.verifyEqual(longitude_deg, expectedLongitude_deg, ...
                'mgrs.utmStringToLatLon did not return the expected longitude values.');
        end

        function testMgrsStringToLatLon(testCase)
            testData = testCase.testCoordinates;
            mgrsStrings = [testData.mgrs];

            [latitude_deg, longitude_deg] = mgrs.mgrsStringToLatLon(mgrsStrings);
            [expectedLatitude_deg, expectedLongitude_deg] = mgrs.MGRS.fromString(mgrsStrings).toLatLon();

            testCase.verifyEqual(latitude_deg, expectedLatitude_deg, ...
                'mgrs.mgrsStringToLatLon did not return the expected latitude values.');
            testCase.verifyEqual(longitude_deg, expectedLongitude_deg, ...
                'mgrs.mgrsStringToLatLon did not return the expected longitude values.');
        end

        function testUtmCoordinatesContainLatLon(testCase)
            testData = testCase.testCoordinates;
            testLatitudes_deg = [testData.lat]';
            testLongitudes_deg = [testData.lon]';
            testUtmStr = [testData.utm]';
            testUtmCoords = mgrs.UTM.fromString(testUtmStr);

            % Get the coordinate corners in latitude & longitude.
            testCoordsSW = testUtmCoords.toLatLonPair("southwest");
            testCoordsNE = testUtmCoords.toLatLonPair("northeast");
            testCoordsCenter = testUtmCoords.toLatLonPair("center");

            % Calc the angular distance of the corners from the center.
            swDistance = vecnorm(testCoordsSW - testCoordsCenter, 2, 2);
            neDistance = vecnorm(testCoordsNE - testCoordsCenter, 2, 2);
            maxDistance = max(swDistance, neDistance);

            % Calc the angular distance from the center to the given
            % latitude and longitude.
            testLatLon = [testLatitudes_deg testLongitudes_deg];
            distance = vecnorm(testLatLon - testCoordsCenter, 2, 2);

            % Check if any distances are greater than the max.
            distanceInBound = distance < maxDistance;

            % If any distances are out of bounds, fail the test.
            if any(~distanceInBound)
                distanceOutOfBoundsStr = compose("(%d) %s", find(~distanceInBound), testUtmStr(~distanceInBound));
            else
                distanceOutOfBoundsStr = "";
            end

            testCase.verifyTrue( all(distanceInBound), ...
                sprintf( "The following test latitude & longitude coordinates where out of bounds of their UTM 1x1 m square:\n%s\n", ...
                join(distanceOutOfBoundsStr, newline) ) )
        end

        function testMgrsCoordinatesContainLatLon(testCase)
            testData = testCase.testCoordinates;
            testLatitudes_deg = [testData.lat]';
            testLongitudes_deg = [testData.lon]';
            testMgrsStr = [testData.mgrs]';
            testMgrsCoords = mgrs.MGRS.fromString(testMgrsStr);

            % Get the coordinate corners in latitude & longitude.
            testCoordsSW = testMgrsCoords.toLatLonPair("southwest");
            testCoordsNE = testMgrsCoords.toLatLonPair("northeast");
            testCoordsCenter = testMgrsCoords.toLatLonPair("center");

            % Calc the angular distance of the corners from the center.
            swDistance = vecnorm(testCoordsSW - testCoordsCenter, 2, 2);
            neDistance = vecnorm(testCoordsNE - testCoordsCenter, 2, 2);
            maxDistance = max(swDistance, neDistance);

            % Calc the angular distance from the center to the given
            % latitude and longitude.
            testLatLon = [testLatitudes_deg testLongitudes_deg];
            distance = vecnorm(testLatLon - testCoordsCenter, 2, 2);

            % Check if any distances are greater than the max.
            distanceInBound = distance < maxDistance;

            % If any distances are out of bounds, fail the test.
            if any(~distanceInBound)
                distanceOutOfBoundsStr = compose("(%d) %s", find(~distanceInBound), testMgrsStr(~distanceInBound));
            else
                distanceOutOfBoundsStr = "";
            end

            testCase.verifyTrue( all(distanceInBound), ...
                sprintf( "The following test latitude & longitude coordinates where out of bounds of their MGRS 1x1 m square:\n%s\n", ...
                join(distanceOutOfBoundsStr, newline) ) )
        end

        function testUtmFromLatLonPair(testCase)
            testData = testCase.testCoordinates;
            testLatLonPairs = [testData.lat; testData.lon]';
            testUtm = mgrs.UTM.fromLatLonPair(testLatLonPairs);
            testCase.verifyClass( testUtm, 'mgrs.UTM', ...
                'mgrs.UTM.fromLatLonPair did not return an object of type "mgrs.UTM".' )
        end

        function testMgrsFromLatLonPair(testCase)
            testData = testCase.testCoordinates;
            testLatLonPairs = [testData.lat; testData.lon]';
            testMgrs = mgrs.MGRS.fromLatLonPair(testLatLonPairs);
            testCase.verifyClass( testMgrs, 'mgrs.MGRS', ...
                'mgrs.MGRS.fromLatLonPair did not return an object of type "mgrs.MGRS".' )
        end

        function testMgrsConversionToUtm(testCase)
            testData = testCase.testCoordinates;
            testMgrs = mgrs.MGRS.fromString([testData.mgrs]);
            testUtm = mgrs.UTM(testMgrs);
            testCase.verifyClass( testUtm, 'mgrs.UTM', ...
                'Conversion from MGRS to UTM failed.' )
            for ii = 1:numel(testUtm)
                testCase.verifyMatches( ...
                    string(testUtm(ii)), ...
                    testData(ii).utm, ...
                    sprintf('MGRS string "%s" converts to UTM string "%s" instead of the expected "%s".', ...
                    testData(ii).mgrs, string(testUtm(ii)), testData(ii).utm) )
            end
        end

        function testUtmEqOperator(testCase)
            testData = testCase.testCoordinates;
            testUtm = mgrs.UTM.fromString([testData.utm]);

            testCase.verifyTrue(testUtm(5) == testUtm(5), 'Equality operator failed for scalar-scalar input.')
            testCase.verifyTrue(any(testUtm(5) == testUtm), 'Equality operator failed for array-scalar input.')
            testCase.verifyTrue(any(testUtm == testUtm(5)), 'Equality operator failed for scalar-array input.')
            testCase.verifyTrue(all(testUtm == testUtm), 'Equality operator failed for array-array input.')

            testCase.verifyFalse(testUtm(3) == testUtm(8), 'Equality operator failed for not equal case.')

            testCase.verifyError(@()testUtm == testUtm([4 8]), 'MGRS:sizeDimensionsMustMatch', ...
                'Equality failed to throw the correct error for array-array input with different sizes.')

            testCase.verifyError(@()testUtm == 7, 'MGRS:notUtmClass', ...
                'Equality failed to throw the correct error for wrong input type.')
        end

        function testMgrsEqOperator(testCase)
            testData = testCase.testCoordinates;
            testMgrs = mgrs.MGRS.fromString([testData.mgrs]);

            testCase.verifyTrue(testMgrs(5) == testMgrs(5), 'Equality operator failed for scalar-scalar input.')
            testCase.verifyTrue(any(testMgrs(5) == testMgrs), 'Equality operator failed for array-scalar input.')
            testCase.verifyTrue(any(testMgrs == testMgrs(5)), 'Equality operator failed for scalar-array input.')
            testCase.verifyTrue(all(testMgrs == testMgrs), 'Equality operator failed for array-array input.')

            testCase.verifyFalse(testMgrs(3) == testMgrs(8), 'Equality operator failed for not equal case.')

            testCase.verifyError(@()testMgrs == testMgrs([4 8]), 'MGRS:sizeDimensionsMustMatch', ...
                'Equality failed to throw the correct error for array-array input with different sizes.')

            testCase.verifyError(@()testMgrs == 7, 'MGRS:notMgrsClass', ...
                'Equality failed to throw the correct error for wrong input type.')
        end

        function testUtmArrayToStrings(testCase)
            testData = testCase.testCoordinates;
            sizeTestData = size(testData);
            testUtmArray = mgrs.UTM.fromLatLon([testData.lat], [testData.lon]);
            testCase.verifySize( testUtmArray, sizeTestData, ...
                'mgrs.UTM.fromLatLon returned a UTM array of the wrong size.' )

            testCase.verifyClass( string(testUtmArray), 'string', ...
                'mgrs.UTM.fromLatLon did not return a string array when cast to string.' )
            testCase.verifySize( string(testUtmArray), sizeTestData, ...
                'mgrs.UTM.fromLatLon did not return a string array of the correct size')

            testCase.verifyTrue( iscellstr(cellstr(testUtmArray)), ...
                'mgrs.UTM.cellstr did not return a cell array of character vectors.')

            testCase.verifyClass( char(testUtmArray), 'char', ...
                'mgrs.UTM.char did not return a character array.')
        end

        function testPolarRegionUtm(testCase)
            % Furthest North, non polar UTM
            testUtm = mgrs.UTM.fromLatLon(84,3);
            testCase.verifyEqual( string(testUtm), "31N 500000 9328093", ...
                'A UTM at 84.0N 3.0E did not return the expected specific UTM string "31N 500000 9328093".' )

            % North polar UTM
            testUtm = mgrs.UTM.fromLatLon(84.1,3);
            testCase.verifyEqual( string(testUtm), "00N 000000 0000000", ...
                'A UTM above 84.0N did not return the expected general North polar UTM string "00N 000000 0000000".' )

            % Furthest South, non polar UTM
            testUtm = mgrs.UTM.fromLatLon(-80,3);
            testCase.verifyEqual( string(testUtm), "31S 500000 1118414", ...
                'A UTM at 80.0S 3.0E did not return the expected specific UTM string "31S 500000 1118414".' )

            % South polar UTM
            testUtm = mgrs.UTM.fromLatLon(-80.1,3);
            testCase.verifyEqual( string(testUtm), "00S 000000 0000000", ...
                'A UTM below 80.0S did not return the expected general South polar UTM string "00S 000000 0000000".' )
        end

        function testGetBandLetter(testCase)
            testData = testCase.testLatitudeBands;
            for ii = 1:numel(testData)
                testCase.verifyMatches( ...
                    mgrs.gridZone.getBandLetter(testData(ii).latitude_deg), ...
                    testData(ii).letter, ...
                    sprintf('mgrs.gridZone.getBandLetter(%g) returns ''%s'' when it should return ''%s''.', ...
                    testData(ii).latitude_deg, mgrs.gridZone.getBandLetter(testData(ii).latitude_deg), testData(ii).letter) )
            end
        end

        function testBandBoundaries(testCase)
            testData = testCase.latitudeBandsBounds;
            for ii = 1:numel(testData)
                [actualMinLat_deg, actualMaxLat_deg] = mgrs.gridZone.getBandLimits(testData(ii).letter);

                % verify minimum latitude of band.
                testCase.verifyEqual( ...
                    actualMinLat_deg, testData(ii).minLatBound, ...
                    sprintf('mgrs.gridZone.getBandLimits(''%s'') returns %g deg for the minimum latitude, when %g deg is expected.', ...
                    testData(ii).letter, actualMinLat_deg, testData(ii).minLatBound) )

                % verify maximum latitude of band.
                testCase.verifyEqual( ...
                    actualMaxLat_deg, testData(ii).maxLatBound, ...
                    sprintf('mgrs.gridZone.getBandLimits(''%s'') returns %g deg for the maximum latitude, when %g deg is expected.', ...
                    testData(ii).letter, actualMaxLat_deg, testData(ii).maxLatBound) )
            end
        end

        function testVectorizedBandBoundaries(testCase)
            % This test exposes a bug in the original vectorized code which
            % fails to correct for the larger latitude height of band 'X',
            % when mgrs.gridZone.getBandLimits is called with a character
            % array instead of a scalar.
            testData = testCase.latitudeBandsBounds;
            [actualMinLat_deg, actualMaxLat_deg] = mgrs.gridZone.getBandLimits([testData(1).letter testData(end).letter]);

            % verify minimum latitude for band 'X'
            testCase.verifyEqual( ...
                actualMinLat_deg(end), testData(end).minLatBound, ...
                sprintf('mgrs.gridZone.getBandLimits(''%s'') returns %g deg for the minimum latitude, when %g deg is expected.', ...
                testData(end).letter, actualMinLat_deg(end), testData(end).minLatBound) )

            % verify maximum latitude for band 'X'
            testCase.verifyEqual( ...
                actualMaxLat_deg(end), testData(end).maxLatBound, ...
                sprintf('mgrs.gridZone.getBandLimits(''%s'') returns %g deg for the maximum latitude, when %g deg is expected.', ...
                testData(end).letter, actualMaxLat_deg(end), testData(end).maxLatBound) )
        end

        function testBandIncludesSouthBoundary(testCase)
            minLatBound_deg = mgrs.gridZone.getBandLimits('P');
            actualBandLetter = mgrs.gridZone.getBandLetter(minLatBound_deg);
            testCase.verifyMatches( ...
                actualBandLetter, 'P', ...
                'The southern boundary of the ''P'' band is not included in the ''P'' band, which is not consistent with the standard.' )
        end

        function testZoneBoundaries(testCase)
            testData = testCase.longitudeZonesBounds;
            for ii = 1:numel(testData)
                [actualMinLon_deg, actualMaxLon_deg] = mgrs.gridZone.getZoneLimits(ii);

                % verify minimum longitude of zone.
                testCase.verifyEqual( ...
                    actualMinLon_deg, testData(ii).minLonBound, ...
                    sprintf('mgrs.gridZone.getZoneLimits(%d) returns %g deg for the minimum longitude, when %g deg is expected.', ...
                    ii, actualMinLon_deg, testData(ii).minLonBound) )

                % verify maximum longitude of zone.
                testCase.verifyEqual( ...
                    actualMaxLon_deg, testData(ii).maxLonBound, ...
                    sprintf('mgrs.gridZone.getZoneLimits(%d) returns %g deg for the maximum longitude, when %g deg is expected.', ...
                    ii, actualMaxLon_deg, testData(ii).maxLonBound) )
            end
        end

    end

end