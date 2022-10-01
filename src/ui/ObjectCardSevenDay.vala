// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class ObjectCardSevenDay {

    public ArrayList<SevenDayCard> cards = new ArrayList<SevenDayCard>();

    public ObjectCardSevenDay(VBox box, ArrayList<string> forecasts, ArrayList<string> icons) {
        var iconIndex = 0;
        foreach (var forecast in forecasts) {
            var items = forecast.split(":");
            var day = items[0];
            var longForecast = items[1];
            cards.add(new SevenDayCard(day, longForecast.strip(), icons[iconIndex]));
            box.addWidget(cards.last().get());
            iconIndex += 1;
        }
    }

    public void update(ArrayList<string> forecasts, ArrayList<string> icons) {
        foreach (var index in range(forecasts.size)) {
            var items = forecasts[index].split(":");
            if (items.length > 1 && cards.size > index && icons.size > index) {
                var day = items[0];
                var longForecast = items[1];
                cards[index].update(day, longForecast.strip(), icons[index]);
            }
        }
    }
}
