// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class SevenDayCollection {

    public ArrayList<SevenDayCard> cards = new ArrayList<SevenDayCard>();
    SevenDay sevenDay;

    public SevenDayCollection(VBox box, SevenDay sevenDay) {
        this.sevenDay = sevenDay;
        var iconIndex = 0;
        foreach (var forecast in sevenDay.detailedForecasts) {
            var items = forecast.split(":");
            var day = items[0];
            var longForecast = items[1];
            cards.add(new SevenDayCard(day, longForecast.strip(), sevenDay.icons[iconIndex]));
            box.addLayout(cards.last());
            iconIndex += 1;
        }
    }

    public void update() {
        foreach (var index in range(sevenDay.detailedForecasts.size)) {
            var items = sevenDay.detailedForecasts[index].split(":");
            if (items.length > 1 && cards.size > index && sevenDay.icons.size > index) {
                var day = items[0];
                var longForecast = items[1];
                cards[index].update(day, longForecast.strip(), sevenDay.icons[index]);
            }
        }
    }
}
