// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

public static string join(ArrayList<string> list, string s) {
    return string.joinv(s, list.to_array());
}

public static ArrayList<int> range(int to) {
    var z = new ArrayList<int>();
    for (int index = 0; index < to; index++) {
        z.add(index);
    }
    return z;
}

public static ArrayList<int> range2(int from, int to) {
    var z = new ArrayList<int>();
    for (int index = from; index < to; index++) {
        z.add(index);
    }
    return z;
}

public static ArrayList<int> range3(int from, int to, int by) {
    var z = new ArrayList<int>();
    for (int i = from; i < to; i += by) {
        z.add(i);
    }
    return z;
}

public static int findex(string value, string[] items) {
    for (int index = 0; index < items.length; index++) {
        if (items[index].has_prefix(value)) {
            return index;
        }
    }
    return 0;
}

public static int indexOf(string[] items, string value) {
    for (int index = 0; index < items.length; index++) {
        if (items[index] == value) {
            return index;
        }
    }
    return 0;
}

class UtilityList {

    public static ArrayList<string> wrap(string[] a) {
        return new ArrayList<string>.wrap(a);
    }

    public static ArrayList<string> removeDup(ArrayList<string> data) {
        var s = new TreeSet<string>();
        s.add_all(data);
        var l = new ArrayList<string>();
        l.add_all(s);
        return l;
    }

    public static int count(ArrayList<string> al, string data) {
        var count = 0;
        foreach (var item in al) {
            if (item == data) {
                count += 1;
            }
        }
        return count;
    }

    public static ArrayList<string> reversed(ArrayList<string> data) {
        var newList = new ArrayList<string>();
        for (int index = (data.size - 1); index > -1; index -= 1) {
            newList.add(data[index]);
        }
        return newList;
    }
}
