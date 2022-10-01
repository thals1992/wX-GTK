// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class NationalText : Window {

    VBox box = new VBox();
    Text text = new Text();
    string textProduct = "PMDSPD";
    const string prefTokenProduct = "WPCTEXT_PARAM_LAST_USED";
    bool savePref = true;
    HBox buttonBox = new HBox();
    ArrayList<PopoverMenu> popoverMenus = new ArrayList<PopoverMenu>();
    int index = 0;
    Button buttonBack = new Button(Icon.Left, "");
    Button buttonForward = new Button(Icon.Right, "");

    public NationalText(string product) {
        setTitle("National Text Products");
        maximize();
        if (product != "") {
            textProduct = product.ascii_down();
            savePref = false;
        } else {
            textProduct = Utility.readPref(prefTokenProduct, textProduct);
        }
        buttonBack.connect(() => {
            index -= 1;
            index = int.max(index, 0);
            textProduct = UtilityWpcText.labels[index].split(":")[0];
            reload();
        });
        buttonForward.connect(() => {
            index += 1;
            index = int.min(index, UtilityWpcText.labels.length - 1);
            textProduct = UtilityWpcText.labels[index].split(":")[0];
            reload();
        });
        buttonBox.addWidget(buttonBack.get());
        buttonBox.addWidget(buttonForward.get());

        box.addLayout(buttonBox.get());
        box.addWidgetCenter(text.get());
        text.setMargin();
        new ScrolledWindow(this, box);

        UtilityWpcText.init();
        var itemsSoFar = 0;
        foreach (var menu in UtilityWpcText.titles) {
            menu.setList(UtilityWpcText.labels, itemsSoFar);
            itemsSoFar += menu.count;
        }
        foreach (var objectMenuTitle in UtilityWpcText.titles) {
            popoverMenus.add(new PopoverMenu(objectMenuTitle.title, objectMenuTitle.get(), changeProductByCode));
            buttonBox.addWidget(popoverMenus.last().get());
        }
        reload();
    }

    void reload() {
        index = findex(textProduct, UtilityWpcText.labels);
        setTitle(UtilityWpcText.labels[index]);
        new FutureText(textProduct, text.setText);
    }

    void changeProductByCode(string s) {
        textProduct = s.split(":")[0];
        if (savePref) {
            Utility.writePref(prefTokenProduct, textProduct);
        }
        reload();
    }
}
