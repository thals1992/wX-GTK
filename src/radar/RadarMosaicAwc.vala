// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class RadarMosaicAwc : Window {

    ObjectAnimate objectAnimate;
    Photo photo = new Photo.fullScreen();
    ButtonToggle animateButton = new ButtonToggle(Icon.Play, "Animate ctrl-a");
    ComboBox comboboxProduct = new ComboBox(UtilityAwcRadarMosaic.productLabels);
    ComboBox comboboxSector = new ComboBox(UtilityAwcRadarMosaic.sectorLabels);
    HBox boxH = new HBox();
    VBox box = new VBox();

    public RadarMosaicAwc() {
        setTitle("Radar Mosaics");
        maximize();

        photo.setWindow(this);
        objectAnimate = new ObjectAnimate(photo, UtilityAwcRadarMosaic.getAnimation, reload, animateButton);
        objectAnimate.sector = UtilityAwcRadarMosaic.getNearestMosaic(Location.getLatLonCurrent());
        objectAnimate.product = "rad_rala";
        destroy.connect(objectAnimate.stopAnimate); //GTK4_DELETE
        /// close_request.connect(() => { objectAnimate.stopAnimate(); return false; });

        comboboxSector.setIndex(UtilityList.findex(objectAnimate.sector, UtilityAwcRadarMosaic.sectors));
        comboboxSector.connect(changeSector);

        comboboxProduct.setIndex(UtilityList.findex(objectAnimate.product, UtilityAwcRadarMosaic.products));
        comboboxProduct.connect(changeProduct);

        animateButton.connect(objectAnimate.animateClicked);
        boxH.addWidget(comboboxSector.get());
        boxH.addWidget(comboboxProduct.get());
        boxH.addWidget(animateButton.get());
        box.addLayout(boxH.get());
        box.addWidgetCenter(photo.get());
        box.getAndShow(this);
        reload();
    }

    void reload() {
        objectAnimate.stopAnimate();
        var url = UtilityAwcRadarMosaic.get(objectAnimate.product, objectAnimate.sector);
        new FutureBytes(url, photo.setBytes);
    }

    void changeProduct() {
        objectAnimate.product = UtilityAwcRadarMosaic.products[comboboxProduct.getIndex()];
        reload();
    }

    void changeSector() {
        objectAnimate.sector = UtilityAwcRadarMosaic.sectors[comboboxSector.getIndex()];
        reload();
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
