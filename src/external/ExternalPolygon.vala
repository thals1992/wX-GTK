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

The 2D polygon. <br>

    @see {@link Builder}
    @author Roman Kushnarenko (sromku@gmail.com)
*/

using Gee;

class ExternalPolygon {

    BoundingBox boundingBox;
    ArrayList<ExternalLine> sides;

    public ExternalPolygon(ArrayList<ExternalLine> sides, BoundingBox boundingBox) {
        this.sides = sides;
        this.boundingBox = boundingBox;
    }

    public static Builder builder() {
        return new Builder();
    }

    public static bool polygonContainsPoint(LatLon latLon, ArrayList<LatLon> latLons) {
        Builder polygonFrame = ExternalPolygon.builder();
        foreach (var l in latLons) {
            polygonFrame.addVertex(new ExternalPoint(l.lat(), l.lon()));
        }
        ExternalPolygon polygonShape = polygonFrame.build();
        var contains = polygonShape.contains(latLon.asPoint());
        return contains;
    }

    public bool contains(ExternalPoint point) {
        if (inBoundingBox(point)) {
            ExternalLine ray = createRay(point);
            var intersection = 0;
            foreach (var side in sides) {
                if (intersect(ray, side)) {
                    intersection += 1;
                }
            }
            // If the number of intersections is odd, then the point is inside the polygon
            if (intersection % 2 != 0) {
                return true;
            }
        }
        return false;
    }

    public bool intersect(ExternalLine ray, ExternalLine side) {
        ExternalPoint intersectPoint;
        // if both vectors aren"t from the kind of x=1 lines then go into
        if (!ray.isVertical() && !side.isVertical()) {
            // check if both vectors are parallel. If they are parallel then no intersection point will exist
            if (ray.getA() - side.getA() == 0) {
                return false;
            }
            var x = ((side.getB() - ray.getB()) / (ray.getA() - side.getA())); // x = (b2-b1)/(a1-a2)
            var y = side.getA() * x + side.getB(); // y = a2*x+b2
            intersectPoint = new ExternalPoint(x, y);
        } else if (ray.isVertical() && !side.isVertical()) {
            var x = ray.getStart().x;
            var y = side.getA() * x + side.getB();
            intersectPoint = new ExternalPoint(x, y);
        } else if (!ray.isVertical() && side.isVertical()) {
            var x = side.getStart().x;
            var y = ray.getA() * x + ray.getB();
            intersectPoint = new ExternalPoint(x, y);
        } else {
            return false;
        }
        return (side.isInside(intersectPoint) && ray.isInside(intersectPoint)) ? true : false;
    }

    public ExternalLine createRay(ExternalPoint point) {
        // create outside point
        var epsilon = (boundingBox.xMax - boundingBox.xMin) / 10e6;
        var outsidePoint = new ExternalPoint(boundingBox.xMin - epsilon, boundingBox.yMin);
        var vector = new ExternalLine(outsidePoint, point);
        return vector;
    }

    bool inBoundingBox(ExternalPoint point) {
        return (point.x < boundingBox.xMin || point.x > boundingBox.xMax || point.y < boundingBox.yMin || point.y > boundingBox.yMax) ? false : true;
    }
}
