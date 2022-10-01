// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

class UtilityWpcFronts {

    static DownloadTimer timer;
    public static ArrayList<PressureCenter> pressureCenters;
    public static ArrayList<Fronts> fronts;
    static bool initialized = false;

    public static void addColdFrontTriangles(Fronts front, string[] tokens) {
        var length = 0.4; // size of trianle
        var startIndex = 0;
        var indexIncrement = 1;
        if (front.type == FrontTypeEnum.ocfnt) {
            startIndex = 1;
            indexIncrement = 2;
        }
        foreach (var index in range3(startIndex, tokens.length, indexIncrement)) {
            var coordinates = parseLatLon(tokens[index]);
            if (index < (tokens.length - 1)) {
                var coordinates2 = parseLatLon(tokens[index + 1]);
                var distance = UtilityMath.distanceOfLine(coordinates[0], coordinates[1], coordinates2[0], coordinates2[1]);
                var numberOfTriangles = (int)Math.floor(distance / length);
                // construct two lines which will consist of adding 4 points
                foreach (var pointNumber in range3(1, numberOfTriangles, 2)) {
                    var x1 = coordinates[0] + ((coordinates2[0] - coordinates[0]) * length * pointNumber) / distance;
                    var y1 = coordinates[1] + ((coordinates2[1] - coordinates[1]) * length * pointNumber) / distance;
                    var x3 = coordinates[0] + ((coordinates2[0] - coordinates[0]) * length * (pointNumber + 1)) / distance;
                    var y3 = coordinates[1] + ((coordinates2[1] - coordinates[1]) * length * (pointNumber + 1)) / distance;
                    var p2 = UtilityMath.computeTipPoint(x1, y1, x3, y3, true);
                    var x2 = p2[0];
                    var y2 = p2[1];
                    front.coordinates.add(new LatLon.fromDouble(x1, y1));
                    front.coordinates.add(new LatLon.fromDouble(x2, y2));
                    front.coordinates.add(new LatLon.fromDouble(x2, y2));
                    front.coordinates.add(new LatLon.fromDouble(x3, y3));
                }
            }
        }
    }

    public static void addWarmFrontSemicircles(Fronts front, string[] tokens) {
        var length = 0.4; // size of trianle
        var startIndex = 0;
        var indexIncrement = 1;
        if (front.type == FrontTypeEnum.ocfnt) {
            startIndex = 2;
            indexIncrement = 2;
            length = 0.2;
        }
        foreach (var index in range3(startIndex, tokens.length, indexIncrement)) {
            var coordinates = parseLatLon(tokens[index]);
            if (index < (tokens.length - 1)) {
                var coordinates2 = parseLatLon(tokens[index + 1]);
                var distance = UtilityMath.distanceOfLine(coordinates[0], coordinates[1], coordinates2[0], coordinates2[1]);
                var numberOfTriangles = (int)Math.floor(distance / length);
                // construct two lines which will consist of adding 4 points
                foreach (var pointNumber in range3(1, numberOfTriangles, 4)) {
                    var x1 = coordinates[0] + ((coordinates2[0] - coordinates[0]) * length * pointNumber) / distance;
                    var y1 = coordinates[1] + ((coordinates2[1] - coordinates[1]) * length * pointNumber) / distance;
                    var center1 = coordinates[0] + ((coordinates2[0] - coordinates[0]) * length * (pointNumber + 0.5)) / distance;
                    var center2 = coordinates[1] + ((coordinates2[1] - coordinates[1]) * length * (pointNumber + 0.5)) / distance;
                    var x3 = coordinates[0] + ((coordinates2[0] - coordinates[0]) * length * (pointNumber + 1)) / distance;
                    var y3 = coordinates[1] + ((coordinates2[1] - coordinates[1]) * length * (pointNumber + 1)) / distance;
                    front.coordinates.add(new LatLon.fromDouble(x1, y1));
                    var slices = 20;
                    var step = Math.PI / slices;
                    var rotation = 1.0;
                    var xDiff = x3 - x1;
                    var yDiff = y3 - y1;
                    var angle = Math.atan2(yDiff, xDiff) * 180.0 / Math.PI;
                    var sliceStart = slices * (int)(angle / 180.0);
                    foreach (var i in range3(sliceStart, 1 + slices + sliceStart, 1)) {
                        var x = rotation * length * Math.cos(step * i) + center1;
                        var y = rotation * length * Math.sin(step * i) + center2;
                        front.coordinates.add(new LatLon.fromDouble(x, y));
                        front.coordinates.add(new LatLon.fromDouble(x, y));
                    }
                    front.coordinates.add(new LatLon.fromDouble(x3, y3));
                }
            }
        }
    }

    public static void addFrontDataStnryWarm(Fronts front, string[] tokens) {
        foreach (var index in range3(0, tokens.length, 1)) {
            var coordinates = parseLatLon(tokens[index]);
            if (index != 0 && index != (tokens.length - 1)) {
                front.coordinates.add(new LatLon.fromDouble(coordinates[0], coordinates[1]));
            }
        }
    }

    public static void addFrontDataTrof(Fronts front, string[] tokens) {
        var fraction = 0.8;
        foreach (var index in range3(0, tokens.length - 1, 1)) {
            var coordinates = parseLatLon(tokens[index]);
            front.coordinates.add(new LatLon.fromDouble(coordinates[0], coordinates[1]));
            var oldCoordinates = parseLatLon(tokens[index + 1]);
            var coord = UtilityMath.computeMiddishPoint(coordinates[0], coordinates[1], oldCoordinates[0], oldCoordinates[1], fraction);
            front.coordinates.add(new LatLon.fromDouble(coord[0], coord[1]));
        }
    }

    public static void addFrontData(Fronts front, string[] tokens) {
        foreach (var index in range3(0, tokens.length, 1)) {
            var coordinates = parseLatLon(tokens[index]);
            front.coordinates.add(new LatLon.fromDouble(coordinates[0], coordinates[1]));
            if (index != 0 && index != (tokens.length - 1)) {
                front.coordinates.add(new LatLon.fromDouble(coordinates[0], coordinates[1]));
            }
        }
    }

    public static double[] parseLatLon(string data) {
        if (data.length != 7) {
            return {0.0, 0.0};
        } else {
            var lat = Too.Double(data.substring(0, 2) + "." + data.substring(2, 3));
            var lon = 0.0;
            if (data[3] == '0') {
                lon = Too.Double(data.substring(4, 2) + "." + data.substring(6, 1));
            } else {
                lon = Too.Double(data.substring(3, 3) + "." + data.substring(6, 1));
            }
            return {lat, lon};
        }
    }

    public static void get() {
        if (!initialized) {
            timer = new DownloadTimer("WPC FRONTS");
            pressureCenters = new ArrayList<PressureCenter>();
            fronts = new ArrayList<Fronts>();
            initialized = true;
        }
        if (timer.isRefreshNeeded()) {
            pressureCenters = new ArrayList<PressureCenter>();
            fronts = new ArrayList<Fronts>();
            var urlBlob = GlobalVariables.nwsWPCwebsitePrefix + "/basicwx/coded_srp.txt";
            var html = UtilityIO.getHtml(urlBlob);
            html = html.replace(GlobalVariables.newline, GlobalVariables.sep);
            var timestamp = UtilityString.parse(html, "SURFACE PROG VALID ([0-9]{12}Z)");
            Utility.writePref("WPCFRONTSTIMESTAMP", timestamp);
            html = UtilityString.parse(html, "SURFACE PROG VALID [0-9]{12}Z(.*?)" + GlobalVariables.sep + " " + GlobalVariables.sep);
            html = html.replace(GlobalVariables.sep, GlobalVariables.newline);
            var lines = html.split(GlobalVariables.newline);
            foreach (var lineIndex in range(lines.length)) {
                var data = lines[lineIndex];
                if (lineIndex < lines.length - 1) {
                    if (lines[lineIndex + 1][0] != 'H' &&
                            lines[lineIndex + 1][0] != 'L' &&
                            lines[lineIndex + 1][0] != 'C' &&
                            lines[lineIndex + 1][0] != 'S' &&
                            lines[lineIndex + 1][0] != 'O' &&
                            lines[lineIndex + 1][0] != 'T' &&
                            lines[lineIndex + 1][0] != 'W') {
                        data = data + lines[lineIndex + 1];
                        if (lineIndex < lines.length - 2 &&
                                lines[lineIndex + 2][0] != 'H' &&
                                lines[lineIndex + 2][0] != 'L' &&
                                lines[lineIndex + 2][0] != 'C' &&
                                lines[lineIndex + 2][0] != 'S' &&
                                lines[lineIndex + 2][0] != 'O' &&
                                lines[lineIndex + 2][0] != 'T' &&
                                lines[lineIndex + 2][0] != 'W') {
                            lines[lineIndex] = lines[lineIndex] + lines[lineIndex + 2];
                        }
                    }
                }
                var tokensList = UtilityList.wrap(data.strip().split(" "));
                if (tokensList.size > 1) {
                    var type = tokensList[0];
                    tokensList.remove_at(0);
                    var tokens = tokensList.to_array();
                    switch (type) {
                        case "HIGHS":
                            foreach (var index in range3(0, tokens.length, 2)) {
                                if (tokens.length > index + 2) {
                                    var coordinates = parseLatLon(tokens[index + 1]);
                                    pressureCenters.add(new PressureCenter(PressureCenterTypeEnum.high, tokens[index], coordinates[0], coordinates[1]));
                                }
                            }
                            break;
                        case "LOWS":
                            foreach (var index in range3(0, tokens.length, 2)) {
                                if (tokens.length > index + 2) {
                                    var coordinates = parseLatLon(tokens[index + 1]);
                                    pressureCenters.add(new PressureCenter(PressureCenterTypeEnum.low, tokens[index], coordinates[0], coordinates[1]));
                                }
                            }
                            break;
                        case "COLD":
                            var front = new Fronts(FrontTypeEnum.cold);
                            addFrontData(front, tokens);
                            addColdFrontTriangles(front, tokens);
                            fronts.add(front);
                            break;
                        case "STNRY":
                            var front = new Fronts(FrontTypeEnum.stnry);
                            addFrontData(front, tokens);
                            fronts.add(front);
                            var frontStWarm = new Fronts(FrontTypeEnum.stnryWarm);
                            addFrontDataStnryWarm(frontStWarm, tokens);
                            fronts.add(frontStWarm);
                            break;
                        case "WARM":
                            var front = new Fronts(FrontTypeEnum.warm);
                            addFrontData(front, tokens);
                            addWarmFrontSemicircles(front, tokens);
                            fronts.add(front);
                            break;
                        case "TROF":
                            var front = new Fronts(FrontTypeEnum.trof);
                            addFrontDataTrof(front, tokens);
                            fronts.add(front);
                            break;
                        case "OCFNT":
                            var front = new Fronts(FrontTypeEnum.ocfnt);
                            addFrontData(front, tokens);
                            addColdFrontTriangles(front, tokens);
                            addWarmFrontSemicircles(front, tokens);
                            fronts.add(front);
                            break;
                        default:
                            break;
                    }
                }
            }
        }
    }
}
