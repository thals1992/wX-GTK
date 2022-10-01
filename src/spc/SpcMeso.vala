// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class SpcMeso : Window {

    ObjectAnimate objectAnimate;
    Photo photo = new Photo.fullScreen();
    int index = 0;
    int indexSector = 0;
    ComboBox comboboxSector = new ComboBox(UtilitySpcMeso.sectors);
    HBox boxH = new HBox();
    VBox boxFav = new VBox();
    VBox box = new VBox();
    HBox imageLayout = new HBox();
    ButtonToggle animateButton = new ButtonToggle(Icon.Play, "Animate ctrl-a");
    const string prefTokenProduct = "SPCMESO1_PARAM_LAST_USED";
    const string prefTokenSector = "SPCMESO1_SECTOR_LAST_USED";
    ArrayList<Button> buttons = new ArrayList<Button>();
    Button buttonBack = new Button(Icon.Left, "");
    Button buttonForward = new Button(Icon.Right, "");
    ArrayList<PopoverMenu> popoverMenus = new ArrayList<PopoverMenu>();

    public SpcMeso() {
        setTitle("SPC Mesoanalysis");
        maximize();

        photo.setWindow(this);
        objectAnimate = new ObjectAnimate(photo, UtilitySpcMesoInputOutput.getAnimation, reload);

        #if GTK4
            close_request.connect(() => { objectAnimate.stopAnimate(); return false; });
        #else
            destroy.connect(objectAnimate.stopAnimate);
        #endif

        objectAnimate.product = Utility.readPref(prefTokenProduct, "pmsl");
        objectAnimate.sector = Utility.readPref(prefTokenSector, "19");
        index = findex(objectAnimate.product, UtilitySpcMeso.products);
        indexSector = findex(objectAnimate.sector, UtilitySpcMeso.sectorCodes);

        buttonBack.connect(() => {
            index -= 1;
            index = int.max(index, 0);
            objectAnimate.product = UtilitySpcMeso.products[index];
            reload();
        });
        buttonForward.connect(() => {
            index += 1;
            index = int.min(index, UtilitySpcMeso.products.length - 1);
            objectAnimate.product = UtilitySpcMeso.products[index];
            reload();
        });

        comboboxSector.setIndex(indexSector);
        comboboxSector.connect(changeSector);

        boxFav.addWidget(comboboxSector.get());
        boxFav.addWidget(animateButton.get());

        var j = 0;
        foreach (var item in UtilitySpcMeso.favList) {
            buttons.add(new Button(Icon.None, ""));
            buttons.last().setText(item);
            buttons.last().connectInt(changeProductForFav, j);
            boxFav.addWidget(buttons.last().get());
            j += 1;
        }

        animateButton.connect(objectAnimate.animateClicked);
        boxH.addWidget(buttonBack.get());
        boxH.addWidget(buttonForward.get());

        box.addLayout(boxH.get());
        imageLayout.addLayout(boxFav.get());
        imageLayout.addWidget(photo.get());
        box.addLayout(imageLayout.get());
        box.getAndShow(this);

        UtilitySpcMeso.init();
        int itemsSoFar = 0;
        foreach (var menu in UtilitySpcMeso.titles) {
            menu.setList(UtilitySpcMeso.labels, itemsSoFar);
            itemsSoFar += menu.count;
        }
        foreach (var objectMenuTitle in UtilitySpcMeso.titles) {
            popoverMenus.add(new PopoverMenu(objectMenuTitle.title, objectMenuTitle.get(), changeProductByCode));
            boxH.addWidget(popoverMenus.last().get());
        }

        reload();
    }

    void changeProductForFav(int i) {
        var s = UtilitySpcMeso.favList[i];
        var index = indexOf(UtilitySpcMeso.products, s);
        objectAnimate.product = UtilitySpcMeso.products[index];
        reload();
    }

    void changeProductByCode(string label) {
        index = findex(label, UtilitySpcMeso.labels);
        objectAnimate.product = UtilitySpcMeso.products[index];
        reload();
    }

    void changeSector() {
        var label = comboboxSector.getValue();
        var index = findex(label, UtilitySpcMeso.sectors);
        objectAnimate.sector = UtilitySpcMeso.sectorCodes[index];
        reload();
    }

    void reload() {
        var url = getUrl();
        Utility.writePref(prefTokenProduct, objectAnimate.product);
        Utility.writePref(prefTokenSector, objectAnimate.sector);
        index = indexOf(UtilitySpcMeso.products, objectAnimate.product);
        setTitle(UtilitySpcMeso.labels[index]);
        new FutureBytes(url, photo.setBytes);
    }

    string getUrl() {
        var gifUrl = ".gif";
        if (objectAnimate.product in UtilitySpcMeso.imgSf) {
            gifUrl = "_sf.gif";
        }
        var url = "https://www.spc.noaa.gov/exper/mesoanalysis/s" + objectAnimate.sector + "/" + objectAnimate.product + "/" + objectAnimate.product + gifUrl;
        return url;
    }

    protected override void processKey(uint keyval) {
        switch (keyval) {
            case Gdk.Key.w:
                close();
                break;
            case Gdk.Key.a:
                if (animateButton.getActive()) {
                    animateButton.setActive(false);
                } else {
                    animateButton.setActive(true);
                }
                break;
            default:
                break;
        }
    }
}
