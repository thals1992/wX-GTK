// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class GoesViewer : Window {

    ObjectAnimate objectAnimate;
    Photo photo;
    ComboBox comboboxSector = new ComboBox(UtilityGoes.sectors);
    ComboBox comboboxProduct = new ComboBox(UtilityGoes.labels);
    ComboBox comboboxCount = new ComboBox({"6", "12", "18", "24"});
    HBox boxH = new HBox();
    VBox box = new VBox();
    ButtonToggle animateButton = new ButtonToggle(Icon.Play, "Animate ctrl-a");
    bool goesFloater = false;
    string goesFloaterUrl = "";

    public GoesViewer(string url, string product = "", string sector = "") {
        setTitle("GOES Images");
        maximize();
        if (url != "") {
            goesFloater = true;
            goesFloaterUrl = url;
        }
        photo = new Photo(this, PhotoSizeEnum.Full);
        objectAnimate = new ObjectAnimate(photo, UtilityGoes.getAnimation, reload);

        if (sector == "") {
            if (!UIPreferences.rememberGOES) {
                objectAnimate.sector = UtilityGoes.getNearest(Location.getLatLonCurrent());
            } else {
                objectAnimate.sector = Utility.readPref("REMEMBER_GOES_SECTOR", UtilityGoes.getNearest(Location.getLatLonCurrent()));
            }
        } else {
            objectAnimate.sector = sector;
        }
        if (product == "") {
            objectAnimate.product = "GEOCOLOR";
        } else {
            objectAnimate.product = product;
        }
        if (goesFloater) {
            objectAnimate.getFunction = UtilityGoes.getAnimationGoesFloater;
            objectAnimate.sector = goesFloaterUrl;
        }

        #if GTK4
            close_request.connect(() => { objectAnimate.stopAnimate(); return false; });
        #else
            destroy.connect(objectAnimate.stopAnimate);
        #endif

        comboboxSector.setIndexByValue(objectAnimate.sector);
        comboboxSector.connect(changeSector);

        comboboxProduct.setIndex(findex(objectAnimate.product, UtilityGoes.productCodes.to_array()));
        comboboxProduct.connect(changeProduct);

        comboboxCount.setIndex(1);
        comboboxCount.connect(changeCount);

        animateButton.connect(objectAnimate.animateClicked);
        if (!goesFloater) {
            boxH.addWidget(comboboxSector.get());
        }
        boxH.addWidget(comboboxProduct.get());
        boxH.addWidget(comboboxCount.get());
        boxH.addWidget(animateButton.get());
        box.addLayout(boxH.get());
        box.addWidgetCenter(photo.get());
        box.getAndShow(this);
        reload();
    }

    void changeProduct() {
        objectAnimate.product = UtilityGoes.productCodes[comboboxProduct.getIndex()];
        reload();
    }

    void changeSector() {
        objectAnimate.sector = comboboxSector.getValue().split(":")[0];
        reload();
    }

    void changeCount() {
        objectAnimate.frameCount = Too.Int(comboboxCount.getValue());
    }

    void reload() {
        if (!goesFloater) {
            Utility.writePref("REMEMBER_GOES_SECTOR", objectAnimate.sector);
            new FutureBytes(UtilityGoes.getImage(objectAnimate.product, objectAnimate.sector), photo.setBytes);
        } else {
            new FutureBytes(UtilityGoes.getImageGoesFloater(goesFloaterUrl, objectAnimate.product), photo.setBytes);
        }
    }

    protected override void processKey(uint keyval) {
        switch (keyval) {
            case Gdk.Key.w:
                close();
                break;
            case Gdk.Key.a:
                //  objectAnimate.animateClicked();
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
