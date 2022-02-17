/*
Copyright 2013-present Roman Kushnarenko
Licensed under the Apache License, Version 2.0 (the "License")
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
https://github.com/sromku/polygon-contains-point
*/

class ExternalLine {

    ExternalPoint start;
    ExternalPoint end;
    double a = 999999999.0;
    double b = 999999999.0;
    bool vertical = false;

    public ExternalLine(ExternalPoint start, ExternalPoint end) {
        this.start = start;
        this.end = end;
        if (end.x - start.x != 0) {
            a = ((end.y - start.y) / (end.x - start.x));
            b = start.y - a * start.x;
        } else {
            vertical = true;
        }
    }

    public bool isInside(ExternalPoint point) {
        var maxX = start.x > end.x ? start.x : end.x;
        var minX = start.x < end.x ? start.x : end.x;
        var maxY = start.y > end.y ? start.y : end.y;
        var minY = start.y < end.y ? start.y : end.y;
        return ((point.x >= minX && point.x <= maxX) && (point.y >= minY && point.y <= maxY)) ? true : false;
    }

    public bool isVertical() {
        return vertical;
    }

    public double getA() {
        return a;
    }

    public double getB() {
        return b;
    }

    public ExternalPoint getStart() {
        return start;
    }
}
