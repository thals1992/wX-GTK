// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class CountyLabels {

    public static bool initialized = false;
    public static ArrayList<string> names;
    public static ArrayList<LatLon> location;

    public static void create() {
        if (!initialized) {
            initialized = true;
            names = new ArrayList<string>();
            location = new ArrayList<LatLon>();
            var text = UtilityIO.readTextFileFromResource(GlobalVariables.resDir + "gaz_counties_national.txt");
            var lines = text.split(GlobalVariables.newline);
            foreach (var line in lines[0:lines.length - 2]) {
                var tokens = line.split(",");
                names.add(tokens[1]);
                location.add(new LatLon.fromDouble(Too.Double(tokens[2]), -1.0 * Too.Double(tokens[3])));
            }
        }
    }
}
