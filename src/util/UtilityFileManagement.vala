// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class UtilityFileManagement {

    public static string getHomeDirectory() {
        return GLib.Environment.get_home_dir();
    }

    public static void mkdir(string d) {
        try {
            var file = GLib.File.new_for_path(d);
            file.make_directory_with_parents();
        } catch (Error e) {
            // print ("Error: %s\n", e.message);
        }
    }
}
