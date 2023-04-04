// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class CitiesExtended {

    public static bool initialized = false;
    public static ArrayList<CityExt> cities;

    public static void create() {
        if (!initialized) {
            initialized = true;
            cities = new ArrayList<CityExt>();
            var text = UtilityIO.readTextFileFromResource(GlobalVariables.resDir + "cityall.txt");
            var lines = text.split(GlobalVariables.newline);
            foreach (var line in lines) {
                var items = line.split(",");
                if (items.length > 2) {
                    cities.add(new CityExt(items[0], Too.Double(items[1]), -1.0 * Too.Double(items[2])));
                }
            }
        }
    }
}
