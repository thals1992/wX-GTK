// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class Hourly : Window {

    VBox box = new VBox();
    Text text = new Text();

    public Hourly() {
        #if GTK4
            print("GTK4\n");
        #else
            print("GTK3\n");
        #endif

        //  new Range (10, 20).each ((i) => {
        //      stdout.printf ("%d\n", i);
        //  });

        //  var test = new ArrayList<string>.wrap({"hi", "there"});
        //  test.foreach_with_index((i, v) => {
        //      print(@"$i $v\n");
        //      return true;
        //  });

        //  test.foreach_index((i) => {
        //      print(@"$i\n");
        //      return true;
        //  });

        //  0 hi
        //  1 there
        //
        //  0
        //  1


        setTitle("Hourly forecast for " + Location.locationName());
        setSize(500, 900);
        text.setFixedWidth();
        box.addWidget(text.get());
        new ScrolledWindow(this, box);
        new FutureText("HOURLY", text.setText);
    }
}
