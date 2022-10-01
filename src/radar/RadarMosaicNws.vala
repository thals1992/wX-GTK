// *****************************************************************************
// * Copyright (c) 2020, 2021 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************


using Gee;

class RadarMosaicNws : Window {

    public VBox box = new VBox();
    public Photo photo;
    public ButtonToggle animateButton = new ButtonToggle(Icon.Play, "Animate");
    public ComboBox comboboxSector = new ComboBox(UtilityNwsRadarMosaic.sectors.to_array());
    public HBox boxH = new HBox();
    ObjectAnimate objectAnimate;

    public RadarMosaicNws() {
        setTitle("Radar Mosaic Viewer");
        maximize();
        
        photo = new Photo(this, PhotoSizeEnum.Full);
        objectAnimate = new ObjectAnimate(photo, UtilityNwsRadarMosaic.getAnimation, reload);
        if (!UIPreferences.rememberMosaic) {
            objectAnimate.sector = UtilityNwsRadarMosaic.getNearestMosaic(Location.getLatLonCurrent());
            Utility.writePref("REMEMBER_NWSMOSAIC_SECTOR", objectAnimate.sector);
        } else {
            objectAnimate.sector = Utility.readPref("REMEMBER_NWSMOSAIC_SECTOR", UtilityNwsRadarMosaic.getNearestMosaic(Location.getLatLonCurrent()));
        }
        objectAnimate.product = "rad_rala";
        animateButton.connect(objectAnimate.animateClicked);

        #if GTK4
            close_request.connect(() => { objectAnimate.stopAnimate(); return false; });
        #else
            destroy.connect(objectAnimate.stopAnimate);
        #endif

        comboboxSector.setIndex(UtilityNwsRadarMosaic.sectors.index_of(objectAnimate.sector));
        comboboxSector.connect(changeSector);

        boxH.addWidget(comboboxSector.get());
        boxH.addWidget(animateButton.get());

        box.addLayout(boxH.get());
        box.addWidgetAndCenter(photo.get());
        box.getAndShow(this);

        reload();
    }

    public void reload() {
        objectAnimate.stopAnimate();
        Utility.writePref("REMEMBER_NWSMOSAIC_SECTOR", objectAnimate.sector);
        string url = UtilityNwsRadarMosaic.get(objectAnimate.sector);
        new FutureBytes(url, photo.setBytes);

    }

    public void changeSector() {
        objectAnimate.sector = UtilityNwsRadarMosaic.sectors[comboboxSector.getIndex()];
        objectAnimate.stopAnimate();
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
