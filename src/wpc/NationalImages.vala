// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class NationalImages : Window {

    const string prefToken = "WPCIMG_PARAM_LAST_USED";
    Photo photo = new Photo.fullScreen();
    VBox box = new VBox();
    HBox buttonBox = new HBox();
    ArrayList<PopoverMenu> popoverMenus = new ArrayList<PopoverMenu>();
    int index = 0;
    Button buttonBack = new Button(Icon.Left, "");
    Button buttonForward = new Button(Icon.Right, "");

    public NationalImages() {
        setTitle("National Images");
        maximize();
        index = Utility.readPrefInt(prefToken, 0);
        if (index < 0) {
            index = 0;
        }
        photo.setWindow(this);
        buttonBack.connect(() => {
            index -= 1;
            index = int.max(index, 0);
            reload();
        });
        buttonForward.connect(() => {
            index += 1;
            index = int.min(index, UtilityWpcImages.urls.length - 1);
            reload();
        });
        buttonBox.addWidget(buttonBack.get());
        buttonBox.addWidget(buttonForward.get());

        box.addLayout(buttonBox.get());
        box.addWidgetCenter(photo.get());
        box.getAndShow(this);

        UtilityWpcImages.init();
        var itemsSoFar = 0;
        foreach (var menu in UtilityWpcImages.titles) {
            menu.setList(UtilityWpcImages.labels, itemsSoFar);
            itemsSoFar += menu.count;
        }
        foreach (var objectMenuTitle in UtilityWpcImages.titles) {
            popoverMenus.add(new PopoverMenu(objectMenuTitle.title, objectMenuTitle.get(), changeProductByCode));
            buttonBox.addWidget(popoverMenus.last().get());
        }

        reload();
    }

    void reload() {
        Utility.writePrefInt(prefToken, index);
        var url = UtilityWpcImages.urls[index];
        setTitle(UtilityWpcImages.labels[index]);
        new FutureBytes(url, photo.setBytes);
    }

    void changeProductByCode(string s) {
        index = UtilityList.findex(s, UtilityWpcImages.labels);
        reload();
    }
}
